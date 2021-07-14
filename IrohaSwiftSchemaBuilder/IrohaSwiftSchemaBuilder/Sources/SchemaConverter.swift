//
// Copyright 2021 Soramitsu Co., Ltd.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation

struct SchemaConverter {
    
    enum Error: LocalizedError {
        case invalidSchema
    }
    
    private(set) var schema: [String: TypeMetadata]
    let fileManager: FileManager
    let importFrameworks: [String]
    private var namespacesWritten = Set<String>()
    
    init(schema: [String: TypeMetadata], fileManager: FileManager, importFrameworks: [String]) {
        self.schema = schema
        self.fileManager = fileManager
        self.importFrameworks = importFrameworks
    }
    
    mutating func convert() -> LocalizedError? {
        unwrapNames()
        let namespacePaths = resolveNamespacePaths()
        for (typeMetadata, namespacePath) in namespacePaths {
            if let error = write(typeMetadata: typeMetadata, namespacePath: namespacePath) {
                return error
            }
        }
        
        for contents in Rules.finalize() {
            if let error = fileManager.writeFile(at: stubFilename, contents: contents, append: true) {
                return error
            }
        }
        
        return nil
    }
}

// MARK: - Namespaces

private extension String {
    
    var capitalizingFirstLetter: String {
        prefix(1).capitalized + dropFirst()
    }
    
    var upperCamelCased: String {
        split(separator: "_").map { String($0).capitalizingFirstLetter }.joined()
    }
    
    var loweringFirstLetter: String {
        prefix(1).lowercased() + dropFirst()
    }
    
    var lowerCamelCased: String {
        upperCamelCased.loweringFirstLetter
    }
}

private protocol NamespaceResolver {
    func typeName(for: String) -> String
}

extension SchemaConverter: NamespaceResolver {
    
    private mutating func unwrapNames() {
        schema.forEach { name, metadata in
            let unwrappedName = unwrapTypeName(for: name)
            if unwrappedName != name {
                schema.removeValue(forKey: name)
            }
        }
    }
    
    private func resolveNamespacePaths() -> [(TypeMetadata, [String])] {
        schema.values.compactMap { metadata in
            resolveNamespacePath(typeMetadata: metadata).map { (metadata, $0) }
        }
    }
    
    private func resolveNamespacePath(typeMetadata: TypeMetadata) -> [String]? {
        switch typeMetadata.kind {
        case .struct, .tupleStruct, .enum:
            return namespacePath(for: typeMetadata.name)
        default:
            return nil
        }
    }
    
    private func nativeType(for name: String) -> String {
        switch name {
        case "u8": return "UInt8"
        case "u32": return "UInt32"
        case "u64": return "UInt64"
        case "u128": return "UInt128"
        case "bool": return "Bool"
        case "Vec": return "Array"
        case "Map", "BTreeMap": return "Dictionary"
        case "Set", "BTreeSet": return "Array" // consider Array for now, Set requires it to be hashable, which is hard for some types to implement atm
        default: return name
        }
    }
    
    private func namespacePath(for name: String) -> [String] {
        let parts = nativeType(for: name).components(separatedBy: "::")
        guard parts.count > 1 else { return [name] }
        return [parts.dropLast().map { $0.trimmingCharacters(in: .whitespacesAndNewlines).upperCamelCased }.joined(), parts.last!]
    }
    
    func typeName(for name: String) -> String {
        namespacePath(for: name).joined(separator: ".")
    }
    
    private func unwrapTypeName(for name: String) -> String {
        for type in Rules.ignoredWrappingTypes {
            if name.starts(with: type) {
                return name
                    .replacingOccurrences(of: type, with: "")
                    .replacingOccurrences(of: "<", with: "")
                    .replacingOccurrences(of: ">", with: "")
            }
        }
        
        return name
    }
}

// MARK: - Variable name fix

private protocol NameFixer {
    func fixVariableName(_ name: String) -> String
    func fixVariableType(_ name: String) -> String
}

extension SchemaConverter: NameFixer {
    func fixVariableName(_ name: String) -> String {
        let name = name.lowerCamelCased
        if Rules.keywords.contains(name) {
            return "`\(name)`"
        }
        
        return name
    }
    
    func fixVariableType(_ name: String) -> String {
        if name.starts(with: "["), name.hasSuffix("]"), name.contains(";") {
            let typeName = name.split(separator: ";")[0].dropFirst()
            let verbose = "Vec<\(typeName)>"
            return fixVariableType(verbose)
        }
        
        let genericType = TypeParser.genericType(for: name)
        return fix(genericType: genericType).description
    }
    
    private func fix(genericType: TypeParser.GenericType) -> TypeParser.GenericType {
        if genericType.typeName == "Option" && genericType.parameters.count == 1 {
            let typeName = typeName(for: nativeType(for: genericType.parameters[0].typeName))
            return TypeParser.GenericType(typeName: "\(typeName)?", parameters: [])
        }
        
        if Rules.ignoredWrappingTypes.contains(genericType.typeName) && genericType.parameters.count == 1 {
            let genericType = TypeParser.GenericType(typeName: genericType.parameters[0].typeName, parameters: genericType.parameters[0].parameters)
            return fix(genericType: genericType)
        }
        
        var genericType = genericType
        for rule in Rules.ignoredNamespaces {
            if genericType.typeName.starts(with: rule) {
                genericType.typeName = genericType.typeName.replacingOccurrences(of: rule, with: "")
                break
            }
        }
        
        genericType.typeName = typeName(for: nativeType(for: genericType.typeName))
        genericType.parameters = genericType.parameters.map { fix(genericType: $0) }
        
        return genericType
    }
}

private struct TypeParser {
    struct GenericType: CustomStringConvertible {
        var typeName: String
        var parameters: [GenericType]
        
        var description: String {
            if parameters.count == 0 {
                return typeName
            }
            
            if let shorteningParametersCount = Rules.shorteningTypes[typeName], shorteningParametersCount == parameters.count {
                return "\(Rules.shorteningBrackets[0])\(parameters.map { $0.description }.joined(separator: ": "))\(Rules.shorteningBrackets[1])"
            }
            
            return "\(typeName)<\(parameters.map { $0.description }.joined(separator: ", "))>"
        }
    }
    
    static func splitByComma(_ typeName: String) -> [String] {
        var strings: [String] = []
        var string = ""
        var level = 0
        
        var skip = false
        for char in typeName {
            if skip {
                skip = false
                continue
            }
            
            if char == "," && level == 0 {
                strings.append(string)
                string = ""
                skip = true
            } else {
                string.append(char)
            }
            
            if char == "<" {
                level += 1
            } else if char == ">" {
                level -= 1
            }
        }
        
        strings.append(string)
        
        return strings
    }
    
    static func genericType(for typeName: String) -> GenericType {
        if !typeName.contains("<") {
            return GenericType(typeName: typeName, parameters: [])
        }
        
        guard let start = typeName.firstIndex(of: "<") else {
            return GenericType(typeName: typeName, parameters: [])
        }
        
        let parametersList = String(typeName.suffix(from: typeName.index(after: start)).dropLast())
        let name = String(typeName.prefix(upTo: start))
        let parameters = splitByComma(parametersList).map { genericType(for: $0) }
        
        return GenericType(typeName: name, parameters: parameters)
    }
}

// MARK: - Writing

extension SchemaConverter {
    
    private var stubFilename: String { "NamespacesStub.\(Rules.fileExtension)" }
    
    mutating private func write(typeMetadata: TypeMetadata, namespacePath: [String], isNamespace: Bool = false) -> LocalizedError? {
        guard let typeName = namespacePath.last else {
            return Error.invalidSchema
        }
        
        var filename = namespacePath.joined().appending(".\(Rules.fileExtension)")
        filename = (namespacePath.dropLast() + [filename]).joined(separator: "/")
        if isNamespace {
            filename = stubFilename
        }
        
        let hashable = namespacePath.count == 2 && Rules.hashable.contains(where: {
            $0.0 == namespacePath[0] && $0.1 == namespacePath[1]
        })
        
        guard let writer = Rules.typeWriter(for: typeMetadata, name: typeName, resolver: self, hashable: hashable, codable: !isNamespace) else {
            return Error.invalidSchema
        }
        
        var header = Rules.fileHeader + "\n"
        
        let importFrameworks = Rules.importFrameworks(from: importFrameworks)
        if importFrameworks.count > 0 {
            header += importFrameworks.sorted().map { "import \($0)" }.joined(separator: "\n")
            header += "\n\n"
        }
        
        var tabs = 0
        if isNamespace && namespacesWritten.count > 0 {
            header = ""
        }
        
        var footer = ""
        
        if namespacePath.count > 1, let namespace = namespacePath.first {
            footer = "\n}"
            header += "extension \(namespace) {\n"
            tabs = 1
            
            if !namespacesWritten.contains(namespace) {
                let metadata = TypeMetadata(name: namespace, kind: .struct([]))
                if let error = write(typeMetadata: metadata, namespacePath: [namespace], isNamespace: true) {
                    return error
                }
                namespacesWritten.insert(namespace)
            }
        }
        
        do {
            var body = try writer.write()
            if header.count > 0 || footer.count > 0 {
                let tab = tabs > 0 ? "" : Rules.tab(tabs)
                body = body.split(separator: "\n").map { tab + $0 }.joined(separator: "\n")
                body = header.appending(body).appending(footer)
            }
            
            if let error = fileManager.writeFile(at: filename, contents: body, append: isNamespace) {
                return error
            }
        } catch let error {
            return error as? LocalizedError
        }
        
        return nil
    }
}

// MARK: - Rules

private struct Rules {
    
    private static let defaultImportFrameworks: [String] = ["Foundation"]
    static func importFrameworks(from provided: [String]) -> [String] {
        provided + defaultImportFrameworks
    }
    
    static let fileHeader = """
    //
    // Copyright 2021 Soramitsu Co., Ltd.
    //
    // Licensed under the Apache License, Version 2.0 (the "License");
    // you may not use this file except in compliance with the License.
    // You may obtain a copy of the License at
    //
    //     http://www.apache.org/licenses/LICENSE-2.0
    //
    // Unless required by applicable law or agreed to in writing, software
    // distributed under the License is distributed on an "AS IS" BASIS,
    // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    // See the License for the specific language governing permissions and
    // limitations under the License.
    //
    
    """
    static let fileExtension = "swift"
    static let keywords = ["if", "where"]
    static let indirectKeyword: String? = "indirect"
    private static let tab = "    "
    static func tab(_ count: Int = 1) -> String { [String](repeating: tab, count: count).joined(separator: "") }
    static let ignoredWrappingTypes = [
        "iroha_data_model::expression::EvaluatesTo",
    ]
    static let ignoredNamespaces = [
        "alloc::string::",
        "alloc::vec::",
        "iroha_schema::",
    ]
    static let shorteningBrackets = ["[", "]"]
    static let shorteningTypes = [
        "Array": 1,
        "Dictionary": 2,
    ]
    static let hashable = [
        ("IrohaDataModelAsset", "Id"),
        ("IrohaDataModelAsset", "DefinitionId"),
        ("IrohaDataModelAccount", "Id"),
    ]
    
    private static var tupleStructFactory = TupleStructFactory()
    
    static func typeWriter(
        for typeMetadata: TypeMetadata,
        name: String,
        resolver: NamespaceResolver & NameFixer,
        hashable: Bool,
        codable: Bool = true
    ) -> TypeWriter? {
        
        switch typeMetadata.kind {
        case let .struct(fields):
            return StructWriter(name: name, fields: fields, resolver: resolver, hashable: hashable, codable: codable)
        case let .tupleStruct(types):
            return TupleStructWriter(name: name, types: types, resolver: resolver, factory: tupleStructFactory)
        case let .enum(cases):
            return EnumWriter(name: name, cases: cases, resolver: resolver)
        default: return nil
        }
    }
    
    static func finalize() -> [String] {
        tupleStructFactory.files
    }
}

// MARK: - Writers

private protocol TypeWriter {
    func write() throws -> String
}

private func writeInterfaces(_ interfaces: [String]) -> String {
    if interfaces.isEmpty {
        return ""
    }
    
    return ": " + interfaces.joined(separator: ", ")
}

private struct StructWriter: TypeWriter {
    
    let name: String
    let fields: [(String, String)]
    let resolver: NamespaceResolver & NameFixer
    let hashable: Bool
    let codable: Bool
    
    private func writeField(_ variable: (String, String)) -> String {
        "\(Rules.tab())public var \(variable.0): \(variable.1)"
    }
    
    private func writeConstructor(variables: [(String, String)]) -> String {
        """
        \(Rules.tab())public init(\(variables.map { "\($0): \($1)" }.joined(separator: ", "))) {
        \(variables.map { "\(Rules.tab())self.\($0.0) = \($0.0)" }.joined(separator: "\n\(Rules.tab())"))
        \(Rules.tab())}
        """
    }
    
    private func hashableBody(variables: [(String, String)]) -> String {
        if !hashable {
            return ""
        }
        
        return """
        \(Rules.tab())
        // MARK: - Hashable
        \(Rules.tab())
        public func hash(into hasher: inout Hasher) {
        \(Rules.tab())\(variables.map { "hasher.combine(\($0.0))" }.joined(separator: "\n\(Rules.tab())"))
        }
        """.split(separator: "\n").map { "\(Rules.tab())\($0)" }.joined(separator: "\n")
    }
    
    func write() -> String {
        var interfaces = ["Codable"]
        if fields.count == 0 {
            return "public struct \(name)\(writeInterfaces(interfaces)) {}"
        }
        
        let variables = fields.map {
            (resolver.fixVariableName($0.0), resolver.fixVariableType($0.1))
        }
        
        if hashable {
            interfaces.append("Hashable")
        }
        
        return """
        public struct \(name)\(writeInterfaces(interfaces)) {
        \(Rules.tab())
        \(variables.map { writeField($0) }.joined(separator: "\n"))
        \(Rules.tab())
        \(writeConstructor(variables: variables))
        \(hashableBody(variables: variables))
        }
        """
    }
}

private struct TupleStructWriter: TypeWriter {
    
    let name: String
    let types: [String]
    let resolver: NamespaceResolver & NameFixer
    let factory: TupleStructFactory
    
    func write() throws -> String {
        if types.isEmpty {
            // Empty tuples doesn't work with Codable, so let's use empty struct
            return StructWriter(name: name, fields: [], resolver: resolver, hashable: false, codable: true).write()
        }
        
        if types.count == 1 {
            return "public typealias \(name) = (\(types.map { resolver.fixVariableType($0) }.joined(separator: ", ")))"
        }
        
        let typeName = try factory.make(varsCount: types.count)
        return "public typealias \(name) = \(typeName)<\(types.map { resolver.fixVariableType($0) }.joined(separator: ", "))>"
    }
}

private struct EnumWriter: TypeWriter {
    
    let name: String
    let cases: [(String, [String]?)]
    let resolver: NamespaceResolver & NameFixer
    
    private func writeCase(_ case: (String, [String]?)) -> String {
        var string = "\(Rules.tab())case \(resolver.fixVariableName(`case`.0))"
        if let values = `case`.1 {
            string += "(\(values.map { resolver.fixVariableType($0) }.joined(separator: ", ")))"
        }
        
        return string
    }
    
    private func writeCaseIndexGetter(_ case: (String, [String]?), index: Int) -> String {
        """
        \(Rules.tab(3))case .\(resolver.fixVariableName(`case`.0)):
        \(Rules.tab(4))return \(index)
        """
    }
    
    private func writeScaleEnumIterableConformance() -> String {
        """
        \(Rules.tab())// MARK: - For Codable purpose
        \(Rules.tab())
        \(Rules.tab())static func index(of case: Self) -> Int {
        \(Rules.tab(2))switch `case` {
        \(cases.enumerated().map { writeCaseIndexGetter($0.element, index: $0.offset) }.joined(separator: "\n"))
        \(Rules.tab(2))}
        \(Rules.tab())}
        """
    }
    
    private func writeCaseInit(_ case: (String, [String]?), index: Int) -> String {
        """
        \(Rules.tab(2))case \(index):
        \(Rules.tab(3))\(`case`.1.map { "\($0.enumerated().map { "let val\($0.offset) = try container.decode(\(resolver.fixVariableType($0.element)).self)" }.joined(separator: "\n"))" } ?? "")
        \(Rules.tab(3))self = .\(resolver.fixVariableName(`case`.0))\(`case`.1.map { "(\($0.enumerated().map { "val\($0.offset)" }.joined(separator: ", ")))" } ?? "")
        \(Rules.tab(3))break
        """
    }
    
    private func writeInitWithDecoder() -> String {
        """
        \(Rules.tab())// MARK: - Decodable
        \(Rules.tab())
        \(Rules.tab())public init(from decoder: Decoder) throws {
        \(Rules.tab(2))var container = try decoder.unkeyedContainer()
        \(Rules.tab(2))let index = try container.decode(Int.self)
        \(Rules.tab(2))switch index {
        \(cases.enumerated().map { writeCaseInit($0.element, index: $0.offset) }.joined(separator: "\n"))
        \(Rules.tab(2))default:
        \(Rules.tab(3))throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unknown index \\(index)")
        \(Rules.tab(2))}
        \(Rules.tab())}
        """
    }
    
    private func writeCaseEncode(_ case: (String, [String]?)) -> String {
        """
        \(Rules.tab(2))case \(`case`.1 != nil ? "let " : "").\(resolver.fixVariableName(`case`.0))\(`case`.1.map { "(\($0.enumerated().map { "val\($0.offset)" }.joined(separator: ", ")))" } ?? ""):
        \(Rules.tab(3))\(`case`.1.map { $0.enumerated().map { "try container.encode(val\($0.offset))" }.joined(separator: "\n") } ?? "")
        \(Rules.tab(3))break
        """
    }
    
    private func writeEncode() -> String {
        """
        \(Rules.tab())// MARK: - Encodable
        \(Rules.tab())
        \(Rules.tab())public func encode(to encoder: Encoder) throws {
        \(Rules.tab(2))var container = encoder.unkeyedContainer()
        \(Rules.tab(2))try container.encode(\(name).index(of: self))
        \(Rules.tab(2))switch self {
        \(cases.map { writeCaseEncode($0) }.joined(separator: "\n"))
        \(Rules.tab(2))}
        \(Rules.tab())}
        """
    }
    
    func write() -> String {
        // It's too complicated to calculate if enum can chainly call itself, so let's declare all enums indirect by default
        """
        public \(Rules.indirectKeyword.map { $0.appending(" ") } ?? "")enum \(name)\(writeInterfaces(["Codable"])) {
        \(Rules.tab())
        \(cases.map { writeCase($0) }.joined(separator: "\n"))
        \(Rules.tab())
        \(writeScaleEnumIterableConformance())
        \(Rules.tab())
        \(writeInitWithDecoder())
        \(Rules.tab())
        \(writeEncode())
        }
        """
    }
}

private final class TupleStructFactory {
    
    enum Error: LocalizedError {
        case invalidVarsCount
        var errorDescription: String? { "Variables count should be > 1" }
    }
    
    private var filesByCount: [Int: String] = [:]
    var files: [String] { filesByCount.values.map { $0 } }
    
    private func writeGenerics(varsCount: Int) -> String {
        (1...varsCount).map { "T\($0): Codable" }.joined(separator: ", ")
    }
    
    private func writeTupleVar(count: Int) -> String {
        """
        \(Rules.tab())public var tuple: (\((1...count).map { "T\($0)" }.joined(separator: ", "))) {
        \(Rules.tab(2))get { (\((0..<count).map { "_\($0)" }.joined(separator: ", "))) }
        \(Rules.tab(2))set {
        \((0..<count).map { Rules.tab(3) + "_\($0) = newValue.\($0)" }.joined(separator: "\n"))
        \(Rules.tab(2))}
        \(Rules.tab())}
        """
    }
    
    /// Required to ignore tuple var
    private func writeCodingKeys(varsCount: Int) -> String {
        """
        \(Rules.tab())/// Ignore tuple var
        \(Rules.tab())private enum CodingKeys: String, CodingKey {
        \(Rules.tab(2))case \((0..<varsCount).map { "_\($0)" }.joined(separator: ", "))
        \(Rules.tab())}
        """
    }
    
    private func writeVariables(count: Int) -> String {
        (1...count).map { Rules.tab() + "public var _\($0-1): T\($0)" }.joined(separator: "\n")
    }
    
    private func writeInit(varsCount: Int) -> String {
        """
        \(Rules.tab())public init(\((1...varsCount).map { "_ _\($0-1): T\($0)" }.joined(separator: ", "))) {
        \((0..<varsCount).map { Rules.tab(2) + "self._\($0) = _\($0)" }.joined(separator: "\n"))
        \(Rules.tab())}
        """
    }
    
    func make(varsCount: Int) throws -> String {
        guard varsCount > 1 else {
            throw Error.invalidVarsCount
        }
        
        let structName = "Tuple\(varsCount)"
        guard filesByCount[varsCount] == nil else {
            return structName
        }
        
        let file = """
        \(Rules.tab())
        public struct \(structName)<\(writeGenerics(varsCount: varsCount))>: Codable {
        \(Rules.tab())
        \(writeCodingKeys(varsCount: varsCount))
        \(Rules.tab())
        \(writeTupleVar(count: varsCount))
        \(Rules.tab())
        \(writeVariables(count: varsCount))
        \(Rules.tab())
        \(writeInit(varsCount: varsCount))
        }
        """
        
        filesByCount[varsCount] = file
        
        return structName
    }
}

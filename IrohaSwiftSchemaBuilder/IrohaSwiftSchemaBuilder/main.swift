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

// MARK: - Exit codes

enum ExitCode: String, CaseIterable {
    case noSchemaPath = "No schema path provided"
    case invalidSchemaPath = "Invalid schema path provided"
    case noDestinationPath = "No destination path provided for --dev mode"
    case noXcodeprojPath = "No path for target .xcodeproj provided"
    case noXcodeprojGroup = "No group path for target .xcodeproj provided"
    case noImportFrameworks = "No import frameworks provided"
    case other = "Internal error occured:"
}

extension ExitCode {
    func failed(description: String? = nil) -> Int32 {
        let code = ExitCode.allCases.firstIndex(of: self).map { $0 + 1 } ?? 5
        print("Failed with exit code: \(code)")
        print("\tError: \(rawValue)")
        if let description = description {
            print("\tError description: \(description)")
        }
        return Int32(code)
    }
}

// MARK: - Builder

func main() -> Int32 {
    let argv = CommandLine.arguments
    if argv.count < 2 { return ExitCode.noSchemaPath.failed() }

    var schemaPath = ""
    var destinationPath = ""
    var importFrameworks: [String] = []
    if argv[1] == "--dev" {
        // --dev mode
        if argv.count < 3 { return ExitCode.noSchemaPath.failed() }
        schemaPath = argv[2]
        if argv.count < 4 { return ExitCode.noDestinationPath.failed() }
        destinationPath = argv[3]
        importFrameworks = argv[4].split(separator: ",").map { String($0) }
    } else {
        // Normal mode
        schemaPath = argv[1]
        if argv.count < 3 { return ExitCode.noXcodeprojPath.failed() }
        if argv.count < 4 { return ExitCode.noXcodeprojGroup.failed() }
        if argv.count < 5 { return ExitCode.noImportFrameworks.failed() }
        
        let xcodeprojPath = argv[2]
        let xcodeprojGroupPath = argv[3]
        importFrameworks = argv[4].split(separator: ",").map { String($0) }
        
        destinationPath = "/" + xcodeprojPath.split(separator: "/").dropLast().joined(separator: "/") + "/" + xcodeprojGroupPath
    }

    let fileManager = FileManager(destinationPath: destinationPath)

    guard let rawSchema = fileManager.readFile(path: schemaPath) else {
        return ExitCode.invalidSchemaPath.failed()
    }

    if let error = fileManager.makeDestinationPathIfNeeded() {
        return ExitCode.other.failed(description: error.localizedDescription)
    }
    
    var schemaReader = SchemaReader(rawSchema: rawSchema)
    switch schemaReader.parse() {
    case let .success(schema):
        var schemaConverter = SchemaConverter(schema: schema, fileManager: fileManager, importFrameworks: importFrameworks)
        if let error = schemaConverter.convert() {
            return ExitCode.other.failed(description: error.localizedDescription)
        }
        
        break
    case let .failure(error):
        return ExitCode.other.failed(description: error.localizedDescription)
    }
    
    fileManager.finalize()
    
    return 0
}

exit(main())

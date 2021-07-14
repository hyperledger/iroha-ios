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

struct FileManager {
    
    enum Error: LocalizedError {
        case pathExistsAndIsFile
        case coulndCreateDirectoryAtPath(Swift.Error)
        case fileNotWritable
        case noData
        
        var errorDescription: String? {
            switch self {
            case .pathExistsAndIsFile: return "Provided destination path already exists, and cannot be used since it's a file"
            case let .coulndCreateDirectoryAtPath(error): return "Couldn't make directory at provided path\n\t\(error)"
            case .fileNotWritable: return "Couldn't write file"
            case .noData: return "No data to write (IMPOSSIBLE BY DESIGN)"
            }
        }
    }
    
    private let fileManager = Foundation.FileManager.default
    let destinationPath: String
    var tempPath: String { destinationPath.appending("/.tmp") }
}

// MARK: - Reading

extension FileManager {
    
    func readFile(path: String) -> [String: Any]? {
        guard fileManager.fileExists(atPath: path) else {
            return nil
        }
        
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            return nil
        }
        
        return try? JSONSerialization.jsonObject(with: data, options: .init()) as? [String: Any]
    }
}

// MARK: - Writing

extension FileManager {
    
    func makeDestinationPathIfNeeded() -> LocalizedError? {
        var isDirectory: ObjCBool = false
        if !fileManager.fileExists(atPath: tempPath, isDirectory: &isDirectory) {
            do {
                try fileManager.createDirectory(atPath: tempPath, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                return Error.coulndCreateDirectoryAtPath(error)
            }
        } else if !isDirectory.boolValue {
            return Error.pathExistsAndIsFile
        }
        
        return nil
    }
    
    func writeFile(at relativePath: String, contents: String, append: Bool = false) -> LocalizedError? {
        let path = tempPath.appending("/\(relativePath)")
        let directory = "/" + path.split(separator: "/").dropLast().joined(separator: "/")
        if !fileManager.fileExists(atPath: directory) {
            do {
                try fileManager.createDirectory(atPath: directory, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                return (error as? LocalizedError) ?? Error.fileNotWritable
            }
        }
        
        var fileExists = fileManager.fileExists(atPath: path)
        if !append, fileExists {
            do {
                try fileManager.removeItem(atPath: path)
                fileExists = false
            } catch let error {
                return (error as? LocalizedError) ?? Error.fileNotWritable
            }
        }
        
        guard let data = contents.data(using: .utf8) else {
            return Error.noData
        }
        
        if !fileExists {
            if !fileManager.createFile(atPath: path, contents: data, attributes: nil) {
                return Error.fileNotWritable
            }
            return nil
        }
        
        if !append {
            abort()
        }
        
        // Appending
        guard let fileHandle = FileHandle(forWritingAtPath: path) else {
            return Error.fileNotWritable
        }
        
        guard let newline = "\n".data(using: .utf8) else {
            return Error.noData
        }
        
        do {
            if #available(macOS 10.15.4, *) {
                try fileHandle.seekToEnd()
                try fileHandle.write(contentsOf: newline + data)
                try fileHandle.close()
            } else {
                try catchObjCException {
                    fileHandle.seekToEndOfFile()
                    fileHandle.write(newline + data)
                    fileHandle.closeFile()
                }
            }
        } catch let error {
            return (error as? LocalizedError) ?? Error.fileNotWritable
        }
        
        return nil
    }
    
    func finalize() {
        guard let filenames = try? fileManager.contentsOfDirectory(atPath: tempPath) else {
            abort()
        }
        
        for filename in filenames {
            let oldPath = tempPath.appending("/\(filename)")
            let newPath = destinationPath.appending("/\(filename)")
            if fileManager.fileExists(atPath: newPath) {
                try? fileManager.removeItem(atPath: newPath)
            }
            try? fileManager.moveItem(atPath: oldPath, toPath: newPath)
        }
        
        try? fileManager.removeItem(atPath: tempPath)
    }
}

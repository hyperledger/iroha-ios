//
//  DefinitionId+Constructor.swift
//  IrohaSwiftSDK
//
//  Created by Nikolai Zhukov on 9/6/23.
//

import Foundation

extension IrohaDataModelAsset.DefinitionId {
    public enum DefinitionIdError: Error {
        case invalidFormat
    }

    public init(assetId: String) throws {
        let components = assetId.components(separatedBy: "#")
        guard
            components.count == 2,
            let name = components.first,
            let domainName = components.last
        else {
            throw DefinitionIdError.invalidFormat
        }

        self.init(name: name, domainName: domainName)
    }
}

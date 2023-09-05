//
//  IrohaAccountId+Constructor.swift
//  IrohaSwiftSDK
//
//  Created by Nikolai Zhukov on 8/24/23.
//

import Foundation

extension IrohaDataModelAccount.Id {
    public enum IrohaDataModelAccountIdError: Error {
        case invalidFormat
    }

    public init(accountId: String) throws {
        let components = accountId.components(separatedBy: "@")
        guard
            components.count == 2,
            let name = components.first,
            let domainName = components.last
        else {
            throw IrohaDataModelAccountIdError.invalidFormat
        }

        self.init(name: name, domainName: domainName)
    }
}

//
//  IrohaAccountId+Extensions.swift
//  IrohaSwiftSDK
//
//  Created by Nikolai Zhukov on 8/24/23.
//

import Foundation

private struct Wrapper: Encodable {
    let accountId: String
}

private enum Constants {
    static let accountSeparator = "@"
}

extension IrohaDataModelAccount.Id {
    public enum IrohaDataModelAccountIdError: Error {
        case invalidFormat
    }

    public init(accountId: String) throws {
        let components = accountId.components(separatedBy: Constants.accountSeparator)
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

public extension IrohaDataModelAccount.Id {
    func payload() throws -> String {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        let wrapper = Wrapper(accountId: "\(name)\(Constants.accountSeparator)\(domainName)")
        let data = try jsonEncoder.encode(wrapper)
        let payload = String(decoding: data, as: UTF8.self)

        return payload
    }
}

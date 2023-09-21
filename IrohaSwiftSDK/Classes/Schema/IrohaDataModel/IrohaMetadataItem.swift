//
//  IrohaDataModelName.swift
//  IrohaSwiftSDK
//
//  Created by Nikolai Zhukov on 9/21/23.
//

import Foundation

public struct IrohaMetadataItem: Codable {
    private let name: String
    private let value: IrohaDataModel.Value

    public init(name: String, value: IrohaDataModel.Value) {
        self.name = name
        self.value = value
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(value, forKey: .value)
    }
}

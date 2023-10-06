//
//  IrohaDataModelName.swift
//  IrohaSwiftSDK
//
//  Created by Nikolai Zhukov on 9/21/23.
//

import Foundation

public struct IrohaMetadataItem: Codable, Comparable {
    private let name: String
    private let value: IrohaDataModel.Value

    public init(name: IdKey, value: IrohaDataModel.Value) {
        self.name = name.rawValue
        self.value = value
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(value, forKey: .value)
    }

    public static func < (lhs: IrohaMetadataItem, rhs: IrohaMetadataItem) -> Bool {
        lhs.name < rhs.name
    }

    public static func == (lhs: IrohaMetadataItem, rhs: IrohaMetadataItem) -> Bool {
        lhs.name == rhs.name
    }
}

//
//  CrosschainAddress.swift
//  IrohaSwiftSDK
//
//  Created by Nikolai Zhukov on 10/4/23.
//

import Foundation

public struct CrosschainAddress {
    let network: String
    let address: String

    public init(network: String, address: String) {
        self.network = network
        self.address = address
    }
}

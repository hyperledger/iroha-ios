//
//  Permission.swift
//  IrohaSwiftSDK
//
//  Created by Nikolai Zhukov on 9/28/23.
//

import Foundation

public enum Permission: String {
    case canUnregisterAccount = "can_unregister_account"
    case canMintUserPublicKeys = "can_mint_user_public_keys"
    case canBurnUserPublicKeys = "can_burn_user_public_keys"
}

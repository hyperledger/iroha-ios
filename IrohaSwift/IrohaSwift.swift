//
//  IrohaSwift.swift
//  IrohaSwift
//
//  Created by Kaji Satoshi on 2016/09/18.
//  Copyright © 2016年 Kaji Satoshi. All rights reserved.
//

import Foundation

public func createSeed() -> Array<UInt8> {
    var seed: Array<UInt8> = Array(count: 32, repeatedValue: 0)
    ed25519_create_seed(&seed)
    return seed
}

public func createKeyPair() -> (publicKey:Array<UInt8>, privateKey:Array<UInt8>){
    var pub: Array<UInt8> = Array(count: 32, repeatedValue: 0)
    var pri: Array<UInt8> = Array(count: 64, repeatedValue: 0)
    var seed: Array<UInt8> = createSeed()
    ed25519_create_keypair(&pub, &pri, &seed)
    return (pub, pri)
}

public func sign(publicKey:Array<UInt8>,privateKey:Array<UInt8>, message:String) -> Array<UInt8>{
    var sig: Array<UInt8> = Array(count: 64, repeatedValue: 0)
    var sigMsg: Array<UInt8> = Array(count: 32, repeatedValue: 0)
    sha3_256(Array<UInt8>(message.utf8), Array<UInt8>(message.utf8).count, &sigMsg)
    ed25519_sign(&sig, &sigMsg, sigMsg.count, publicKey, privateKey)
    return sig
}

public func verify(publicKey:Array<UInt8>, signature:Array<UInt8>, message:String) -> Int{
    var sigMsg: Array<UInt8> = Array(count: 32, repeatedValue: 0)
    sha3_256(Array<UInt8>(message.utf8), Array<UInt8>(message.utf8).count, &sigMsg)
    return Int(ed25519_verify(signature, sigMsg, sigMsg.count, publicKey))
}
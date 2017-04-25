/*
Copyright Soramitsu Co., Ltd. 2016 All Rights Reserved.
http://soramitsu.co.jp

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

         http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/


import Foundation
import libs

func createSeed() -> Array<UInt8> {
    var seed: Array<UInt8> = Array(repeating: 0, count: 32)
    ed25519_create_seed(&seed)

    return seed
}

public func createKeyPair() -> (publicKey:String, privateKey:String){
    var pub: Array<UInt8> = Array(repeating: 0, count: 32)
    var pri: Array<UInt8> = Array(repeating: 0, count: 64)
    var seed: Array<UInt8> = createSeed()
    ed25519_create_keypair(&pub, &pri, &seed)
    let encPub = base64_encode(pub, UInt32(pub.count))
    let base64Pub = String(validatingUTF8:UnsafePointer<CChar>(encPub!))!
    let encPri = base64_encode(pri, UInt32(pri.count))
    let base64Pri = String(validatingUTF8:UnsafePointer<CChar>(encPri!))!

    return (base64Pub, base64Pri)
}
public func sign(publicKey:String,privateKey:String, message:String) -> String{
    var sig: Array<UInt8> = Array(repeating: 0, count: 64)
    var decPubArr = base64toArr(base64str: publicKey, count: 32)
    var decPriArr = base64toArr(base64str: privateKey, count: 64)
    ed25519_sign(&sig, message, message.characters.count, &decPubArr, &decPriArr)
    let encSig = base64_encode(sig, UInt32(sig.count))
    let base64Sig = String(validatingUTF8:UnsafePointer<CChar>(encSig!))!

    return base64Sig
}

public func verify(publicKey:String, signature:String, message:String) -> Bool{
    let decPubArr = base64toArr(base64str: publicKey, count: 32)
    let decSigArr = base64toArr(base64str: signature, count: 64)
    let valid = Int(ed25519_verify(decSigArr, message, message.characters.count, decPubArr))
    if valid == 1 {
        return true
    }else{
        return false
    }
}

func base64toArr(base64str:String, count:Int) -> Array<UInt8>{
    let base64Ptr = UnsafeMutablePointer<Int8>(mutating: base64str)
    let decBase64 = base64_decode(base64Ptr)
    let decArr = Array<UInt8>(UnsafeBufferPointer(start: decBase64, count: count))
    base64Ptr.deinitialize()

    return decArr
}

# いろはSwift(IrohaSwift)

## What's is いろは(iroha)?  
いろは(iroha) is [this](https://github.com/soramitsu/iroha).

## Description  
いろはSwift(IrohaSwift) is client swift library for using いろは(iroha).

## Requirement  
iOS 8.0+  
Xcode 8.0+  
Swift 3.0+  

## Installation  
*  Clone this repository.
*  [Download 1.0.0 α version release](https://github.com/soramitsu/IrohaSwift/releases/tag/1.0.0%CE%B1).
*  [Feature]Install with pod.

## Usage
### API
#### IrohaSwift.createKeyPair
```swift
import IrohaSwift

let keypair = IrohaSwift.createKeyPair()
//===> keypair : (publicKey:String, privateKey:String)
```
#### IrohaSwift.register

```swift
let res = IrohaSwift.register(
            keyPair: (publicKey:String, privateKey:String),
            accessPoint: String, //ex)http://hoge.com
            name: String
          )
//if connection successful
//===> res : [
//            "message": "successful",
//            "status": 200,
//            "uuid": String
//          ]
```

#### iroha.getAccountInfo

```swift
let res = IrohaSwift.getAccountInfo(
              accessPoint: String,
              uuid: String //IrohaSwift.register() returned uuid
          )
//if get successful
//===> res : [
//            "status": 200,
//            "alias": String
//          ]
```
#### IrohaSwift.domainRegister

```swift
let res = IrohaSwift.domainRegister(
            accessPoint: String,
     				domain: String, //ex)ソラミツ株式会社
     				keyPair: (publicKey:String, privateKey:String)
          )
//if domain regist successful
//===> res : [
//            "status": 200,
//            "message": "Domain registered successfully."
//          ]
```

#### IrohaSwift.createAsset

```swift
let res = IrohaSwift.createAsset({
            accessPoint: String,
            domain: String,
            keyPair: (publicKey:String, privateKey:String),
            name: String //ex)ソラミツコイン
          )
//if asset create successful
//===> res : [
//            "status": 200,
//            "message": "Asset created successfully."
//          ]  
```

#### IrohaSwift.assetOperation

```swift
let res = IrohaSwift.assetOperation(
            accessPoint: String,
            command: String, //ex)Transfer
            assetUuid: String,
            amount: String,
            keyPair: (publicKey:String, privateKey:String),
            receiver: String //receiver public key
)
//if asset transfer successful
//===> res : [
//            "status": 200,
//            "message": "Asset transfer successfully."
//          ]
```

#### IrohaSwift.getDomainList

```swift
let res = IrohaSwift.getAssetList(
				 accessPoint: ip address or url,
         )
//if get domain list successful
//===> Feature Works!
```

#### iroha.getAssetList
```swift
let res = iroha.getAssetList(
 				accessPoint: ip address or url,
 				domainName: domain name
        )
//if get asset list successful
//===> Feature Works!
```

#### IrohaSwift.getTransaction

```swift
let res = IrohaSwift.getTransaction({
            accessPoint: String,
            uuid: String
          )
//if get transaction successful
//===> Feature Works!
```

#### IrohaSwift.getTransactionWithAssetName

```swift
let res = IrohaSwift.getTransaction({
            accessPoint: String,
            asset:String,
            domain:String
          )
//if get transaction successful
//===> Feature Works!
```

## Author  
[luca3104](https://github.com/luca3104)

## License
Apatch 2.0 License

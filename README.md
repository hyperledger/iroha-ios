# いろはSwift(IrohaSwift)

![CocoaPods](https://img.shields.io/cocoapods/v/IrohaSwift.svg)
![Platform](https://img.shields.io/cocoapods/p/IrohaSwift.svg?style=flat)

## What's is いろは(iroha)?  
いろは(iroha) is [this](https://github.com/soramitsu/iroha).

## Description  
いろはSwift(IrohaSwift) is client swift library for using いろは(iroha).


- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [License](#license)

## Requirement  
iOS 8.0+  
Xcode 8.0+  
Swift 3.0+  

## Installation  
### CocoaPods(iOS 8+)

Podfile:
```ruby
platform :ios, '8.0'
use_frameworks!

target 'App Name' do
    pod 'IrohaSwift'
end
```

Then, run the following command:

```bash
$ pod install
```

### Carthage
Write in your Cartfile:
```
github "soramitsu/iroha-ios.git"
```
Run `carthage update`

### Manually
*  Clone this repository.
*  [Download 1.0.0 α2 version release](https://github.com/soramitsu/iroha-ios/releases/tag/1.0.0a2).

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

Copyright 2016 Soramitsu Co., Ltd.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

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
#### IrohaSwift.setData
This API is set variables on the singleton manager class.
You can use 3 pattern.
```swift
setDatas(uuid:String)
setDatas(accessPoint:String, publicKey:String)
setDatas(accessPoint:String, publicKey:String, uuid:String)
```

#### IrohaSwift.createKeyPair
```swift
import IrohaSwift

let keypair = IrohaSwift.createKeyPair()
//===> keypair : (publicKey:String, privateKey:String)
```
#### IrohaSwift.register

```swift
let res = IrohaSwift.register(
            privateKey:String,
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
let res = IrohaSwift.getAccountInfo()
//if get successful
//===> res : [
//            "status": 200,
//            "alias": String
//          ]
```
#### IrohaSwift.domainRegister

```swift
let res = IrohaSwift.domainRegister(
     				domain: String, //ex)ソラミツ株式会社
     				privateKey:String
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
            domain: String,
            privateKey:String,
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
            command: String, //ex)Transfer
            assetUuid: String,
            amount: String,
            privateKey:String,
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
let res = IrohaSwift.getAssetList()
//if get domain list successful
//===> Feature Works!
```

#### iroha.getAssetList
```swift
let res = iroha.getAssetList( domain: String )
//if get asset list successful
//===> Feature Works!
```

#### IrohaSwift.getTransaction

```swift
let res = IrohaSwift.getTransaction()
//if get transaction successful
//===> Feature Works!
```

#### IrohaSwift.getTransactionWithAssetName

```swift
let res = IrohaSwift.getTransactionWithAssetName( asset:String )
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

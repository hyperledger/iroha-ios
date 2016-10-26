# いろはSwift (IrohaSwift)

![CocoaPods](https://img.shields.io/cocoapods/v/IrohaSwift.svg)
![Platform](https://img.shields.io/cocoapods/p/IrohaSwift.svg?style=flat)

## What is いろは(iroha)?  
いろは(iroha) is [this](https://github.com/hyperledger/iroha).

## Description  
いろはSwift (IrohaSwift) is client swift library for using いろは(iroha).

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
github "hyperledger/iroha-ios.git"
```
Run `carthage update`

### Manually
*  Clone this repository.
*  [Download 1.0.0 α5 version release](https://github.com/hyperledger/iroha-ios/releases/tag/1.0.0a5).

## Usage
### APIs
#### IrohaSwift.createKeyPair
```swift
import IrohaSwift

let keypair = IrohaSwift.createKeyPair()
//===> keypair : (publicKey:String, privateKey:String)
```
#### IrohaSwift.sign
```swift
let signature = IrohaSwift.sign(publicKey: publicKey, privateKey: privateKey, message: "MESSAGE")
//===> signature : String
```
#### IrohaSwift.verify
```swift
let verify = IrohaSwift.verify(publicKey: keyPair.publicKey, signature: signature, message: "MESSAGE")
//===> verify : Bool
```
#### IrohaSwift.sha3_256
```swift
let hash = IrohaSwift.sha3_256(message: "")
//===> hash : "a7ffc6f8bf1ed76651c14756a061d662f580ff4de43b49fa82d80a4b80f8434a"
```
#### IrohaSwift.sha3_384
```swift
let hash = IrohaSwift.sha3_384(message: "")
//===> hash : "0c63a75b845e4f7d01107d852e4c2485c51a50aaaa94fc61995e71bbee983a2ac3713831264adb47fb6bd1e058d5f004"
```
#### IrohaSwift.sha3_512
```swift
let hash = IrohaSwift.sha3_512(message: "")
//===> hash : "a69f73cca23a9ac5c8b567dc185a756e97c982164fe25859e0d1dcc1475c80a615b2123af1f5f94c11e3e9402c3ac558f500199d95b6d3e301758586281dcd26"
```

## Author  
[luca3104](https://github.com/luca3104)
[http://soramitsu.co.jp](http://soramitsu.co.jp)

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

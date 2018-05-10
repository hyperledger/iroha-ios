# Hyperledger Iroha iOS library


This library was implemented in order to provide key generation and signing logic for queries and transactions passed to Hyperledger Iroha

For establishing connection with [Hyperledger Iroha](https://github.com/hyperledger/iroha) by this library you need to import the following modules into your swift project:

* [SwiftGRPC ](https://github.com/grpc/grpc-swift)
* [SwiftProtobuf](https://github.com/apple/swift-protobuf)
* [SwiftyIroha](https://github.com/soramitsu/iroha-ios)


## How to start with example project

In this repository you can find an example project called `SwiftyIrohaExample.xcodeproj`. 
This project can help you to see how to establish connection with [Hyperledger Iroha](https://github.com/hyperledger/iroha)  by using this library 

### Preparing example project

Before starting you need to install the following software on you mac:
* [XCode](https://developer.apple.com/xcode/)
* [CocoaPods](https://cocoapods.org/)
* [Git](https://git-scm.com/)

#### Instruction:

0. Go into folder you want to download example project: 
```
    $cd path/to/your/folder/for/example/iroha-ios/project/
```
1. Clone iroha-ios repository: 
```
    $git clone https://github.com/hyperledger/iroha-ios.git
```
2. Go inside project folder:
```
    $cd iroha-ios
```
3. Install all dependencies:
```
    $pod install
```
4. Open project in Xcode:
```
    open SwiftyIroha.xcworkspace
```
5. Run target SwiftyIrohaExample

### Preparing Hyperledger Iroha instance launched in Docker

Before starting you need to install the following software on you mac:
* [Docker](https://www.docker.com)

#### Instruction:

0. Launch Hyperledger Iroha instance according to this instruction:
* [Launching Hyperledger Iroha](http://iroha.readthedocs.io/en/latest/getting_started/)

## How to import this library into your project

### Install manually
```
    Please import generated framework form this project (SwiftyIroha targer) into your project
    or start modyfying this project (SwiftyIrohaExample target) it is already working with library
```

### Install via Carthage
```
    Currently not available, please inport framework manually
```

### Install via CocoaPods
```
    Currently not available, please inport framework manually
```


## How to use this library

### Keypair

#### Generating new keypair

```swift
let modelCrypto = IrohaModelCrypto()

// Generating new keypair object
let newKeypair = modelCrypto.generateKeypair()
```

#### Generating new keypair from existing one

```swift
// Setting keypair
let publicKey = IrohaPublicKey(value: "407e57f50ca48969b08ba948171bb2435e035d82cec417e18e4a38f5fb113f83")
let privateKey = IrohaPrivateKey(value: "1d7e0a32ee0affeb4d22acd73c2c6fb6bd58e266c8c2ce4fa0ffe3dd6a253ffb")

// Initializing keypair object
let existingKeypair = IrohaKeypair(publicKey: publicKey,
                                   privateKey: privateKey)

let modelCrypto = IrohaModelCrypto()

// Generating keypair object from excisting keypair object
let newKeypair = modelCrypto.generateNewKeypair(from: existingKeypair)
```

### Transactions

#### Creating transaction object
```swift
let irohaTransactionBuilder = IrohaTransactionBuilder()

// Creating transaction object for Iroha
let unsignedTransaction = try irohaTransactionBuilder
                                    .creatorAccountId("admin@test")
                                    .createdTime(Date())
                                    .transactionCounter(1)
                                    .createDomain(withDomainId: "ru", withDefaultRole: "user")
                                    .createAssets(withAssetName: "dollar", domainId: "ru", percision: 0.1)
                                    .build()
```

#### Signing transaction object
```swift
// Creating helper class for signing unsigned transaction object
let irohaTransactionPreparation = IrohaTransactionPreparation()

// Signing transaction and getting object which is ready for converting to GRPC object
let irohaSignedTransactionReadyForConvertingToGRPC = 
        irohaTransactionPreparation.sign(unsignedTransaction, with: keypair)
```

#### Creating GRPC transaction object
```swift
// Creating GRPC transaction object from signed transaction
var irohaGRPCTransaction = Iroha_Protocol_Transaction()

do {
    try irohaGRPCTransaction.merge(serializedData: irohaSignedTransactionReadyForConvertingToGRPC)

    // Checking that transaction is excactly transaction that was created
    print("Transaction to Iroha: \n")
    print("\(try irohaGRPCTransaction.payload.jsonString()) \n")
} catch {
    let nsError = error as NSError
    print("\(nsError.localizedDescription) \n")
}
```

#### Sending transaction object to Hyperledger Iroha

```swift
let serviceForSendingTransaction = Iroha_Protocol_CommandServiceService(address: "127.0.0.1:50051")

do {
    try serviceForSendingTransaction.torii(irohaGRPCTransaction)
} catch {
    let nsError = error as NSError
    print("\(nsError.localizedDescription) \n")
}
```

### Queries

#### Creating query object
```swift
// Creating unsigned query object
let queryBuilder = IrohaQueryBuilder()

let unsignedQuery = try queryBuilder
                            .creatorAccountId("admin@test")
                            .createdTime(Date())
                            .queryCounter(1)
                            .getAssetInfo(byAssetsId: "dollar#ru")
                            .build()
```

#### Signing query object
```swift
// Creating helper class for signing unsigned query
let irohaQueryPreparation = IrohaQueryPreparation()
        
let irohaSignedQueryReadyForConvertingToGRPC = irohaQueryPreparation.sign(unsignedQuery, with: keypair)
```

#### Creating GRPC query object
```swift
var irohaGRPCQuery = Iroha_Protocol_Query()
        
do {
    try irohaGRPCQuery.merge(serializedData: irohaSignedQueryReadyForConvertingToGRPC)

    // Checking that query is excactly query that was created
    print("Query to Iroha: \n")
    print("\(try irohaGRPCQuery.payload.jsonString()) \n")
} catch {
    let nsError = error as NSError
    print("\(nsError.localizedDescription) \n")
}
```

#### Sending query object to Hyperledger Iroha

```swift
let serviceForSendingQuery = Iroha_Protocol_QueryServiceService(address: "127.0.0.1:50051")

do {
    let result = try serviceForSendingQuery.find(irohaGRPCQuery)
} catch {
    let nsError = error as NSError
    print("\(nsError.localizedDescription) \n")
}
```

## Author

AlexeyMukhin

* telegram: @AlexeyMukhin
* email: info@soramistu.co.jp

## License


Copyright 2018 Soramitsu Co., Ltd.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
```
    http://www.apache.org/licenses/LICENSE-2.0
```
Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.


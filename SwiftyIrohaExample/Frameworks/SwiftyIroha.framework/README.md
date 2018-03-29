## Hyperledger Iroha iOS library


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
* [Carthage](https://github.com/Carthage/Carthage)
* [Git](https://git-scm.com/)

#### Instruction:

0. Go into folder you want to download example project: 
```
    $cd path/to/your/folder/for/example/iroha-ios/project/
```
1. Clone iroha-ios repository: 
```
    $git clone https://github.com/soramitsu/iroha-ios.git
```
2. Go inside project folder:
```
    $cd SwiftyIroha
```
3. Install all usefull dependencies: `$carthage update --platform iOS`
```
    $cd SwiftyIroha
```
4. Go inside example project: 
```
    $cd SwiftyIrohaExample
```
5. Go inside `SwiftGRPC.xcodeproj` subproject folder: 
```
    $cd grpc-swift
```
6. Build GRPC framework for using it in you ios application:
```
    $make
```
7. Open `SwiftyIroha.xcodeproj` project in Xcode
8. Go to `SwiftyIrohaExample.xcodeproj` subproject
9. Go to `SwiftGRPC.xcodeproj` subproject
10. Go to targets and remove `czlib` targets from there

### Preparing Hyperledger Iroha instance

Before starting you need to install the following software on you mac:
* [Docker](https://www.docker.com)

#### Instruction:

0. Go to folder you want to download [Hyperledger Iroha](https://github.com/hyperledger/iroha)  to: 
```
    $cd path/to/your/folder/for/example/iroha/project/
```
1. Download [Hyperledger Iroha](https://github.com/hyperledger/iroha)  on you mac: 
```
    git clone -b develop --depth=1 https://github.com/hyperledger/iroha
```
2. Run script: 
```
    ./run-iroha-dev.sh
```

## How to import this library into your project

### Install via Carthage


### Install via CocoaPods


## How to use this library

### Transactions

#### Creating transaction object
```
// Creating unsigned transaction object
let unsignedTransaction =
    irohaTransactionBuilder
        .creatorAccountId(creatorAcountId)
        .createdTime(Date())
        .transactionCounter(1)
        .createDomain(withDomainId: "ru", withDefaultRole: "user")
        .createAssets(withAssetName: "dollar", domainId: "ru", percision: 0.1)
        .build()
```

#### Signing transaction object
```
// Creating helper class for signing unsigned transaction object
let irohaTransactionPreparation = IrohaTransactionPreparation()

// Signing transaction and getting object which is ready for converting to GRPC object
let irohaSignedTransactionReadyForConvertingToGRPC =
    irohaTransactionPreparation.sign(unsignedTransaction,
                                     with: keypair)
```

#### Creating GRPC transaction object
```
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

```
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
```
// Creating unsigned query object
let queryBuilder = IrohaQueryBuilder()

let unsignedQuery =
    queryBuilder
        .creatorAccountId(creatorAcountId)
        .createdTime(Date())
        .queryCounter(1)
        .getAssetInfo(byAssetsId: "dollar#ru")
        .build()
```

#### Signing query object
```
// Creating helper class for signing unsigned query
let irohaQueryPreparation = IrohaQueryPreparation()
        
let irohaSignedQueryReadyForConvertingToGRPC =
    irohaQueryPreparation.sign(unsignedQuery,
                               with: keypair)
```

#### Creating GRPC query object
```
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

```
let serviceForSendingQuery = Iroha_Protocol_QueryServiceService(address: "127.0.0.1:50051")

do {
    let result = try serviceForSendingQuery.find(irohaGRPCQuery)
    (result)
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


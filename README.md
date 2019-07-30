# Hyperledger Iroha iOS library

### Please pay attention! Current version of the library was tested and compatible with [![Iroha 1.0.0](https://img.shields.io/badge/Iroha-1.0.1-green.svg)](https://github.com/hyperledger/iroha/releases/tag/1.0.1).

The library was created to provide convienent interface for iOS applications to communicate with [Iroha](https://github.com/hyperledger/iroha) blockchain including sending transactions/query, streaming transaction statuses and block commits.

## Example

For new iroha users we recommend to checkout iOS example project. It tries to establish connection with Iroha peer which should be also run locally on your computer to create new account and send some asset quantity to it. To run the project, please, go through steps below:

1. Follow instructions from [Iroha documentation](https://iroha.readthedocs.io/en/latest/getting_started/) to setup and run iroha peer in [Docker](https://www.docker.com) container.

2. Clone current repository.

3. cd Example directory and run ```pod install```.

4. Open IrohaCommunication.xcworkspace in XCode

6. Build and Run IrohaExample target.

7. Consider logs to see if the scenario completed successfully.

Feel free to experiment with example project and don't hesistate to ask any questions.

## Integration Tests

Integration tests is a good place to check existing scenarious or to introduce new ones. To run integration tests, please, go through steps below:

1. Follow instructions from [Iroha documentation](https://iroha.readthedocs.io/en/latest/getting_started/) to setup and run iroha peer in [Docker](https://www.docker.com) container. However make sure you run iroha using following command (consider additional --overwrite_ledger flag):
```docker run --name iroha -d -p 50051:50051 -v $(pwd)/iroha/example:/opt/iroha_data -v blockstore:/tmp/block_store --network=iroha-network -e KEY='node0 --overwrite_ledger' hyperledger/iroha:latest```.

2. Launch proxy for docker daemon to make it available through http. For example, one can use socat utility:
```brew install socat```
 ```socat TCP-LISTEN:49721,fork UNIX-CONNECT:/var/run/docker.sock``` 

3. Clone current repository.

4. cd Example directory and run ```pod install```.

5. Open IrohaCommunication.xcworkspace in XCode

6. Run tests under IntegrationTests target.

## Need Help?

* Join [Hyperledger RocketChat](https://chat.hyperledger.org) #iroha channel 
* Use mailing list [hyperledger-iroha@lists.hyperledger.org](mailto:hyperledger-iroha@lists.hyperledger.org)

## Cocoapods Installation

Iroha iOS library is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'IrohaCommunication'
```

## Author

Ruslan Rezin, rezin@soramitsu.co.jp  
Andrei Marin, marin@soramitsu.co.jp

## License

Copyright 2018 Soramitsu Co., Ltd.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
```
http://www.apache.org/licenses/LICENSE-2.0
```
Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

# Hyperledger Iroha iOS library

### Please pay attention! Current version of the library was tested and compatible with [`iroha-v1.0.0_rc2`](https://github.com/hyperledger/iroha/releases/tag/1.0.0_rc2).

The library was created to provide convienent interface for iOS applications to communicate with [Iroha](https://github.com/hyperledger/iroha) blockchain including sending transactions/query, streaming transaction statuses and block commits.

## Example

For new iroha users we recommend to checkout iOS example project. It tries to establish connection with Iroha peer which should be also run locally on your computer to create new account and send some asset quantity to it. To run the project, please, go through steps below:

1. Follow instructions from [Iroha documentation](https://iroha.readthedocs.io/en/latest/getting_started/) to setup and run iroha peer in [Docker](https://www.docker.com) container.

2. Clone current repositary.

3. cd Example directory and run ```pod install```.

4. Open IrohaCommunication.xcworkspace in XCode

6. Build and Run IrohaExample target.

7. Consider logs to see if the scenario completed successfully.

Feel free to experiment with example project and don't hesistate to ask any questions.

## Cocoapods Installation

Iroha iOS library is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'IrohaCommunication'
```

## Author

Ruslan Rezin, rezin@soramitsu.co.jp

## License

Copyright 2018 Soramitsu Co., Ltd.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
```
http://www.apache.org/licenses/LICENSE-2.0
```
Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

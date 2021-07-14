# IrohaSwiftSDK

[![Version](https://img.shields.io/cocoapods/v/IrohaSwiftSDK.svg?style=flat)](https://cocoapods.org/pods/IrohaSwiftSDK)
[![License](https://img.shields.io/cocoapods/l/IrohaSwiftSDK.svg?style=flat)](https://cocoapods.org/pods/IrohaSwiftSDK)
[![Platform](https://img.shields.io/cocoapods/p/IrohaSwiftSDK.svg?style=flat)](https://cocoapods.org/pods/IrohaSwiftSDK)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

IrohaSwiftSDK is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'IrohaSwiftSDK'
```

## Tools to inject model into your project

There is a `bin` directory for this purpose, which contains each file for its own purposes.

### iroha-build-swift-schema
Prebuilt binary from `IrohaSwiftSchemaBuilder` which makes Swift files from provided JSON schema for Iroha

Usage for development purposes
```bash
./bin/iroha-build-swift-schema --dev /path/to/schema.json /path/to/save/generated/schema
```

Usage for injecting into an .xcodeproj
```bash
./bin/iroha-build-swift-schema /path/to/schema.json /path/to/Target.xcodeproj Group/Path/Inside/Xcodeproj (comma-separated list of Swift frameworks to import for each file)
```

### iroha-inject-swift-schema.rb
This is only needed when you want to put your files in final Xcode project, not into development pods
Please note that it uses prebuilt `xcodeproj` ruby library by CocoaPods, so you are free to provide fake path as ARGV[0] for Ruby's load path if you have this already in your global load path
```bash
ruby ./bin/iroha-inject-swift-schema.rb /path/to/ruby/xcodeproj/lib /path/to/Target.xcodeproj /path/to/root/directory/contains/generated/model
```

### iroha-install-swift-schema.sh
This is the script you actually should to preload Ruby `xcodeproj`, build Iroha Swift schema, and inject into your project
Please note that if you don't provide optional comma-separated Swift frameworks list, it's considered that you inject model into development Pod, so ruby injector is not being executed

Example to build schema and inject into your Project:
```bash
./bin/iroha-install-swift-schema.sh Example/IrohaSwiftSDK/schema.json Example/IrohaSwiftSDK.xcodeproj GeneratedIrohaModel IrohaSwiftScale
```

Example to generate schema into your own SDK pod:
```bash
./bin/iroha-install-swift-schema.sh --dev Example/IrohaSwiftSDK/schema.json IrohaSwiftSDK/Classes/Schema IrohaSwiftScale
```

## Author

Soramitsu Co Ltd, admin@soramitsu.co.jp

## License

IrohaSwiftSDK is available under the Apache License, Version 2.0. See the LICENSE file for more info.

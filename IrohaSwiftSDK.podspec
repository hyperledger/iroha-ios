Pod::Spec.new do |s|
  s.name             = 'IrohaSwiftSDK'
  s.version          = '1.0.0'
  s.summary          = 'SDK for communication with Hyperledger Iroha v2 API'

  s.homepage         = 'https://github.com/hyperledger/iroha-ios'
  s.license          = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.author           = { 'Soramitsu Co Ltd' => 'admin@soramitsu.co.jp' }
  s.source           = { :git => 'https://github.com/hyperledger/iroha-ios.git', :tag => 'v2-' + s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'IrohaSwiftSDK/Classes/**/*'
  s.dependency 'IrohaSwiftScale'
end

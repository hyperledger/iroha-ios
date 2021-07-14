Pod::Spec.new do |s|
  s.name             = 'IrohaSwiftScale'
  s.version          = '1.0.0'
  s.summary          = 'Swift library for Hyperledger Iroha v2 SCALE coding'

  s.homepage         = 'https://github.com/hyperledger/iroha-ios'
  s.license          = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.author           = { 'Soramitsu Co Ltd' => 'admin@soramitsu.co.jp' }
  s.source           = { :git => 'https://github.com/hyperledger/iroha-ios.git', :tag => 'v2-' + s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'IrohaSwiftScale/Classes/**/*'
end

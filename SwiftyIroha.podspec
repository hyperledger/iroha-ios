Pod::Spec.new do |s|
s.name             = 'SwiftyIroha'
s.version          = '0.0.7-alpha'
s.summary          = 'Hyperledger Iroha iOS library'
s.homepage         = 'http://www.soramitsu.co.jp/'
s.license          = 'Apache License Version 2.0'
s.author           = { 'Soramitsu Co., Ltd.' => 'alexey@soramitsu.co.jp' }

s.homepage         = 'https://github.com/soramitsu/iroha-ios'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.source           = { :git => 'https://github.com/soramitsu/iroha-ios.git', :tag => s.version.to_s }

s.ios.deployment_target = '10.0'
s.source_files = 'SwiftyIroha/Swift/**/*.swift','SwiftyIroha/ObjC++/**/*.{h,mm}','SwiftyIroha/headers/**/*.{hpp}'

s.dependency 'SwiftProtobuf', '~> 1.0'
s.compiler_flags = '-DDISABLE_BACKWARD'
s.header_dir = 'SwiftyIroha'
s.header_mappings_dir = 'SwiftyIroha'
end

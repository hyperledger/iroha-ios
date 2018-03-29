Pod::Spec.new do |s|
s.name             = 'SwiftyIroha'
s.version          = '1.0.0'
s.summary          = 'Hyperledger Iroha ios library'
s.homepage         = 'http://www.soramitsu.co.jp/'
s.license          = 'Apache License Version 2.0'
s.author           = { 'Soramitsu Co., Ltd.' => 'alexey@soramitsu.co.jp' }

s.homepage         = 'https://github.com/soramitsu/iroha-ios'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.source           = { :git => 'https://github.com/soramitsu/iroha-ios.git', :tag => s.version.to_s }

s.ios.deployment_target = '10.0'
s.source_files = 'SwiftyIroha/SharewModel/Swift/**/*.swift', 'SwiftyIroha/SharewModel/ObjC++/**/*.{h,mm}', 'SwiftyIroha/GRPC/ProtoClasses/*.swift'

s.dependency 'SwiftProtobuf', '~> 1.0'
s.compiler_flags = '-DDISABLE_BACKWARD'
s.header_dir = 'headers'

end

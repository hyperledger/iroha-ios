Pod::Spec.new do |s|
  s.name         = "IrohaSwift"
  s.version      = "0.0.1"
  s.summary      = "Easy create signature of Iroha Blockchain"
  s.homepage     = "http://www.soramitsu.co.jp/"
  s.license      = "Apache License Version 2.0"
  s.author             = { "Soramitsu Co., Ltd." => "info@soramitsu.co.jp" }
  s.source       = { :git => "https://github.com/soramitsu/IrohaSwift.git", :tag => "#{s.version}" }
  s.ios.deployment_target = '9.0'
  s.source_files = 'lib/**/*.{h,c}','IrohaSwift/*.swift'
  s.module_name = "IrohaSwift"
  s.preserve_paths  = 'lib/**/*'
  s.pod_target_xcconfig = { 'HEADER_SEARCH_PATHS' => '$(PODS_ROOT)/**' }
  s.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(PODS_ROOT)/**', 'SWIFT_INCLUDE_PATHS' => '$(PODS_ROOT)/**' }
end

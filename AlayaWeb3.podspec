
Pod::Spec.new do |s|

  s.name         = "AlayaWeb3"

  s.version      = "0.13.2"

  s.summary      = "AlayaWeb3 SDK is a Swift development kit for PlatON public chain provided by PlatON for iOS developers."

  s.description  = "AlayaWeb3 SDK is a Swift development kit for PlatON public chain provided by PlatON for iOS developers."

  s.homepage     = "https://github.com/PlatONnetwork/alaya-client-sdk-ios"
  
  s.license      = "MIT"
  
  s.author = { "chendai" => "daniel@platon.network" }

  s.source       = { :git => "https://github.com/PlatONnetwork/alaya-client-sdk-ios", :tag => "0.13.2" }

  s.source_files = "source/**/*.swift"

  s.platform     = :ios, "9.0"

  s.dependency 'BigInt', '~> 5.2.0'
  s.dependency 'CryptoSwift', '~> 1.3.1'
  s.dependency 'secp256k1.swift', '~> 0.1.4'
  s.dependency 'Localize-Swift', '~> 3.1.0'
  s.swift_versions = ['5.0', '5.1', '5.2']

  s.pod_target_xcconfig = { 'c' => '-Owholemodule' }

end

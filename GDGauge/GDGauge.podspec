Pod::Spec.new do |s|
s.name             = "GDGauge"
s.version          = "1.2.0"
s.summary          = "Easy to use, highly customizable gauge view"
s.homepage         = "https://github.com/saeid/GDGauge"
s.license          = 'MIT'
s.author           = { "Saeid Basirnia" => "basirnia@icloud.com" }
s.source           = { :git => "https://github.com/saeid/GDGauge.git", :tag => "1.2.0"}

s.pod_target_xcconfig = { 'SWIFT_VERSION' => '5.0' }
s.platform     = :ios
s.ios.deployment_target  = '9.0'
s.requires_arc = true
s.swift_version = '5.0'
s.source_files = 'Sources/GDGauge/**/*.{swift}'
s.frameworks = 'UIKit'

end



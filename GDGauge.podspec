Pod::Spec.new do |s|
s.name             = "GDGauge"
s.version          = "1.0.0"
s.summary          = "Full Customizable, Beautiful, Easy to use gauge view"
s.homepage         = "https://github.com/saeid/GDGauge"
s.license          = 'MIT'
s.author           = { "Saeid Basirnia" => "saeid.basirniaa@gmail.com" }
s.source           = { :git => "https://github.com/saeid/GDGauge", :tag => "1.0.0"}

s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }
s.platform     = :ios
s.ios.deployment_target  = '9.0'
s.requires_arc = true
s.swift_version = '4.0'
s.source_files = 'source/GDGauge/**/*'
s.frameworks = 'UIKit'

end



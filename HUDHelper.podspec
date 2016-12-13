#
# Be sure to run `pod lib lint HUDHelper.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HUDHelper'
  s.version          = '0.2.0'
  s.summary          = 'A wrapper of method chaining for MBProgressHUD.'

  s.description      = <<-DESC
HUDHelper defines 'Indicator' and 'Toast' based on MBProgressHUD, the indicator acts as the default behaviour of MBProgressHUD, the toast will hide automatically.
The original intention of this wrapper is to separate the MBProgressHUD usage from UIViewController and call it easily.
                       DESC

  s.homepage         = 'https://github.com/xingheng/HUDHelper'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Will Han' => 'xingheng.hax@qq.com' }
  s.source           = { :git => 'https://github.com/xingheng/HUDHelper.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'HUDHelper/**/*'

  s.public_header_files = 'HUDHelper/HUDHelper.h'
  s.frameworks = 'UIKit'
  s.dependency 'MBProgressHUD', '> 0.9'
end

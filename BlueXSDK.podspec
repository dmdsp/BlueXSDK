#
# Be sure to run `pod lib lint BlueXSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BlueXSDK'
  s.version          = '0.1.0'
  s.summary          = 'A lightweight ad SDK. 轻量级广告SDK'

  # 简要描述（中英文）
  s.description      = <<-DESC
  BlueXSDK is a lightweight ad SDK for iOS, easy to integrate and use.
  BlueXSDK 是一个轻量级的 iOS 广告 SDK，集成简单，使用方便。
  DESC

  s.homepage         = 'https://github.com/dmdsp/BlueXSDK'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'shilin.liu' => 'shilin.liu@domob.cn' }
  s.source           = { :git => 'https://github.com/dmdsp/DomobAdSDK.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  
  s.ios.deployment_target = '10.0'
  
# s.source_files = 'DomobSDK/Classes/**/*'
  
  s.frameworks = 'AdSupport', 'AppTrackingTransparency', 'CoreMotion', 'CoreTelephony'
  s.dependency 'Protobuf', '~> 3.27'
  s.vendored_frameworks = 'BlueXSDK/Classes/DomobAdSDK.xcframework'
  s.resource_bundles = {
    'DomobAdSDK_Bundle' => ['BlueXSDK/Classes/DomobAdSDK_Bundle.bundle/**/*']
  }
  
  s.static_framework = true
end

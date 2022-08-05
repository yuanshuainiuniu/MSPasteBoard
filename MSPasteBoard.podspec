#
# Be sure to run `pod lib lint MSPasteBoard.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MSPasteBoard'
  s.version          = '0.1.2'
  s.summary          = 'M1芯片下xcode模拟器使用粘贴板'


  s.description      = <<-DESC
  解决，M1芯片下，模拟器在排查arm64架构（为兼容一些老框架）后，粘贴板无法互通问题
                       DESC

  s.homepage         = 'https://github.com/yuanshuainiuniu/MSPasteBoard'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Marshal' => '717999274qq.com' }
  s.source           = { :git => 'https://github.com/yuanshuainiuniu/MSPasteBoard.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'MSPasteBoard/Classes/**/*'
  
  # s.resource_bundles = {
  #   'MSPasteBoard' => ['MSPasteBoard/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end

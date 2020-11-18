#
# Be sure to run `pod lib lint SocialLogins.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SocialLogins'
  s.version          = '0.1.2'
  s.summary          = 'SocialLogins makes integration easier.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'This package collects famous login providers such as Apple, Google for easy integration'

  s.homepage         = 'https://github.com/eneskaraosman/SocialLogins'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'eneskaraosman' => 'eneskaraosman53@gmail.com' }
  s.source           = { :git => 'https://github.com/eneskaraosman/SocialLogins.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.swift_version    = '5.0'
  s.ios.deployment_target = '13.0'
  s.platform = :ios, '13.0'
  s.static_framework = true
  s.source_files = 'SocialLogins/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SocialLogins' => ['SocialLogins/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
   s.dependency 'GoogleSignIn'
end

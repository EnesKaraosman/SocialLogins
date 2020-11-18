#
# Be sure to run `pod lib lint SocialLogins.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SocialLogins'
  s.version          = '0.1.4'
  s.summary          = 'SocialLogins makes integration easier.'
  s.description      = <<-DESC
This package collects famous login providers such as Apple, Google for easy integration.
                       DESC

  s.homepage         = 'https://github.com/eneskaraosman/SocialLogins'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'eneskaraosman' => 'eneskaraosman53@gmail.com' }
  s.source           = { :git => 'https://github.com/eneskaraosman/SocialLogins.git', :tag => s.version.to_s }

  s.swift_version    = '5.0'
  s.ios.deployment_target = '13.0'
  s.platform = :ios, '13.0'
  s.static_framework = true
  s.source_files = 'SocialLogins/Classes/**/*.swift'
  s.exclude_files = 'SocialLogins/*.plist'
  s.dependency 'GoogleSignIn'
end

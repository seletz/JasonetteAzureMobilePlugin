#
# Be sure to run `pod lib lint JasonetteAzureMobilePlugin.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JasonetteAzureMobilePlugin'
  s.version          = '0.1.1'
  s.summary          = 'Azure Mobile action plug-in for Jasonette.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
This module adds Azure Mobile actions to Jasonette.
                       DESC

  s.homepage         = 'https://github.com/seletz/JasonetteAzureMobilePlugin'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Stefan Eletzhofer' => 'se@nexiles.de' }
  s.source           = { :git => 'https://github.com/seletz/JasonetteAzureMobilePlugin.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/seletz'

  s.ios.deployment_target = '8.0'

  s.source_files = 'JasonetteAzureMobilePlugin/Classes/**/*'
  
  # s.resource_bundles = {
  #   'JasonetteAzureMobilePlugin' => ['JasonetteAzureMobilePlugin/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'MicrosoftAzureMobile'
end

#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'image_gallery_saver'
  s.version          = '2.0.9'
  s.summary          = 'A Flutter plugin for saving images to gallery with AGP 7.3+ compatibility.'
  s.description      = <<-DESC
A Flutter plugin for saving images to gallery. Fixed version of image_gallery_saver2 with Android namespace issues resolved for AGP 7.3+.
                       DESC
  s.homepage         = 'https://github.com/boughdiri-dorsaf/image_gallery_saver2_fixed'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Boughdiri Dorsaf' => 'boughdiridorsaf12@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'

  s.ios.deployment_target = '9.0'
  s.swift_version = '5.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
end


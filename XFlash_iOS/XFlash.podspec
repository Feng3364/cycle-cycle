Pod::Spec.new do |s|
  # ———————————————————— Info ————————————————————
  
  s.name             = 'XFlash'
  s.version          = '0.0.1'
  s.summary          = '快速开发的工具&公共&服务库.'

  s.homepage         = 'https://github.com/Feng3364/XFlash'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Felix Feng' => '840385400@qq.com' }
  s.source           = { :git => 'https://github.com/Feng3364/XFlash.git', :tag => s.version.to_s }
  
  # ———————————————————— Platform ————————————————————
  
  s.platform = :ios
  s.cocoapods_version = '>= 0.36'
  s.ios.deployment_target = '10.0'
  s.swift_versions = ['5.0', '5.1', '5.2', '5.3', '5.4', '5.5']

  # ———————————————————— File patterns ————————————————————
  
  s.subspec "Public" do |p|
    p.source_files = 'XFlash/Classes/Public/**/*'
  end
  
  s.subspec "CommonUI" do |c|
    c.source_files = 'XFlash/Classes/CommonUI/**/*'
  end

  s.subspec "Service" do |ss|
    ss.source_files = 'XFlash/Classes/Service/**/*'
  end
  
  # ———————————————————— Build settings ————————————————————
  
  # s.resource_bundles = {
  #   'XFlash' => ['XFlash/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end

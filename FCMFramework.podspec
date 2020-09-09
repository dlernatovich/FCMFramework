Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.name         = "FCMFramework"
  spec.version      = "1.0.0"
  spec.summary      = "Framework which provide the customization for the Firebase Messaging"
  spec.description  = "Framework which provide the customization for the Firebase Messaging"
  spec.homepage     = "https://github.com/dlernatovich/FCMFramework.git"

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.license      = { :type => "MIT", :file => "LICENSE" }

  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.author             = { "Dmitry Lernatovich" => "https://github.com/dlernatovich" }

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.platform     = :ios
  spec.ios.deployment_target = '12.0'
  spec.requires_arc = true
  spec.swift_version = '5.0'

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.source       = { :git => "https://github.com/dlernatovich/FCMFramework.git" }
  spec.source_files = "FCMFramework/**/*.{swift}"

  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.static_framework = true
  spec.framework = "UIKit"
  spec.dependency 'Firebase/Core'
  spec.dependency 'Firebase/Messaging'

end

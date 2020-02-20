Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.name         = "FCMFramework"
  spec.version      = "1.0.0"
  spec.summary      = "Framework which provide the customization for the Firebase Messaging"
  spec.description  = "Framework which provide the customization for the Firebase Messaging"
  spec.homepage     = "https://google.com/"
  #spec.screenshots  = "https://cloud.githubusercontent.com/assets/4073988/5912371/144aaf24-a588-11e4-9a22-42832eb2c235.gif", "https://cloud.githubusercontent.com/assets/4073988/5912454/15774398-a589-11e4-8f08-18c9c7b59871.gif", "https://cloud.githubusercontent.com/assets/4073988/6628373/183c7452-c8c2-11e4-9a63-107805bc0cc4.gif", "https://cloud.githubusercontent.com/assets/4073988/5912297/c3f21bb2-a586-11e4-8eb1-a1f930ccbdd5.gif"

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.license      = { :type => "MIT", :file => "LICENSE" }

  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.author             = { "Dmitry Lernatovich" => "https://google.com/" }

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.platform     = :ios
  spec.ios.deployment_target = '10.0'
  spec.requires_arc = true
  spec.swift_version = '4.0'

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.source       = { :git => "https://github.com/SwiftArchitect/TGPControls.git", :tag => "v5.1.0" }
  spec.source_files = "FCMFramework/**/*.{swift}"
  #spec.exclude_files = "TGPControlsDemo/*"

  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.static_framework = true
  spec.framework = "UIKit"
  spec.dependency 'Firebase/Core'
  spec.dependency 'Firebase/Messaging'

end

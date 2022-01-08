# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'KNU_Plate_iOS' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for KNU_Plate_iOS
  pod 'SnapKit'
  pod 'Alamofire', '~> 5.2'
  pod 'IQKeyboardManagerSwift'
  pod "BSImagePicker", "~> 3.1"
  pod 'Then'
  pod 'ProgressHUD'
  pod 'SwiftyJSON', '~> 4.0'
  pod 'SwiftKeychainWrapper'
  pod 'SDWebImage', '~> 5.0'
  pod 'SPIndicator'
  pod 'SnackBar.swift'
  pod "GTProgressBar"
  pod "ViewAnimator"
  pod 'EasyTipView', '~> 2.1'
  pod 'PanModal'
  pod 'ImageSlideshow', '~> 1.9.0'
  pod "ImageSlideshow/SDWebImage"
  pod 'TextFieldEffects'
  pod 'lottie-ios'
  
  #Rx
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxViewController'
  pod 'RxAnimated'
  pod 'RxGesture'
  pod 'RxKeyboard'


post_install do |installer|   
      installer.pods_project.build_configurations.each do |config|
        config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
      end
end




end

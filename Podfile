workspace 'Squeak.xcworkspace'

use_frameworks!

source 'git@github.com:CocoaPods/Specs.git'

project 'Squeak.xcodeproj'

def ios_platform
  platform :ios, '10.0'
end

def macos_platform
  platform :macos, '10.13'
end

def rxswift_pods
  pod 'RxSwift', '~> 4.0.0-rc.0'
  pod 'RxCocoa', '~> 4.0.0-rc.0'
end

def xml_pods
  pod 'SWXMLHash', '~> 4.2.3'
end

def ios_pods
  rxswift_pods
  xml_pods
  pod 'JGProgressHUD', '~> 2.0'
end

target 'Squeak-iOS' do
  ios_platform

  ios_pods

  target 'Squeak-iOSTests' do
    inherit! :search_paths
  end
end

target 'Squeak-macOS' do
  macos_platform

  rxswift_pods

  target 'Squeak-macOSTests' do
    inherit! :search_paths
  end
end

target 'Squeak-Core-iOS' do
  ios_platform

  project 'Squeak-Core/Squeak-Core.xcodeproj'

  ios_pods

  target 'Squeak-Core-iOSTests' do
    inherit! :search_paths
  end
end

target 'Squeak-Core-macOS' do
  macos_platform

  project 'Squeak-Core/Squeak-Core.xcodeproj'

  rxswift_pods
  xml_pods

  target 'Squeak-Core-macOSTests' do
    inherit! :search_paths
  end
end

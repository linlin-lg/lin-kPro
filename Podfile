# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'


#source 'gitkpl:kpl_Specs'
#source 'https://cdn.cocoapods.org/'


use_modular_headers!

target 'kPro' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for kPro
pod 'SnapKit' , '5.7.1'
pod 'CocoaAsyncSocket' , '7.6.5'
pod 'SwiftProtobuf' , '1.16.0'

# 本地库依赖
pod 'MyLocalLibrary', :path => './LocalLibraries/MyLocalLibrary'

target 'kProTests' do
  inherit! :search_paths
  # Pods for testing
end

target 'kProUITests' do
  # Pods for testing
end

end

Pod::Spec.new do |spec|
  spec.name         = "MyLocalLibrary"
  spec.version      = "1.0.0"
  spec.summary      = "一个示例本地库"
  spec.description  = "这是一个用于演示如何在本地添加库并使用CocoaPods管理的示例库"
  
  spec.homepage     = "https://github.com/yourusername/MyLocalLibrary"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Your Name" => "your.email@example.com" }
  
  spec.platform     = :ios, "12.0"
  spec.swift_version = "5.0"
  
  spec.source       = { :path => "." }
  spec.source_files = "*.swift"
  
  spec.requires_arc = true
  
  spec.dependency 'SnapKit'
end

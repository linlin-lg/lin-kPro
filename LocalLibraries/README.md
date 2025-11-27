# 本地库管理指南

本指南展示了如何在iOS项目中使用CocoaPods管理本地库。

## 项目结构

```
kPro/
├── LocalLibraries/           # 本地库目录
│   └── MyLocalLibrary/       # 示例本地库
│       ├── MyLocalLibrary.swift      # 库的源代码
│       ├── MyLocalLibrary.podspec    # CocoaPods配置文件
│       ├── LICENSE                   # 许可证文件
│       └── README.md                 # 库的说明文档
├── Podfile                   # CocoaPods依赖配置
└── Podfile.lock             # 依赖锁定文件
```

## 创建本地库的步骤

### 1. 创建库目录结构
```bash
mkdir -p LocalLibraries/MyLocalLibrary
```

### 2. 编写库的源代码
创建 `MyLocalLibrary.swift` 文件，包含库的功能实现。

### 3. 创建 .podspec 文件
创建 `MyLocalLibrary.podspec` 文件，定义库的元数据：

```ruby
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
```

### 4. 更新 Podfile
在 `Podfile` 中添加本地库依赖：

```ruby
target 'kPro' do
  use_frameworks!
  
  # 其他依赖...
  
  # 本地库依赖
  pod 'MyLocalLibrary', :path => './LocalLibraries/MyLocalLibrary'
end
```

### 5. 安装依赖
```bash
pod install
```

### 6. 在项目中使用
```swift
import MyLocalLibrary

// 使用库的功能
let info = MyLocalLibrary.getInfo()
let sum = MyLocalLibrary.add(5, 3)
```

## 本地库的优势

1. **版本控制**: 可以轻松管理库的版本
2. **依赖管理**: 可以指定其他库作为依赖
3. **代码复用**: 在多个项目间共享代码
4. **开发效率**: 本地修改立即生效，无需发布到远程仓库

## 注意事项

1. 确保 `.podspec` 文件中的路径配置正确
2. 本地库的依赖也会被自动安装
3. 修改本地库后需要重新运行 `pod install`
4. 建议为本地库创建适当的文档和测试

## 示例输出

当应用启动时，控制台会输出：

```
📚 本地库信息: MyLocalLibrary v1.0.0
🧮 数学计算: 10 + 20 = 30
⏰ 当前时间: 2024-01-01 12:00:00
🎲 随机字符串: Abc123
```

这证明本地库已经成功集成到项目中！

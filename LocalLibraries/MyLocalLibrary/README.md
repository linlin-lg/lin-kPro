# MyLocalLibrary

一个示例本地库，用于演示如何在iOS项目中使用CocoaPods管理本地库。

## 功能

- 获取库信息
- 数学计算
- 时间格式化
- 随机字符串生成

## 使用方法

```swift
import MyLocalLibrary

// 获取库信息
let info = MyLocalLibrary.getInfo()
print(info) // 输出: MyLocalLibrary v1.0.0

// 数学计算
let sum = MyLocalLibrary.add(5, 3)
print(sum) // 输出: 8

// 获取当前时间
let timeString = MyLocalLibrary.getCurrentTimeString()
print(timeString) // 输出: 2024-01-01 12:00:00

// 生成随机字符串
let randomString = MyLocalLibrary.generateRandomString(length: 8)
print(randomString) // 输出: Abc123Xy
```

## 安装

在Podfile中添加：

```ruby
pod 'MyLocalLibrary', :path => './LocalLibraries/MyLocalLibrary'
```

然后运行：

```bash
pod install
```

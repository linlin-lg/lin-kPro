import Foundation

/// 一个示例本地库
public class MyLocalLibrary {
    
    /// 库的版本号
    public static let version = "1.0.0"
    
    /// 库的名称
    public static let name = "MyLocalLibrary"
    
    /// 获取库信息
    public static func getInfo() -> String {
        return "\(name) v\(version)"
    }
    
    /// 示例方法：计算两个数的和
    public static func add(_ a: Int, _ b: Int) -> Int {
        return a + b
    }
    
    /// 示例方法：格式化当前时间
    public static func getCurrentTimeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: Date())
    }
    
    /// 示例方法：生成随机字符串
    public static func generateRandomString(length: Int = 10) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map { _ in characters.randomElement()! })
    }
}

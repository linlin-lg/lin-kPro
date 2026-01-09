import Foundation

struct Stock: Codable {
    let symbol: String
    let name: String
    var price: Double
    var change: Double
    var changePercent: Double
    var volume: Int
    
    
    // 分时数据
    struct TimeData: Codable {
        let timestamp: TimeInterval
        let price: Double
        let volume: Int
    }
    
    // 当日分时数据
    var timeData: [TimeData] = []
    
    var exp: String?
}

// 用于在Note中保存股票信息
extension Stock {
    var noteDescription: String {
        return "\(name) (\(symbol))\n当前价格: ¥\(String(format: "%.2f", price))\n涨跌: \(String(format: "%.2f", change)) (\(String(format: "%.2f", changePercent))%)"
    }
} 

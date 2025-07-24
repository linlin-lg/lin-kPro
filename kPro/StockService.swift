import Foundation

class StockService {
    static let shared = StockService()
    
    private init() {}
    
    // 模拟数据 - 实际项目中需要替换为真实的股票API
    func searchStocks(keyword: String, completion: @escaping ([Stock]) -> Void) {
        // 模拟延迟
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let stocks = [
                Stock(symbol: "600519", name: "贵州茅台", price: 1789.98, change: 23.45, changePercent: 1.32, volume: 1234567),
                Stock(symbol: "000858", name: "五粮液", price: 167.89, change: -2.34, changePercent: -1.38, volume: 987654),
                Stock(symbol: "601318", name: "中国平安", price: 45.67, change: 0.45, changePercent: 0.99, volume: 2345678)
            ].filter { $0.name.contains(keyword) || $0.symbol.contains(keyword) }
            completion(stocks)
        }
    }
    
    func fetchStockDetail(symbol: String, completion: @escaping (Stock?) -> Void) {
        // 模拟延迟
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            var stock = Stock(symbol: symbol, name: "贵州茅台", price: 1789.98, change: 23.45, changePercent: 1.32, volume: 1234567)
            
            // 生成模拟的分时数据
            let calendar = Calendar.current
            let now = Date()
            let marketOpen = calendar.date(bySettingHour: 9, minute: 30, second: 0, of: now)!
            
            var timeData: [Stock.TimeData] = []
            for i in 0..<240 { // 4小时交易时间，每分钟一个数据点
                let timestamp = marketOpen.timeIntervalSince1970 + Double(i * 60)
                let price = 1789.98 + Double.random(in: -20...20)
                let volume = Int.random(in: 1000...10000)
                timeData.append(Stock.TimeData(timestamp: timestamp, price: price, volume: volume))
            }
            
            stock.timeData = timeData
            completion(stock)
        }
    }
} 

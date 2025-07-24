import Foundation

// MARK: - Feature Configuration Models
struct FeatureConfig: Codable {
    let isEnabled: Bool
    let minAppVersion: String?
    let maxAppVersion: String?
}

struct AppConfig: Codable {
    let version: String
    let isShowSetting: FeatureConfig?
    let isShowSpecialButton: FeatureConfig?
}

class ConfigManager {
    static let shared = ConfigManager()
    private init() {}
    
    private(set) var config: AppConfig?
    
    // MARK: - UserDefaults Keys
    private let configKey = "AppFeatureConfig"
    private let lastFetchTimeKey = "LastConfigFetchTime"
    private let cacheExpirationInterval: TimeInterval = 3600 // 1小时缓存过期
    
    // MARK: - Configuration Management
    
    /// 获取配置（优先从网络获取，失败时使用本地缓存）
    func fetchConfig(completion: @escaping (AppConfig) -> Void) {
        // 首先尝试从本地缓存加载
        if let cachedConfig = loadConfigFromCache() {
            self.config = cachedConfig
            completion(cachedConfig)
        }
        
        // 异步从服务端获取最新配置
        fetchConfigFromServer { [weak self] serverConfig in
            if let serverConfig = serverConfig {
                // 成功获取到服务器配置，保存到本地并更新
                self?.saveConfigToCache(serverConfig)
                self?.config = serverConfig
                DispatchQueue.main.async {
                    completion(serverConfig)
                }
            } else {
                // 服务器获取失败，使用本地缓存
                if let cachedConfig = self?.loadConfigFromCache() {
                    self?.config = cachedConfig
                    DispatchQueue.main.async {
                        completion(cachedConfig)
                    }
                } else {
                    // 本地也没有缓存，使用默认配置
                    let defaultConfig = self?.createDefaultConfig()
                    self?.config = defaultConfig
                    DispatchQueue.main.async {
                        completion(defaultConfig ?? AppConfig(version: "1.0.0", isShowSetting: nil, isShowSpecialButton: nil))
                    }
                }
            }
        }
    }
    
    /// 从服务器获取配置
    private func fetchConfigFromServer(completion: @escaping (AppConfig?) -> Void) {
        // 模拟网络延迟
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            // 模拟的JSON字符串
            let jsonString = """
            {
                "version": "1.0",
                "sendLog": {
                    "isEnabled": true,
                    "minAppVersion": "5.21.0.1",
                    "maxAppVersion": ""
                },
                "showSpecial": {
                    "isEnabled": true,
                    "minAppVersion": "5.21.0.1",
                    "maxAppVersion": ""
                }
            }
            """
            
            let data = jsonString.data(using: .utf8)!
            let decoder = JSONDecoder()
            
            if let config = try? decoder.decode(AppConfig.self, from: data) {
                completion(config)
            } else {
                completion(nil)
            }
        }
    }
    
    // MARK: - Local Storage Methods
    
    /// 保存配置到本地缓存
    private func saveConfigToCache(_ config: AppConfig) {
        do {
            let data = try JSONEncoder().encode(config)
            UserDefaults.standard.set(data, forKey: configKey)
            UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: lastFetchTimeKey)
            print("配置已保存到本地缓存")
        } catch {
            print("保存配置到本地失败: \(error)")
        }
    }
    
    /// 从本地缓存加载配置
    private func loadConfigFromCache() -> AppConfig? {
        guard let data = UserDefaults.standard.data(forKey: configKey) else {
            print("本地没有缓存配置")
            return nil
        }
        
        // 检查缓存是否过期
        if isCacheExpired() {
            print("本地缓存已过期")
            return nil
        }
        
        do {
            let config = try JSONDecoder().decode(AppConfig.self, from: data)
            print("从本地缓存加载配置成功")
            return config
        } catch {
            print("解析本地缓存配置失败: \(error)")
            return nil
        }
    }
    
    /// 检查缓存是否过期
    private func isCacheExpired() -> Bool {
        let lastFetchTime = UserDefaults.standard.double(forKey: lastFetchTimeKey)
        let currentTime = Date().timeIntervalSince1970
        return (currentTime - lastFetchTime) > cacheExpirationInterval
    }
    
    /// 清除本地缓存
    func clearCache() {
        UserDefaults.standard.removeObject(forKey: configKey)
        UserDefaults.standard.removeObject(forKey: lastFetchTimeKey)
        print("本地缓存已清除")
    }
    
    /// 创建默认配置
    private func createDefaultConfig() -> AppConfig {
        return AppConfig(
            version: "1.0.0",
            isShowSetting: FeatureConfig(isEnabled: false, minAppVersion: nil, maxAppVersion: nil),
            isShowSpecialButton: FeatureConfig(isEnabled: false, minAppVersion: nil, maxAppVersion: nil)
        )
    }
    
    // MARK: - Feature Control Methods
    
    /// 判断指定功能是否启用
    /// - Parameter key: 功能键名
    /// - Returns: 是否启用
    func isFeatureEnabled(key: String) -> Bool {
        guard let config = config else { return false }
        
        let featureConfig: FeatureConfig?
        
        switch key {
        case "isShowSetting":
            featureConfig = config.isShowSetting
        case "isShowSpecialButton":
            featureConfig = config.isShowSpecialButton
        default:
            return false
        }
        
        guard let feature = featureConfig else { return false }
        
        // 检查基本开关
        if !feature.isEnabled {
            return false
        }
        
        // 检查App版本
        if !isAppVersionCompatible(minVersion: feature.minAppVersion, maxVersion: feature.maxAppVersion) {
            return false
        }
        
        return true
    }
    
    /// 检查App版本兼容性
    /// - Parameters:
    ///   - minVersion: 最小版本
    ///   - maxVersion: 最大版本
    /// - Returns: 是否兼容
    private func isAppVersionCompatible(minVersion: String?, maxVersion: String?) -> Bool {
        let currentVersion = getCurrentAppVersion()
        
        // 检查最小版本
        if let minVersion = minVersion {
            if compareVersions(currentVersion, minVersion) < 0 {
                return false
            }
        }
        
        // 检查最大版本
        if let maxVersion = maxVersion {
            if compareVersions(currentVersion, maxVersion) > 0 {
                return false
            }
        }
        
        return true
    }
    
    /// 获取当前App版本
    /// - Returns: 当前版本字符串
    private func getCurrentAppVersion() -> String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }
    
    /// 比较版本号
    /// - Parameters:
    ///   - version1: 版本1
    ///   - version2: 版本2
    /// - Returns: 比较结果 (-1: version1 < version2, 0: 相等, 1: version1 > version2)
    private func compareVersions(_ version1: String, _ version2: String) -> Int {
        let components1 = version1.components(separatedBy: ".").compactMap { Int($0) }
        let components2 = version2.components(separatedBy: ".").compactMap { Int($0) }
        
        let maxLength = max(components1.count, components2.count)
        
        for i in 0..<maxLength {
            let v1 = i < components1.count ? components1[i] : 0
            let v2 = i < components2.count ? components2[i] : 0
            
            if v1 < v2 {
                return -1
            } else if v1 > v2 {
                return 1
            }
        }
        
        return 0
    }
    
    // MARK: - Convenience Methods
    
    /// 检查设置按钮是否显示
    var isShowSetting: Bool {
        return isFeatureEnabled(key: "isShowSetting")
    }
    
    /// 检查特殊按钮是否显示
    var isShowSpecialButton: Bool {
        return isFeatureEnabled(key: "isShowSpecialButton")
    }
    
    /// 获取缓存状态信息
    func getCacheInfo() -> (hasCache: Bool, isExpired: Bool, lastFetchTime: Date?) {
        let hasCache = UserDefaults.standard.data(forKey: configKey) != nil
        let isExpired = isCacheExpired()
        let lastFetchTime = UserDefaults.standard.object(forKey: lastFetchTimeKey) as? Date
        return (hasCache, isExpired, lastFetchTime)
    }
} 

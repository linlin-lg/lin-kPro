// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation
import ArgumentParser
import SwiftyJSON

let configJSONFileName = "app_config_data.json"
let configURL = "https://applhb.longhuvip.com/w1/api/index.php?c=System&a=IOSCfgGet"

let versionKey = "version"
let dataKey = "data"
let modeKey = "mode"


@available(macOS 13.0, *)
struct kplconfigfetcher : ParsableCommand {
    @Argument(help: "Path for \(configJSONFileName)")
    var path:String
    
    func run() throws {
        let p = NSURL.fileURL(withPath: path)
        print(p)
        guard FileManager.default.fileExists(atPath: p.path(percentEncoded: false)) else {
            return
        }
        let jsonPath = p.appending(path: configJSONFileName)
        var localVersion = ""
        if FileManager.default.fileExists(atPath: jsonPath.path(percentEncoded: false)) {
            //Read
            if let localJSONData = NSData.init(contentsOf: jsonPath) {
                let localJSON = JSON(localJSONData)
                if let version = localJSON["version"].string {
                    print("Get Local JSON Version:\(version)")
                    localVersion = version
                } else {
                    print("Can't Get Local JSON Version!")
                }
            }
        }
        //Download
        guard let fileDownloadURL = URL.init(string: configURL) else {
            print("Can't Load URL!")
            return
        }
        guard let data = try? Data.init(contentsOf: fileDownloadURL) else {
            print("Can't Fetch JSON Data")
            return
        }
        let jsonData = JSON(data)
        if let serverJSONDataVersion = jsonData[versionKey].string , let dataDic = jsonData[dataKey].dictionary {
            //Compare Version
            if localVersion == "" || compareVersions(localVersion, serverJSONDataVersion) == .orderedAscending {
                print("Server Version > Local Version")
                //Cover
                print("Prepare write to local, Path:\(jsonPath.absoluteString)")
                
                
                
                var newDataJSON : [String:Any] = [:]
                //只保存JSON根目录中只需要的Key
                newDataJSON[versionKey] = serverJSONDataVersion
                newDataJSON[dataKey] = dataDic
                
                if let mode = jsonData[modeKey].string {
                    newDataJSON[modeKey] = mode
                }
                
                do {
                    let newJSONObj = JSON(newDataJSON)
                    let rawData = try newJSONObj.rawData()
                    try rawData.write(to: jsonPath)
                } catch (let e) {
                    print("Can't Write Data to Path,Error:\(e.localizedDescription)")
                }
                
            } else {
                print("Local Version is >= Server Version ")
            }
        }else {
            print("Can't Get Server Validate JSON")
            fatalError("不能获取服务器Config JSON!")
        }
    }
    
    private func compareVersions(_ version1: String, _ version2: String) -> ComparisonResult {
        let v1Components = version1.components(separatedBy: ".")
        let v2Components = version2.components(separatedBy: ".")
        
        let maxLength = max(v1Components.count, v2Components.count)
        
        for i in 0..<maxLength {
            let v1Component = i < v1Components.count ? v1Components[i] : "0"
            let v2Component = i < v2Components.count ? v2Components[i] : "0"
            
            if let v1Value = Int(v1Component), let v2Value = Int(v2Component) {
                if v1Value < v2Value {
                    return .orderedAscending
                } else if v1Value > v2Value {
                    return .orderedDescending
                }
            }
        }
        return .orderedSame
    }
}

if #available(macOS 13.0, *) {
    kplconfigfetcher.main()
} else {
    // Fallback on earlier versions
    print("App Config Fetcher Not Available Because Platform Version!")
}

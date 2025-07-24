//
//  ViewController.swift
//  kPro
//
//  Created by KPLiOS on 2025/5/15.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 显示启动页面
        let launchVC = LaunchViewController()
        addChild(launchVC)
        view.addSubview(launchVC.view)
        launchVC.view.frame = view.bounds
        launchVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        launchVC.didMove(toParent: self)
    }
}



class SafeDataConstants {
    
    @DomainUserDefaulStorage(key: "HqList_Domain_Key")
    static var hq: String?
    
    @DomainUserDefaulStorage(key: "HqList_Domain")
    static var fs: String?
    
    @ThreadSafe static var consList: [String] = []
    static let dataLock = NSLock()
    static var _subList: [String] = []
    static var subList : [String] {
        set {
            dataLock.lock(); defer { dataLock.unlock() }
            _subList = newValue
        }
        get {
            dataLock.lock() ; defer { dataLock.unlock() }
            return _subList
        }
    }
}

@propertyWrapper
class ThreadSafe<T> {
    private var value: T
    private let queue = DispatchQueue(
        label: "com.threadsafe.queue",
        attributes: .concurrent
    )
    init(wrappedValue: T) {
        self.value = wrappedValue
    }
    var wrappedValue: T {
        get {
            queue.sync { value }
        }
        set {
            queue.async(flags: .barrier) { self.value = newValue }
        }
    }
}

@propertyWrapper
struct DomainUserDefaulStorage {
    init(key: String) {
        self.key = key
    }
    private var value: String?
    private var key : String
    var wrappedValue: String? {
        get {
            if let value = value {
                return value
            }
            return UserDefaults.standard.value(forKey: key) as? String
        }
        set {
            value = newValue
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

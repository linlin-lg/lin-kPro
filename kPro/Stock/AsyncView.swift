//
//  AsyncView.swift
//  kPro
//
//  Created by KPLiOS on 2025/11/13.
//

import UIKit

private let onceToken = UUID().uuidString

 class KPLTransaction : NSObject{
    weak var targer : AnyObject?
    var selector : Selector
    init(targer : AnyObject,selector : Selector){
        self.targer = targer
        self.selector = selector
        super.init()
    }
    override var hash: Int{
        get{
            let value1 = selector.hashValue
            if let value2 = targer?.hash {
                return value1 ^ value2
            }
            return value1
        }
    }
    override func isEqual(_ object: Any?) -> Bool {
        if let other = object as? KPLTransaction{
            let bool : Bool = other.hash == self.hash
            return bool
        }else{
            return false
        }
    }
    class func KPLTransactionSetup(){
        KPLDispatchQueue.once_kpl(token: onceToken) {
            transactionSet = Set()
            guard let runloop : CFRunLoop = CFRunLoopGetMain() else{
                return
            }
            let block : CFRunLoopObserverCallBack = { (_,_,_) in
                guard let currentSet = transactionSet  else {
                    return
                }
                guard currentSet.count != 0 else {
                    return
                }
                transactionSet = Set()
                for item in currentSet{
                    if let targer = item.targer, targer.responds(to: item.selector) {
                        let _ = targer.perform(item.selector)
                    }
                }
            }
            let observer : CFRunLoopObserver = CFRunLoopObserverCreate(kCFAllocatorDefault, CFRunLoopActivity.beforeWaiting.rawValue | CFRunLoopActivity.exit.rawValue, true, 0xFFFFFF, block, nil)
            CFRunLoopAddObserver(runloop, observer, CFRunLoopMode.commonModes)
        }
    }
}
var transactionSet : Set<KPLTransaction>?

class KPLDispatchQueue : NSObject {
    static private var tracker = [String]()
    class func once_kpl(token: String, block:()->Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        if tracker.contains(token) {
            return
        }
        tracker.append(token)
        block()
    }
}

class AsyncView: UIView {

    var title : String?
    var color = UIColor.white
    
    @objc func updated() {
        guard let ktext : String = title else {
            return
        }
        let attributes = [NSAttributedString.Key.foregroundColor: color]
        let tempHeight : CGFloat = NSAttributedString(string: ktext, attributes: attributes).boundingRect(with: CGSize.init(width: self.frame.width, height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin,.usesFontLeading] , context: nil).height + 20
        self.frame.size.height = tempHeight
        print("tempHeight = \(tempHeight)")
    }

}

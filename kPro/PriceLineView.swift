//
//  PriceLineView.swift
//  kPro
//
//  Created by KPLiOS on 2025/7/21.
//

import UIKit

class PriceLineView: UIView {
    
    override var frame: CGRect{
        didSet{
            if frame != oldValue{
                priceLineRect = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
                reset()
                setNeedsDisplay()
            }
        }
    }
    ///缓存时分线
    fileprivate(set) var priceLineArr : [CGPoint] = []
    ///缓存均价线
    fileprivate var avgPriceLineArr : [CGPoint] = []
    ///用最高价与最低价与昨收算出来的最大值
    fileprivate var maxPrice : Double = 0
    ///用最高价与最低价与昨收算出来的最小值
    fileprivate var minPrice : Double = 0
    ///昨收价
    fileprivate var closePrice : Double?
    ///画图的范围
    fileprivate var priceLineRect : CGRect
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override init(frame: CGRect) {
        self.priceLineRect = frame
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    ///分时图赋值
    func setupData(priceLineArr : [CGPoint],avgPriceLineArr:[CGPoint],maxPrice:Double,minPrice:Double,closePrice:Double?){
        self.priceLineArr = priceLineArr
        self.avgPriceLineArr = avgPriceLineArr
        self.maxPrice = maxPrice
        self.minPrice = minPrice
        self.closePrice = closePrice
        self.setNeedsDisplay()
    }
    
    func reset(){
        ///缓存时分线
        priceLineArr = []
        ///缓存均价线
        avgPriceLineArr = []
        ///用最高价与最低价与昨收算出来的最大值
        maxPrice = 0
        ///用最高价与最低价与昨收算出来的最小值
        minPrice = 0
        ///昨收价
        closePrice = nil
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        ///画分时线与均价线
        func drawFSLine(){
            
            //均价线
            let avgPricePath : UIBezierPath = UIBezierPath()
            for (index,point) in avgPriceLineArr.enumerated(){
                if index == 0{
                    avgPricePath.move(to: point)
                }else{
                    avgPricePath.addLine(to: point)
                }
            }
            avgPricePath.lineWidth = 1.5
            UIColor.colorWithHexString("#ffa31e").setStroke()
            avgPricePath.stroke()
            
            //画分时线
            let pricePath : UIBezierPath = UIBezierPath()
            for (index,point) in priceLineArr.enumerated(){
                if index == 0{
                    pricePath.move(to: point)
                }else{
                    pricePath.addLine(to: point)
                }
            }
            pricePath.lineWidth = 1.5
            UIColor.black.setStroke()
            pricePath.stroke()
        }
        drawFSLine()
    }
}


extension UIColor {
    
    class func colorWithHexString (_ hex:String,alpha:CGFloat = 1.0) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }
        
        if (cString.lengthOfBytes(using: String.Encoding.utf8) != 6) {
            return UIColor.gray
        }
        
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
}

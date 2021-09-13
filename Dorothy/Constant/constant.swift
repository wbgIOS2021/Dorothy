//
//  constant.swift
//  Dorothy
//
//  Created by Adarsh Raj on 12/07/21.
//

import Foundation
import UIKit
import KRProgressHUD


let SERVICE_CALL:ServiceCall = ServiceCall.sharedInstance

public typealias EIArray = [Any]
public typealias EIDictonary = [String:Any]
public typealias EIDictonaryArray = [[String:Any]]

//Shadow
extension UIView
{
    func dropShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 3)
        layer.masksToBounds = false
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 3
        layer.rasterizationScale = UIScreen.main.scale
        layer.shouldRasterize = true
        layer.cornerRadius = 20
    }
    func addTopShadow(shadowColor : UIColor, shadowOpacity : Float,shadowRadius : Float,offset:CGSize){
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = CGFloat(shadowRadius)
        clipsToBounds = false
    }
    func roundShadow()
    {
        //configure the container
            clipsToBounds = false
            layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.5
            layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
            layer.shadowRadius = 5
//            layer.shadowPath = UIBezierPath(roundedRect: layer.bounds, cornerRadius: cornerRadius).cgPath

    }
}

//MARK:- Button Curve Here
extension UIButton {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        if #available(iOS 11, *) {
            var cornerMask = CACornerMask()
            if(corners.contains(.topLeft)){
                cornerMask.insert(.layerMinXMinYCorner)
            }
            if(corners.contains(.topRight)){
                cornerMask.insert(.layerMaxXMinYCorner)
            }
            if(corners.contains(.bottomLeft)){
                cornerMask.insert(.layerMinXMaxYCorner)
            }
            if(corners.contains(.bottomRight)){
                cornerMask.insert(.layerMaxXMaxYCorner)
            }
            self.layer.cornerRadius = radius
            self.layer.maskedCorners = cornerMask

        } else {
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }
}


//MARK:- For Indicator
class ProgressHud {
  
    static func show() {
        DispatchQueue.main.async {
            KRProgressHUD.show()
        }
    }
    
    static func hide() {
        DispatchQueue.main.async {
            KRProgressHUD.dismiss()
        }
    }
 
}

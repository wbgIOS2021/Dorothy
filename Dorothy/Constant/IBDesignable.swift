

import Foundation
import UIKit

@IBDesignable class ViewDesign: UIView {
    
    @IBInspectable var borderWid : CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = self.borderWid
        }
    }
    
    @IBInspectable var borderColor : UIColor = .clear {
        didSet {
            self.layer.borderColor = self.borderColor.cgColor
        }
    }
    
    @IBInspectable var shodow : CGFloat = 0 {
        didSet {
            self.layer.shadowColor = UIColor.lightGray.cgColor
            self.layer.shadowOffset = CGSize(width: 3, height: 3)
            self.layer.masksToBounds = false
            self.layer.shadowOpacity = 0.5
            self.layer.shadowRadius = 4
            self.layer.rasterizationScale = UIScreen.main.scale
            self.layer.shouldRasterize = true
            self.layer.cornerRadius = 20
            
        }
    }
    
}

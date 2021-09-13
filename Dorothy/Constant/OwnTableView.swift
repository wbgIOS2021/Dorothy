//
//  OwnTableView.swift
//  Dorothy
//
//  Created by Adarsh Raj on 14/07/21.
//

import Foundation
import UIKit

class OwnTableView: UITableView {
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return self.contentSize
    }
    
    override var contentSize: CGSize {
        didSet{
            self.invalidateIntrinsicContentSize()
        }
    }
}

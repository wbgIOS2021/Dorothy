//
//  AllCategoryTableViewCell.swift
//  Dorothy
//
//  Created by Adarsh Raj on 15/07/21.
//

import UIKit

class AllCategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var categoryViewButton: UIButton!
    @IBOutlet weak var categoryRoundView:UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.categoryRoundView.layer.cornerRadius = self.categoryRoundView.frame.size.width / 2
        self.categoryRoundView.clipsToBounds = true
        categoryView.dropShadow()
        categoryRoundView.roundShadow()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}

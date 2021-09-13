//
//  SmallCategoriesCollectionViewCell.swift
//  Dorothy
//
//  Created by Adarsh Raj on 15/07/21.
//

import UIKit

class SmallCategoriesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var imageView: UIView!
    @IBOutlet weak var categoryName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.categoryImage.layer.cornerRadius = 18
        self.imageView.layer.cornerRadius = 22.5
        
        self.categoryView.layer.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.categoryView.layer.cornerRadius = 27
    }

}

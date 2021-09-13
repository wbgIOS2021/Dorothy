//
//  HomeCategoryListCollectionViewCell.swift
//  Dorothy
//
//  Created by Adarsh Raj on 02/09/21.
//

import UIKit

class HomeCategoryListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var productView: UIView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var viewProductBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        productView.dropShadow()
        viewProductBtn.layer.cornerRadius = 15

        // Initialization code
    }

}

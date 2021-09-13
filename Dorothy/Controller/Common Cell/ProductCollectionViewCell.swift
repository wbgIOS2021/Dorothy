//
//  ProductCollectionViewCell.swift
//  Dorothy
//
//  Created by Adarsh Raj on 02/09/21.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {

    
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productWeight: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var addToCartBtn: UIButton!
    @IBOutlet weak var productView: UIView!
    @IBOutlet weak var specialPrice: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        productView.dropShadow()
        self.productImage.layer.cornerRadius = self.productImage.frame.size.width / 2
        self.productImage.clipsToBounds = true
        // Initialization code
    }

}

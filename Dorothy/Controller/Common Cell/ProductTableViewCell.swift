//
//  ProductTableViewCell.swift
//  Dorothy
//
//  Created by Adarsh Raj on 02/09/21.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productweight: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var addToCartBtn: UIButton!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var specialPrice: UILabel!
    @IBOutlet weak var productView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.productImage.layer.cornerRadius = self.productImage.frame.size.width / 2
        self.productImage.clipsToBounds = true
        //productView.dropShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

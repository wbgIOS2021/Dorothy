//
//  CartTableViewCell.swift
//  Dorothy
//
//  Created by Adarsh Raj on 02/09/21.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productModal: UILabel!
    @IBOutlet weak var specialPrice: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var productQuantity: UILabel!
    @IBOutlet weak var decreaseButton: UIButton!
    @IBOutlet weak var increaseButton: UIButton!
    @IBOutlet weak var productView: UIView!
    @IBOutlet weak var qtyView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        productView.dropShadow()
        qtyView.dropShadow()
        productQuantity.layer.cornerRadius = productQuantity.frame.size.width / 2
        productQuantity.clipsToBounds = true
        
        productImage.layer.cornerRadius = productImage.frame.size.width / 2
        productImage.clipsToBounds = true

    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

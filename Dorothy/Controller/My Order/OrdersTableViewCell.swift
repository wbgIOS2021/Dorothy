//
//  OrdersTableViewCell.swift
//  Dorothy
//
//  Created by Adarsh Raj on 31/08/21.
//

import UIKit

class OrdersTableViewCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productQty: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.productImage.layer.cornerRadius = self.productImage.frame.size.width / 2
        self.productImage.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func prepareForReuse() {
            super.prepareForReuse()

        }
}

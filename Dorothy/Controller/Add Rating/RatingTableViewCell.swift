//
//  RatingTableViewCell.swift
//  Dorothy
//
//  Created by Adarsh Raj on 24/08/21.
//

import UIKit
import Cosmos

class RatingTableViewCell: UITableViewCell {
    @IBOutlet weak var rating: CosmosView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var reviewText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        rating.isUserInteractionEnabled = false

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}

//
//  RatingReviewCollectionViewCell.swift
//  Dorothy
//
//  Created by Adarsh Raj on 17/07/21.
//

import UIKit
import Cosmos

class RatingReviewCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var personName: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var rating: CosmosView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        rating.settings.fillMode = .precise
        rating.isUserInteractionEnabled = false
    }

}

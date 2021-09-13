//
//  MyProfileMenuListTableViewCell.swift
//  Dorothy
//
//  Created by Adarsh Raj on 30/07/21.
//

import UIKit

class MyProfileMenuListTableViewCell: UITableViewCell {

    @IBOutlet weak var menuTitle: UILabel!
    @IBOutlet weak var menuSubTitle: UILabel!
    @IBOutlet weak var viewBtn: UIButton!
    @IBOutlet weak var menuView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

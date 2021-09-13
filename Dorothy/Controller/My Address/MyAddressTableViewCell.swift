//
//  MyAddressTableViewCell.swift
//  Dorothy
//
//  Created by Adarsh Raj on 02/09/21.
//

import UIKit

class MyAddressTableViewCell: UITableViewCell {
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var fullAddressLabel: UILabel!
    @IBOutlet weak var statePincodeLabel: UILabel!
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var isDefaultLabel: UILabel!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var editAddressBtn: UIButton!
    @IBOutlet weak var deleteAddressbtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.editAddressBtn.layer.cornerRadius = self.editAddressBtn.frame.size.width / 2
        self.editAddressBtn.clipsToBounds = true
        
        self.deleteAddressbtn.layer.cornerRadius = self.deleteAddressbtn.frame.size.width / 2
        self.deleteAddressbtn.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

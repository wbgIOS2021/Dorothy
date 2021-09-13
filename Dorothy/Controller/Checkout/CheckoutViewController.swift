//
//  CheckoutViewController.swift
//  Dorothy
//
//  Created by Adarsh Raj on 16/07/21.
//

import UIKit
import SideMenuSwift
import MaterialComponents.MaterialTextControls_OutlinedTextFields

class CheckoutViewController: UIViewController {

    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var addAddressBtn: UIButton!
    @IBOutlet weak var userAddressView: UIStackView!
    
    @IBOutlet weak var onlinePaymentView: UIView!
    
    @IBOutlet weak var cashOnDeliveryView: UIView!
    
    @IBOutlet weak var billingView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var onlinePaymentBtn: UIButton!
    @IBOutlet weak var cashOnDeliveryBtn: UIButton!
    
    @IBOutlet weak var addressName: UILabel!
    @IBOutlet weak var billingAddress: UILabel!
    
    @IBOutlet weak var cartQty: UILabel!
    @IBOutlet weak var originalPrice: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var shippingCharge: UILabel!
    @IBOutlet weak var finalAmount: UILabel!
    
    
    var paymentMethod = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addressView.dropShadow()
        onlinePaymentView.dropShadow()
        billingView.dropShadow()
        
        bottomView.layer.cornerRadius = 30
        bottomView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        cashOnDeliveryView.dropShadow()
        addAddressBtn.layer.cornerRadius = 20
        //couponTF.leadingViewMode = .always
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
            
    }



    
    @IBAction func onlinePaymentButtonAction(_ sender: Any) {
            paymentMethod = 1
            onlinePaymentBtn.setImage(UIImage(named: "red_small_ball"), for: .normal)
            cashOnDeliveryBtn.setImage(nil, for: .normal)
    }
    
    @IBAction func cashOnDeliveryBtnAction(_ sender: Any) {
            paymentMethod = 0
            cashOnDeliveryBtn.setImage(UIImage(named: "red_small_ball"), for: .normal)
            onlinePaymentBtn.setImage(nil, for: .normal)
    }
    
    @IBAction func addOrChangeAddress(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MyAddressTableViewController") as! MyAddressTableViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func proceedBtn(_ sender: Any) {
    }
    
}

//MARK:- Navigation Action Buttons
extension CheckoutViewController
{
    @IBAction func backBtn(_ sender: Any) {
        backBtn()
    }
}



//
//  NoInternetViewController.swift
//  Dorothy
//
//  Created by Adarsh Raj on 29/09/21.
//

import UIKit

class NoInternetViewController: UIViewController {

    @IBOutlet weak var retryBtn:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func retryBtnAction(_ sender: Any) {
        if NetworkListner.shared.isNetAvailable {
            self.backBtn()
        }else{
            self.showToast(message: "Internet Connection not Available!", seconds: 1.5)
        }
    }

}

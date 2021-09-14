//
//  LoginViewController.swift
//  Dorothy
//
//  Created by Adarsh Raj on 29/07/21.
//

import UIKit
import MaterialComponents.MaterialTextControls_OutlinedTextFields

class LoginViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var phoneTextField: MDCOutlinedTextField!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var passwordTextField: MDCOutlinedTextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var loginScrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldDesign()
        setGradientBackground(view: backView)
        loginBtn.layer.cornerRadius = 30
        loginScrollView.delegate = self
    }
 
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    func textFieldDesign()
    {
        phoneTextField.label.text = "Enter Mobile Number"
        phoneTextField.containerRadius = 30.0
        phoneTextField.leadingEdgePaddingOverride = 100.0
        
        passwordTextField.label.text = "Enter Password"
        passwordTextField.containerRadius = 30.0
        passwordTextField.leadingEdgePaddingOverride = 20.0
        passwordTextField.leadingView = UIImageView(image: UIImage(named: "lock"))
        passwordTextField.leadingViewMode = .always
        
        loginView.layer.cornerRadius = 60
        loginView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.height {
            scrollView.contentOffset.y = scrollView.contentSize.height - scrollView.bounds.height
        }
    }
    
    @IBAction func forgotPasswordBtn(_ sender: Any) {
    }
}
extension LoginViewController
{
    @IBAction func loginBtn(_ sender: UIButton) {
        let mobile = validateNumber(phoneTextField!.text!)

        if phoneTextField!.text! == ""
        {
            Alert.showError(title: "Error", message: "Please enter mobile number", vc: self)
        }
        else if mobile == false || phoneTextField!.text!.count != 10
        {
            Alert.showError(title: "Error", message: "Invalid mobile number", vc: self)
        }
        if passwordTextField!.text! == ""
        {
            Alert.showError(title: "Error", message: "Please enter password", vc: self)
        }
        else{
            print("login call")
        }
    }
    
    @IBAction func signupBtn(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SendOtpViewController") as! SendOtpViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
       homePage()
    }

}


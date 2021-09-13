//
//  RegistrationViewController.swift
//  Dorothy
//
//  Created by Adarsh Raj on 29/07/21.
//

import UIKit
import MaterialComponents.MaterialTextControls_OutlinedTextFields

class RegistrationViewController: UIViewController {

    @IBOutlet var firstNameField: MDCOutlinedTextField!
    @IBOutlet var lastNameField: MDCOutlinedTextField!
    @IBOutlet var mobileNumberField: MDCOutlinedTextField!
    @IBOutlet var emailField: MDCOutlinedTextField!
    @IBOutlet var passwordField: MDCOutlinedTextField!
    @IBOutlet var confirmPasswordField: MDCOutlinedTextField!
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var backView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground(view: backView)
        textFieldDesign()
        signupBtn.layer.cornerRadius = 30
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    func textFieldDesign()
    {
        textFieldConfig(textField:firstNameField, label_name:"First Name", icon: "user_icon")
        textFieldConfig(textField:lastNameField, label_name:"Last Name", icon: "user_icon")
        textFieldConfig(textField:mobileNumberField, label_name:"Mobile Number", icon: "phone")
        textFieldConfig(textField:emailField, label_name:"Email Address", icon: "at")
        textFieldConfig(textField:passwordField, label_name:"Password", icon: "lock")
        textFieldConfig(textField:confirmPasswordField, label_name:"Confirm Password", icon: "lock")
    }
    func textFieldConfig(textField:MDCOutlinedTextField, label_name:String,icon:String)
    {
        textField.containerRadius = 30.0
        textField.leadingEdgePaddingOverride = 20.0
        textField.label.text = label_name
        textField.leadingView = UIImageView(image: UIImage(named: icon))
        textField.leadingViewMode = .always
        
    }
}

extension RegistrationViewController
{
    @IBAction func loginBtn(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func signupBtn(_ sender: UIButton) {
        let email = validateEmailID(emailID: emailField!.text!)
        let mobile = validateNumber(mobileNumberField!.text!)
        
        if firstNameField!.text! == ""
        {
            Alert.showError(title: "Error", message: "Please enter first Name", vc: self)
        }
        else if lastNameField!.text! == ""
        {
            Alert.showError(title: "Error", message: "Please enter last Name", vc: self)
        }
        else if mobileNumberField!.text! == ""
        {
            Alert.showError(title: "Error", message: "Please enter mobile number", vc: self)
        }
        else if mobile == false || mobileNumberField!.text!.count != 10
        {
            Alert.showError(title: "Error", message: "Invalid mobile number", vc: self)
        }
        else if emailField!.text! == ""
        {
            Alert.showError(title: "Error", message: "Please enter email", vc: self)
        }
        else if email == false
        {
            Alert.showError(title: "Error", message: "Invalid email", vc: self)
        }
        else if passwordField!.text! == ""
        {
            Alert.showError(title: "Error", message: "Please enter password", vc: self)
        }
        else if confirmPasswordField!.text! == ""
        {
            Alert.showError(title: "Error", message: "Please enter confirm password", vc: self)
        }
        else if passwordField!.text! != confirmPasswordField!.text!
        {
            Alert.showError(title: "Error", message: "Password and Confirm Password Not Match!!!!", vc: self)
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerifyOtpViewController") as! VerifyOtpViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}


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
    @IBOutlet weak var passwordEyeBtn: UIButton!
    @IBOutlet weak var confirmPasswordEyeBtn: UIButton!
    var passwordEyeBtnClick = true
    var confirmPasswordEyeBtnClick = true
    var mobile:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground(view: backView)
        textFieldDesign()
        signupBtn.layer.cornerRadius = 30
        mobileNumberField.text! = mobile
        mobileNumberField.isUserInteractionEnabled = false
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
    @IBAction func passwordEyeBtnAction(_ sender: Any) {
        if(passwordEyeBtnClick == true) {
            passwordField.isSecureTextEntry = false
            passwordEyeBtn.setBackgroundImage(UIImage(named: "eye"), for: UIControl.State.normal)

                } else {
                    passwordField.isSecureTextEntry = true
                    passwordEyeBtn.setBackgroundImage(UIImage(named: "eye_hide"), for: UIControl.State.normal)
                }

        passwordEyeBtnClick = !passwordEyeBtnClick
    }
    @IBAction func confirmPasswordEyeBtnAction(_ sender: Any) {
        if(confirmPasswordEyeBtnClick == true) {
            confirmPasswordField.isSecureTextEntry = false
            confirmPasswordEyeBtn.setBackgroundImage(UIImage(named: "eye"), for: UIControl.State.normal)

                } else {
                    confirmPasswordField.isSecureTextEntry = true
                    confirmPasswordEyeBtn.setBackgroundImage(UIImage(named: "eye_hide"), for: UIControl.State.normal)
                }

        confirmPasswordEyeBtnClick = !confirmPasswordEyeBtnClick
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
            registerAPi()
        }
    }
    
}

//MARK:- Registration API Calling
extension RegistrationViewController
{
    func registerAPi() -> Void {
    ProgressHud.show()

    let success:successHandler = {  response in
        ProgressHud.hide()
        let json = response as! [String : Any]
        if json["responseCode"] as! Int == 1
        {
            let responseData = json["responseData"] as! [String: Any]
            
            saveStringOnLocal(key: "user_id", value: responseData["id"] as! String)
            let name = "\(self.firstNameField!.text!) " + " \(self.lastNameField!.text!)"
            saveStringOnLocal(key: "name", value: name)
            
            self.homePage()
            DispatchQueue.main.async {
                self.showToast(message: json["responseText"] as! String, seconds: 2.0)
            }
        }else{
            let mess = json["responseText"] as! String
            Alert.showError(title: "Error", message: mess, vc: self)
        }

    }
        
    let failure:failureHandler = { [weak self] error, errorMessage in
        ProgressHud.hide()
        DispatchQueue.main.async {
            Alert.showError(title: "Error", message: errorMessage, vc: self!)
        }
    }
        
    //Calling API
        
        let parameters:EIDictonary = ["firstname": firstNameField.text!,"lastname":lastNameField!.text!,"email": emailField.text!,"telephone": mobileNumberField!.text!,"password":passwordField.text!,"newsletter":"1"]
    
    SERVICE_CALL.sendRequest(parameters: parameters, httpMethod: "POST", methodType: RequestedUrlType.user_register, successCall: success, failureCall: failure)
    }
}




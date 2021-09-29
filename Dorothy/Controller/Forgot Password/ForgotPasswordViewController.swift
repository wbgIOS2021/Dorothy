//
//  ForgotPasswordViewController.swift
//  Dorothy
//
//  Created by Adarsh Raj on 16/09/21.
//

import UIKit
import MaterialComponents.MaterialTextControls_OutlinedTextFields

class ForgotPasswordViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var sectionView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var emailTextField: MDCOutlinedTextField!
    @IBOutlet weak var forgotScrollView: UIScrollView!
    @IBOutlet weak var submitBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDesign()
        setGradientBackground(view: backView)
        
    }
    func setUpDesign()
    {
        emailTextField.label.text = "Enter Email Address"
        emailTextField.containerRadius = 30.0
        emailTextField.leadingEdgePaddingOverride = 35.0
        emailTextField.leadingView = UIImageView(image: UIImage(named: "at"))
        emailTextField.leadingViewMode = .always
        
        sectionView.layer.cornerRadius = 60
        sectionView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        forgotScrollView.delegate = self
        submitBtn.layer.cornerRadius = 30
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        
    }

    @IBAction func backBtn(_ sender: UIButton) {
       backBtn()
    }
    @IBAction func submitBtn(_ sender: Any) {
        let email = validateEmailID(emailID: emailTextField!.text!)
        
        if emailTextField.text! == ""
        {
            Alert.showError(title: "Error", message: "Email address is required", vc: self)
        }else if email == false
        {
            Alert.showError(title: "Error", message: "Invalid email address", vc: self)
        }else{
            forgotPasswordAPi()
        }
    }
}

//MARK:- API Calling
extension ForgotPasswordViewController
{
    func forgotPasswordAPi() -> Void {
    ProgressHud.show()

    let success:successHandler = {  response in
        ProgressHud.hide()
        let json = response as! [String : Any]
        if json["responseCode"] as! Int == 1
        {
            showAlertWithOK(title: "Reset Password", message: json["responseText"] as! String,view : self,actionHandler:{
                self.backBtn()
            })
            
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
    let parameters:EIDictonary = ["email": emailTextField.text!]
    
    SERVICE_CALL.sendRequest(parameters: parameters, httpMethod: "POST", methodType: RequestedUrlType.forgot_password, successCall: success, failureCall: failure)
    }
}


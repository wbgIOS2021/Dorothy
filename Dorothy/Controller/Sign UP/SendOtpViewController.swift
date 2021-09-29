//
//  SendOtpViewController.swift
//  Dorothy
//
//  Created by Adarsh Raj on 30/07/21.
//

import UIKit
import MaterialComponents.MaterialTextControls_OutlinedTextFields

class SendOtpViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var sectionView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var countryCodeBtn: UIButton!
    @IBOutlet weak var mobileTextField: MDCOutlinedTextField!
    @IBOutlet weak var sendOtpScrollView: UIScrollView!
    @IBOutlet weak var sendOtpBtn: UIButton!
    var country_code:String = "+91"
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldDesign()
        setGradientBackground(view: backView)
        sectionView.layer.cornerRadius = 60
        sectionView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        sendOtpScrollView.delegate = self
        sendOtpBtn.layer.cornerRadius = 30
    }
    func textFieldDesign()
    {
        mobileTextField.label.text = "Enter Mobile Number"
        mobileTextField.containerRadius = 30.0
        mobileTextField.leadingEdgePaddingOverride = 100.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        
    }
    
    @IBAction func countryCodeBtnAction(_ sender: UIButton) {
        country_code = sender.titleLabel!.text!
    }
    @IBAction func sendOtpBtnAction(_ sender: Any) {
        let mobile = validateNumber(mobileTextField.text!)
        
        if mobileTextField.text! == ""
        {
            Alert.showError(title: "Error", message: "Enter mobile number", vc: self)
        }else if mobile == false || mobileTextField.text?.count != 10
        {
            Alert.showError(title: "Error", message: "Invalid mobile", vc: self)
        }else{
            sendOTPAPi()
        }
        }

    
    @IBAction func loginBtn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK:- API Calling
extension SendOtpViewController
{
    func sendOTPAPi() -> Void {
    ProgressHud.show()

    let success:successHandler = {  response in
        ProgressHud.hide()
        let json = response as! [String : Any]
        if json["responseCode"] as! Int == 1
        {
            if json["isRegistered"] as! Int == 1
            {
                self.goToLogin(title: "Warning", message: "This number is already registered with us.\n Please login using it or Sign up with another number.")
            }else{
                let vC = self.storyboard?.instantiateViewController(withIdentifier: "VerifyOtpViewController") as! VerifyOtpViewController
                vC.mobile = self.mobileTextField.text!
                vC.country_code = self.country_code
                vC.otp = json["responseData"] as! String
                self.navigationController?.pushViewController(vC, animated: true)
                
                DispatchQueue.main.async {
                    self.showToast(message: json["responseText"] as! String, seconds: 1.0)
                }
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
    let parameters:EIDictonary = ["code": country_code,"mobile_no":mobileTextField.text!]
    
    SERVICE_CALL.sendRequest(parameters: parameters, httpMethod: "POST", methodType: RequestedUrlType.sendOTP, successCall: success, failureCall: failure)
    }
}


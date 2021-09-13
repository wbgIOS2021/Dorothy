//
//  VerifyOtpViewController.swift
//  Dorothy
//
//  Created by Adarsh Raj on 30/07/21.
//

import UIKit

class VerifyOtpViewController: UIViewController {

    @IBOutlet weak var sectionView: UIView!
    @IBOutlet weak var mobileNumberLabel: UILabel!
    @IBOutlet weak var otpTextField1: UITextField!
    @IBOutlet weak var otpTextField2: UITextField!
    @IBOutlet weak var otpTextField3: UITextField!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var otpTextField4: UITextField!
    @IBOutlet weak var verifyBtn: UIButton!
    @IBOutlet weak var otpTextFieldBottomLabel1: UILabel!
    @IBOutlet weak var otpTextFieldBottomLabel3: UILabel!
    @IBOutlet weak var otpTextFieldBottomLabel2: UILabel!
    @IBOutlet weak var otpTextFieldBottomLabel4: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupThings()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    @IBAction func resendCodeBtnAction(_ sender: Any) {
        
    }
    
    @IBAction func verifyOtpBtnAction(_ sender: Any) {
        let otp1 = validateNumber(otpTextField1!.text!)
        let otp2 = validateNumber(otpTextField2!.text!)
        let otp3 = validateNumber(otpTextField3!.text!)
        let otp4 = validateNumber(otpTextField4!.text!)
        if otpTextField1!.text! == "" || otpTextField2!.text! == "" || otpTextField3!.text! == "" || otpTextField4!.text! == "" {
            Alert.showError(title: "Error", message: "Please enter OTP!!!", vc: self)
        }else if otp1 == false || otp2 == false || otp3 == false || otp4 == false
        {
            Alert.showError(title: "Error", message: "Invalid OTP!!!", vc: self)
        }else{
            homePage()
        }
    }
    @IBAction func backBtn(_ sender: UIButton) {
       backBtn()
    }
    @objc func textFieldDidChange(textField: UITextField){

        let text = textField.text

        if (text?.utf16.count)! >= 1{
            switch textField{
            case otpTextField1:
                otpTextField2.becomeFirstResponder()
            case otpTextField2:
                otpTextField3.becomeFirstResponder()
            case otpTextField3:
                otpTextField4.becomeFirstResponder()
            case otpTextField4:
                otpTextField4.resignFirstResponder()
            default:
                break
            }
        }else{

        }
    }
    func setupThings()
    {
        setGradientBackground(view: backView)
        sectionView.layer.cornerRadius = 60
        sectionView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        otpTextFieldBottomLabel1?.layer.cornerRadius = (otpTextFieldBottomLabel1?.frame.size.height)!/2.0
        otpTextFieldBottomLabel1?.layer.masksToBounds = true
        
        otpTextFieldBottomLabel2?.layer.cornerRadius = (otpTextFieldBottomLabel2?.frame.size.height)!/2.0
        otpTextFieldBottomLabel2?.layer.masksToBounds = true
        
        otpTextFieldBottomLabel3?.layer.cornerRadius = (otpTextFieldBottomLabel3?.frame.size.height)!/2.0
        otpTextFieldBottomLabel3?.layer.masksToBounds = true
        
        otpTextFieldBottomLabel4?.layer.cornerRadius = (otpTextFieldBottomLabel4?.frame.size.height)!/2.0
        otpTextFieldBottomLabel4?.layer.masksToBounds = true
        
        verifyBtn.layer.cornerRadius = 30
        otpTextField1.layer.cornerRadius = 10
        otpTextField2.layer.cornerRadius = 10
        otpTextField3.layer.cornerRadius = 10
        otpTextField4.layer.cornerRadius = 10

        
        
        otpTextField1.delegate = self
        otpTextField2.delegate = self
        otpTextField3.delegate = self
        otpTextField4.delegate = self

        otpTextField1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
            otpTextField2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
            otpTextField3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
            otpTextField4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)

    }

}

extension VerifyOtpViewController:UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
}

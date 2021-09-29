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
    
    var mobile:String = ""
    var country_code:String = ""
    var otp:String = ""
    var code:String = ""
    var isLoggedUser = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setupThings()
        mobileLabelDisplay()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        
    }
    @IBAction func resendCodeBtnAction(_ sender: Any) {
        if isLoggedUser == 1{
            resendOTPToChangeMobileAPi()
        }else{
            resendOTPAPi()
        }
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
        }else if isLoggedUser == 1{
            code = "\(otpTextField1.text!)" + "\(otpTextField2.text!)" + "\(otpTextField3.text!)" + "\(otpTextField4.text!)"
            changeMobileVerifyOTPAPI()
        }
        else{
            code = "\(otpTextField1.text!)" + "\(otpTextField2.text!)" + "\(otpTextField3.text!)" + "\(otpTextField4.text!)"
            verifyOTPAPI()
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
    func mobileLabelDisplay()
    {   let mobileNumer = mobile
        let intLetters = mobileNumer.prefix(2)
        let endLetters = mobileNumer.suffix(2)

        let newString = intLetters + "******" + endLetters
        mobileNumberLabel.text! = String(newString)
        self.showToast(message: "Your OTP is \(otp)", seconds: 2.5)
    }
    
}

extension VerifyOtpViewController:UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
}


//MARK:- Verify OTP API Calling
extension VerifyOtpViewController
{
    func verifyOTPAPI() -> Void {
    ProgressHud.show()

    let success:successHandler = {  response in
        ProgressHud.hide()
        let json = response as! [String : Any]
        if json["responseCode"] as! Int == 1
        {
           let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegistrationViewController") as! RegistrationViewController
            vc.mobile = self.mobile
            self.navigationController?.pushViewController(vc, animated: true)
            DispatchQueue.main.async {
                self.showToast(message: json["responseText"] as! String, seconds: 1.5)
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
    let parameters:EIDictonary = ["phone": mobile,"otp":code]

    SERVICE_CALL.sendRequest(parameters: parameters, httpMethod: "POST", methodType: RequestedUrlType.verifyOTP, successCall: success, failureCall: failure)
    }
}

//MARK:- API Calling for Change Mobile Varification
extension VerifyOtpViewController
{
    func changeMobileVerifyOTPAPI() -> Void {
    ProgressHud.show()

    let success:successHandler = {  response in
        ProgressHud.hide()
        let json = response as! [String : Any]
        if json["responseCode"] as! Int == 1
        {
            let vC = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
            self.navigationController?.pushViewController(vC, animated: true)
            DispatchQueue.main.async {
                self.showToast(message: json["responseText"] as! String, seconds: 2.0)
            }
        }else{
            let mess = json["responseText"] as! String
            Alert.showError(title: "Error", message: mess, vc: self)
            print("code--------",self.code)
        }

    }
        
    let failure:failureHandler = { [weak self] error, errorMessage in
        ProgressHud.hide()
        DispatchQueue.main.async {
            Alert.showError(title: "Error", message: errorMessage, vc: self!)
        }
    }
        
    //Calling API
        let parameters:EIDictonary = ["customer_id":getStringValueFromLocal(key: "user_id") ?? "0","phone_no": mobile,"otp":code]
    
    SERVICE_CALL.sendRequest(parameters: parameters, httpMethod: "POST", methodType: RequestedUrlType.change_mobile_otp_verify, successCall: success, failureCall: failure)
    }
}

//MARK:- RESEND OTP API Calling for Change Mobile Varification
extension VerifyOtpViewController
{
    
    func resendOTPToChangeMobileAPi() -> Void {
    ProgressHud.show()

    let success:successHandler = {  response in
        ProgressHud.hide()
        let json = response as! [String : Any]
        if json["responseCode"] as! Int == 1
        {
            //let responseData = json["responseData"] as! [String: Any]
            self.showToast(message: json["responseText"] as! String, seconds: 1.0)
            self.otp = json["responseData"] as! String
            DispatchQueue.main.async
            {
                self.mobileLabelDisplay()
            }

        }else{
            let mess = json["responseText"] as! String
            Alert.showError(title: "Error", message: mess, vc: self)
        }

    }
        
    let failure:failureHandler = { [weak self] error, errorMessage in
        ProgressHud.hide()
        DispatchQueue.main.async {
           // showAlertWith(title: "Error", message: errorMessage, view: self!)
            //self!.showError(title: "Error", message: errorMessage)
            Alert.showError(title: "Error", message: errorMessage, vc: self!)
        }
    }
        
    //Calling API
        let parameters:EIDictonary = ["code": country_code,"customer_id":getStringValueFromLocal(key: "user_id") ?? "0","phone_no":mobile]
    
    SERVICE_CALL.sendRequest(parameters: parameters, httpMethod: "POST", methodType: RequestedUrlType.change_phoneno, successCall: success, failureCall: failure)
    }
}

//MARK:- Resend OTP
extension VerifyOtpViewController
{
    func resendOTPAPi() -> Void {
    ProgressHud.show()

    let success:successHandler = {  response in
        ProgressHud.hide()
        let json = response as! [String : Any]
        if json["responseCode"] as! Int == 1
        {
            self.showToast(message: json["responseText"] as! String, seconds: 1.0)
            self.otp = json["responseData"] as! String
            DispatchQueue.main.async
            {
                self.mobileLabelDisplay()
            }

        }else{
            let mess = json["responseText"] as! String
            Alert.showError(title: "Error", message: mess, vc: self)
        }

    }
        
    let failure:failureHandler = { [weak self] error, errorMessage in
        ProgressHud.hide()
        DispatchQueue.main.async {
           // showAlertWith(title: "Error", message: errorMessage, view: self!)
            //self!.showError(title: "Error", message: errorMessage)
            Alert.showError(title: "Error", message: errorMessage, vc: self!)
        }
    }
        
    //Calling API
    let parameters:EIDictonary = ["code": country_code,"mobile_no":mobile]
    
    SERVICE_CALL.sendRequest(parameters: parameters, httpMethod: "POST", methodType: RequestedUrlType.sendOTP, successCall: success, failureCall: failure)
    }
}


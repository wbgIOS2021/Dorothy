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
        self.showToast(message: "Comming Soon...", seconds: 2.0)
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
            loginAPi()
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


//MARK:- API Calling
extension LoginViewController
{
    func loginAPi() -> Void {
    ProgressHud.show()

    let success:successHandler = {  response in
        ProgressHud.hide()
        let json = response as! [String : Any]
        if json["responseCode"] as! Int == 1
        {

            let responseData = json["responseData"] as! [String: Any]
            saveStringOnLocal(key: "user_id", value: responseData["id"] as! String)
            let name = "\(responseData["firstName"] as! String)"+" \(responseData["lastName"] as! String)"
            saveStringOnLocal(key: "name", value: name)
            saveStringOnLocal(key: "profile_pic", value: responseData["profileImage"] as! String)
            // redirect to home page
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
    let parameters:EIDictonary = ["email": "","phone":phoneTextField!.text!,"password": passwordTextField.text!,"device_type": "A","device_token":"12345"]
    
    SERVICE_CALL.sendRequest(parameters: parameters, httpMethod: "POST", methodType: RequestedUrlType.user_login, successCall: success, failureCall: failure)
    }
}



//
//  ChangePasswordViewController.swift
//  Dorothy
//
//  Created by Adarsh Raj on 16/09/21.
//

import UIKit
import MaterialComponents.MaterialTextControls_OutlinedTextFields

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var oldPasswordTF: MDCOutlinedTextField!
    @IBOutlet weak var chnagePwdScrollView: UIScrollView!
    @IBOutlet weak var newPasswordTF: MDCOutlinedTextField!
    @IBOutlet weak var confirmPasswordTF: MDCOutlinedTextField!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var oldPasswordEyeBtn: UIButton!
    @IBOutlet weak var newPasswordEyeBtn: UIButton!
    @IBOutlet weak var confirmPasswordEyeBtn: UIButton!
    
    var oldPasswordEyeBtnClick = true
    var newPasswordEyeBtnClick = true
    var confirmPasswordEyeBtnClick = true
    var user_id = getStringValueFromLocal(key: "user_id") ?? "0"
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldDesign()
        setGradientBackground(view: backView)
        
        saveBtn.layer.cornerRadius = 30
        saveBtn.clipsToBounds = true
        saveBtn.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    func textFieldDesign()
    {
        textFieldConfig(textField:oldPasswordTF, label_name:"Old Password", icon: "lock")
        textFieldConfig(textField:newPasswordTF, label_name:"New Password", icon: "lock")
        textFieldConfig(textField:confirmPasswordTF, label_name:"Confirm Password", icon: "lock")
    }
    func textFieldConfig(textField:MDCOutlinedTextField, label_name:String,icon:String)
    {
        textField.containerRadius = 30.0
        textField.leadingEdgePaddingOverride = 20.0
        textField.label.text = label_name
        textField.leadingView = UIImageView(image: UIImage(named: icon))
        textField.leadingViewMode = .always
        
    }

    @IBAction func backBtn(_ sender: Any) {
        backBtn()
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        if oldPasswordTF.text! == ""
        {
            Alert.showError(title: "Error", message: "Please enter old password", vc: self)
        }
        else if newPasswordTF!.text! == ""
        {
            Alert.showError(title: "Error", message: "Please enter new password", vc: self)
        }
        else if confirmPasswordTF!.text! == ""
        {
            Alert.showError(title: "Error", message: "Please enter confirm password", vc: self)
        }
        else if oldPasswordTF!.text! == newPasswordTF!.text!
        {
            Alert.showError(title: "Error", message: "Old password and new password shouldn't be same!!!", vc: self)
        }
        else if newPasswordTF!.text! != confirmPasswordTF!.text!
        {
            Alert.showError(title: "Error", message: "New Password and confirm password Not Match!!!!", vc: self)
        }else{
            changePasswordAPi()
        }
    }
    @IBAction func oldPasswordEyeBtnAction(_ sender: Any) {
        if(oldPasswordEyeBtnClick == true) {
            oldPasswordTF.isSecureTextEntry = false
            oldPasswordEyeBtn.setBackgroundImage(UIImage(named: "eye"), for: UIControl.State.normal)

                } else {
                    oldPasswordTF.isSecureTextEntry = true
                    oldPasswordEyeBtn.setBackgroundImage(UIImage(named: "eye_hide"), for: UIControl.State.normal)
                }

        oldPasswordEyeBtnClick = !oldPasswordEyeBtnClick
    }
    @IBAction func newPasswordEyeBtnAction(_ sender: Any) {
        if(newPasswordEyeBtnClick == true) {
            newPasswordTF.isSecureTextEntry = false
            newPasswordEyeBtn.setBackgroundImage(UIImage(named: "eye"), for: UIControl.State.normal)

                } else {
                    newPasswordTF.isSecureTextEntry = true
                    newPasswordEyeBtn.setBackgroundImage(UIImage(named: "eye_hide"), for: UIControl.State.normal)
                }

        newPasswordEyeBtnClick = !newPasswordEyeBtnClick
    }
    @IBAction func confirmPasswordEyeBtnAction(_ sender: Any) {
        if(confirmPasswordEyeBtnClick == true) {
            confirmPasswordTF.isSecureTextEntry = false
            confirmPasswordEyeBtn.setBackgroundImage(UIImage(named: "eye"), for: UIControl.State.normal)

                } else {
                    confirmPasswordTF.isSecureTextEntry = true
                    confirmPasswordEyeBtn.setBackgroundImage(UIImage(named: "eye_hide"), for: UIControl.State.normal)
                }
        confirmPasswordEyeBtnClick = !confirmPasswordEyeBtnClick
    }
}


//MARK:- API Calling
extension ChangePasswordViewController
{
    func changePasswordAPi() -> Void {
    ProgressHud.show()

    let success:successHandler = {  response in
        ProgressHud.hide()
        let json = response as! [String : Any]
        if json["responseCode"] as! Int == 1
        {
            self.backBtn()
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
        let parameters:EIDictonary = ["old":self.oldPasswordTF.text!,"new":self.confirmPasswordTF.text!,"customer_id": user_id]
    
    SERVICE_CALL.sendRequest(parameters: parameters, httpMethod: "POST", methodType: RequestedUrlType.change_password, successCall: success, failureCall: failure)
    }
}

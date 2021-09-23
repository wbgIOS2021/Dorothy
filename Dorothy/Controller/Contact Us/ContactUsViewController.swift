//
//  ContactUsViewController.swift
//  Dorothy
//
//  Created by Adarsh Raj on 19/08/21.
//

import UIKit
import MaterialComponents.MaterialTextControls_OutlinedTextFields

class ContactUsViewController: UIViewController {

    @IBOutlet weak var firstNameTF: MDCOutlinedTextField!
    @IBOutlet weak var lastNameTF: MDCOutlinedTextField!
    @IBOutlet weak var mobileNumberTF: MDCOutlinedTextField!
    @IBOutlet weak var emailAddressTF: MDCOutlinedTextField!
    @IBOutlet weak var subjectTF: MDCOutlinedTextField!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet var messageTextArea: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldDesign()
        messageTextArea.layer.borderWidth = 1
        messageTextArea.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        messageTextArea.delegate = self
        messageTextArea.text = "Write message here..."
        messageTextArea.textColor = UIColor.darkGray
        messageTextArea.layer.cornerRadius = 10
        messageTextArea.contentInset = UIEdgeInsets(top: 10, left: 25, bottom: 0, right: 10)
        sendBtn.layer.cornerRadius = 30
        sendBtn.clipsToBounds = true
        sendBtn.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }

    func textFieldDesign()
    {
        textFieldConfig(textField:firstNameTF, label_name:"First Name")
        textFieldConfig(textField:lastNameTF, label_name:"Last Name")
        textFieldConfig(textField:mobileNumberTF, label_name:"Mobile Number")
        textFieldConfig(textField:emailAddressTF, label_name:"Email Address")
        textFieldConfig(textField:subjectTF, label_name:"Subject")    
    }
    func textFieldConfig(textField:MDCOutlinedTextField, label_name:String)
    {
        textField.containerRadius = 30.0
        textField.leadingEdgePaddingOverride = 35.0
        textField.setOutlineColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .normal)
        let attriburedString = NSMutableAttributedString(string: label_name)
        let asterix = NSAttributedString(string: "*", attributes: [.foregroundColor: UIColor.red])
        attriburedString.append(asterix)
        textField.label.attributedText = attriburedString
        if textField == subjectTF{
            textField.label.text = label_name
        }
    }
    @IBAction func backBtn(_ sender: Any) {
        backBtn()
    }
    
    @IBAction func sendBtn(_ sender: Any) {
        let email = validateEmailID(emailID: emailAddressTF!.text!)
        let mobile = validateNumber(mobileNumberTF!.text!)
        
        if firstNameTF!.text! == ""
        {
            Alert.showError(title: "Error", message: "Please enter first Name", vc: self)
        }
        else if lastNameTF!.text! == ""
        {
            Alert.showError(title: "Error", message: "Please enter last Name", vc: self)
        }
        else if mobileNumberTF!.text! == ""
        {
            Alert.showError(title: "Error", message: "Please enter mobile number", vc: self)
        }
        else if mobile == false || mobileNumberTF!.text!.count != 10
        {
            Alert.showError(title: "Error", message: "Invalid mobile number", vc: self)
        }
        else if emailAddressTF!.text! == ""
        {
            Alert.showError(title: "Error", message: "Please enter email", vc: self)
        }
        else if email == false
        {
            Alert.showError(title: "Error", message: "Invalid email", vc: self)
        }
        else{
            contactUsAPI()
        }
    }
}

extension ContactUsViewController: UITextViewDelegate
{
    func textViewDidBeginEditing(_ textView: UITextView) {

        if messageTextArea.textColor == UIColor.darkGray {
            messageTextArea.text = ""
            messageTextArea.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {

        if messageTextArea.text == "" {
            messageTextArea.text = "Write message here..."
            messageTextArea.textColor = UIColor.darkGray
        }
    }
}

//MARK:-  Return API
extension ContactUsViewController
{
    func contactUsAPI() -> Void {
        ProgressHud.show()
        let success:successHandler = {  response in
            ProgressHud.hide()
            let json = response as! [String : Any]
            if json["responseCode"] as! Int == 1
            {
                showAlertWithOK(title: "Success", message: json["responseText"] as! String, view: self, actionHandler: {
                    self.homePage()
                })
                
            }else{
                //self.showToast(message: json["responseText"] as! String, seconds: 1.5)
            }
            
        }
            let failure:failureHandler = { [weak self] error, errorMessage in
                ProgressHud.hide()
                DispatchQueue.main.async {
                    showAlertWith(title: "Error", message: errorMessage, view: self!)
                }
                
            }
            
            //Calling API
        let parameters:EIDictonary = ["first_name":firstNameTF.text!,"last_name":lastNameTF.text!,"email":emailAddressTF.text!,"email_subject":subjectTF.text!,"mobile_no":mobileNumberTF.text!,"enquiry":messageTextArea.text!]
            
            SERVICE_CALL.sendRequest(parameters: parameters, httpMethod: "POST", methodType: RequestedUrlType.contact_us, successCall: success, failureCall: failure)
           
        }
}

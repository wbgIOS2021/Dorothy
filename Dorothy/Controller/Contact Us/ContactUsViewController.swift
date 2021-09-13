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
        if textField == emailAddressTF || textField == subjectTF{
            textField.label.text = label_name
        }
    }
    @IBAction func backBtn(_ sender: Any) {
        backBtn()
    }
    
    @IBAction func sendBtn(_ sender: Any) {
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

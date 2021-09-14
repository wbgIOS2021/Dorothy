//
//  AddAddressViewController.swift
//  Dorothy
//
//  Created by Adarsh Raj on 06/08/21.
//

import UIKit
import MaterialComponents.MaterialTextControls_OutlinedTextFields

class AddAddressViewController: UIViewController {

    
    @IBOutlet weak var firstNameTF: MDCOutlinedTextField!
    @IBOutlet weak var lastNameTF: MDCOutlinedTextField!
    @IBOutlet weak var mobileTF: MDCOutlinedTextField!
    @IBOutlet weak var houseNumberTF: MDCOutlinedTextField!
    @IBOutlet weak var landmarkTF: MDCOutlinedTextField!
    @IBOutlet weak var streetAddressTF: MDCOutlinedTextField!
    @IBOutlet weak var stateTF: MDCOutlinedTextField!
    @IBOutlet weak var cityTF: MDCOutlinedTextField!
    @IBOutlet weak var pincodeTF: MDCOutlinedTextField!
    @IBOutlet weak var isDefaultAddress: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var cartBtn:UIBarButtonItem!
    @IBOutlet weak var saveBtn: UIButton!
    var isDefault = 1
    var pickViewValue = 1
    var state_data: [[String:Any]] = [["name":"Utar Pradesh"],["name":"Madhya Pradesh"],["name":"Utrakhand"],["name":"West Bangal"],["name":" Bihar"],["name":"Delhi"],["name":"Punjab"],["name":"Jharkhand"],]
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldDesign()
        pickerView.isHidden = true
        saveBtn.layer.cornerRadius = 30
        saveBtn.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        self.cartCount()
    }
    
    
    func textFieldDesign()
    {
        
        textFieldConfig(textField:firstNameTF, label_name:"First Name")
        textFieldConfig(textField:lastNameTF, label_name:"Last Name")
        textFieldConfig(textField:mobileTF, label_name:"Mobile Number")
        textFieldConfig(textField:mobileTF, label_name:"Phone Number")
        textFieldConfig(textField:houseNumberTF, label_name: "House / apartment")
        textFieldConfig(textField:landmarkTF, label_name:"Landmark (Optional)")
        textFieldConfig(textField:streetAddressTF, label_name:"Street Address")
        textFieldConfig(textField:pincodeTF, label_name:"Pincode")
        textFieldConfig(textField:cityTF, label_name:"City")
        textFieldConfig(textField:stateTF, label_name:"State")
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
        if textField == landmarkTF || textField == houseNumberTF{
            textField.label.text = label_name
        }
    }

}

//MARK:- Action Buttons
extension AddAddressViewController
{
    @IBAction func backBtn(_ sender: Any) {
        backBtn()
    }
//    @IBAction func cartBtn(_ sender: Any) {
//        cartBtn()
//    }
    @IBAction func searchBtn(_ sender: Any) {
        searchBtn()
    }
    @IBAction func isDefaultAddressBtn(_ sender: Any) {
        if isDefault == 0
        {
            isDefault = 1
            isDefaultAddress.setImage(UIImage(named: "red_small_ball"), for: .normal)
        }else{
            isDefault = 0
            isDefaultAddress.setImage(nil, for: .normal)
        }
    }
    @IBAction func saveBtn(_ sender: Any) {
        if firstNameTF.text! == ""
        {
            showAlertWith(title: "Error", message: "First name is required", view: self)
        }else if lastNameTF.text! == ""
        {
            showAlertWith(title: "Error", message: "Last name is required", view: self)

        }else if mobileTF.text! == ""
        {
            showAlertWith(title: "Error", message: "Phone Number is required", view: self)

        }

        else if streetAddressTF.text! == ""
        {
            showAlertWith(title: "Error", message: "Street Address  is required", view: self)

        }else if stateTF.text! == ""
        {
            showAlertWith(title: "Error", message: "Please select State", view: self)

        }else if cityTF.text! == ""
        {
            showAlertWith(title: "Error", message: "City is required", view: self)

        }else if pincodeTF.text! == ""
        {
            showAlertWith(title: "Error", message: "pincode is required", view: self)

        }
    }
 
    
    @IBAction func stateSelectBtn(_ sender: Any) {
        //pickerView.reloadAllComponents()
        pickerView.isHidden = false

    }
}
//MARK:-  Picker View
extension AddAddressViewController: UIPickerViewDelegate,UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
         return state_data.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return (state_data[row]["name"] as! String)
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
            stateTF.text! = state_data[row]["name"] as! String

        pickerView.isHidden = true

    }
}



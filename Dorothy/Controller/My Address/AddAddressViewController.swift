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
    
    var state_data: [[String:Any]] = []
    var isDefault = 1
    var pickViewValue = 1
    var country_id:String = "99"
    var state_id:String = ""
    var country_data: [[String:Any]] = []
    var user_id = getStringValueFromLocal(key: "user_id") ?? "0"
    var userdata:[String:Any] = [:]
    var addressId:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldDesign()
        pickerView.isHidden = true
        saveBtn.layer.cornerRadius = 30
        saveBtn.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        settingData()
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
//        textFieldConfig(textField:mobileTF, label_name:"Phone Number")
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
    //Setting Data to textField when Address Update
    func settingData()
    {
        if !userdata.isEmpty{
            firstNameTF.text! = userdata["firstname"] as! String
            lastNameTF.text! = userdata["lastname"] as! String
            mobileTF.text! = userdata["phone"] as! String
            houseNumberTF.text! = userdata["address1"] as! String
            landmarkTF.text! = userdata["address2"] as! String
            streetAddressTF.text! = userdata["strAddress"] as! String
            pincodeTF.text! = userdata["postcode"] as! String
            cityTF.text! = userdata["country"] as! String
            stateTF.text! = userdata["zone"] as! String
            country_id = userdata["countryId"] as! String
            state_id = userdata["zoneId"] as! String
            addressId = userdata["addressId"] as! String
            isDefault = userdata["defaultAddress"] as! Int
            if isDefault == 0{
                isDefaultAddress.setImage(nil, for: .normal)
            }
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

        }else if userdata.isEmpty{
            addAddress()
            self.backBtn()
        }else{
            showToast(message: "under processing", seconds: 1.5)
            self.backBtn()
        }
    }
 
    
    @IBAction func stateSelectBtn(_ sender: Any) {
        self.gettingStates()
        
        pickerView.reloadAllComponents()
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


//MARK:- Getting State data
extension AddAddressViewController
{
    func gettingStates() -> Void {
        ProgressHud.show()
        self.state_data.removeAll()
        let success:successHandler = {  response in
            ProgressHud.hide()
            let json = response as! [String : Any]
            if json["responseCode"] as! Int == 1
            {
//                self.showSuccessToast(text:json["responseText"] as! String)
                let responseData = json["responseData"] as? [[String : Any]]
                for data in responseData!
                    {
                        
                        let id = data["id"] as! String
                        let name = data["name"] as! String
                    let dic:[String : Any] = ["id":id,"name":name]
                    self.state_data.append(dic)
                    }
                DispatchQueue.main.async
                {
                    self.pickerView.reloadAllComponents()
                    self.stateTF.text! = self.state_data[0]["name"] as! String
                    self.state_id = self.state_data[0]["id"] as! String
                }
            }else{
                print("")
            }
            
        }
            let failure:failureHandler = { [weak self] error, errorMessage in
                ProgressHud.hide()
                DispatchQueue.main.async {
                    showAlertWith(title: "Error", message: errorMessage, view: self!)
                }
                
            }
            
            //Calling API
        let parameters:EIDictonary = ["country_id":country_id]
            
            SERVICE_CALL.sendRequest(parameters: parameters, httpMethod: "POST", methodType: RequestedUrlType.stateList, successCall: success, failureCall: failure)
           
        }
}


//MARK:- Add Address
extension AddAddressViewController
{
   
    func addAddress() -> Void {
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
            //ProgressHud.hide()
            self.showToast(message: json["responseText"] as! String, seconds: 2.0)
            
        }
        
    }
        let failure:failureHandler = { [weak self] error, errorMessage in
            ProgressHud.hide()
            DispatchQueue.main.async {
                showAlertWith(title: "Error", message: errorMessage, view: self!)
            }
            
        }
        
        //Calling API
        let parameters:EIDictonary = ["customer_id":user_id,"firstname":firstNameTF.text! ,"lastname":lastNameTF.text!,"company":"","address_1":houseNumberTF.text!,"address_2":landmarkTF.text!,"str_address":streetAddressTF.text!,"city":cityTF.text! ,"phone":mobileTF.text!,"postcode":pincodeTF.text!,"country_id":country_id,"state_id":state_id,"default_address":isDefault]
        
        SERVICE_CALL.sendRequest(parameters: parameters, httpMethod: "POST", methodType: RequestedUrlType.addAddress, successCall: success, failureCall: failure)
       
    }
}


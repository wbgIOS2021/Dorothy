//
//  ReturnOrderViewController.swift
//  Dorothy
//
//  Created by Adarsh Raj on 23/09/21.
//

import UIKit
import MaterialComponents.MaterialTextControls_OutlinedTextFields

class ReturnOrderViewController: UIViewController {

    @IBOutlet weak var returnDescription: UITextView!
    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var noBtn: UIButton!
    @IBOutlet weak var selectReasonTF: MDCOutlinedTextField!
    @IBOutlet weak var backview: UIView!
    @IBOutlet weak var returnOrderScrollView: UIScrollView!
    @IBOutlet weak var reasonView: UIView!
    @IBOutlet weak var transparentView: UIView!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var reasonPickerView: UIPickerView!
    
    var is_opened = 0
    var reason_id:String = ""
    var order_id:String = ""
    var reasons_list: [[String:Any]] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        settingData()
        gettingReasonsLists()
        reasonView.isHidden = true
        transparentView.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        self.cartCount()
    }
    
    func settingData(){
        //setGradientBackground(view: backview)
        returnDescription.layer.borderWidth = 1
        returnDescription.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        returnDescription.delegate = self
        returnDescription.text = "Comment (Optional)"
        returnDescription.textColor = UIColor.darkGray
        returnDescription.layer.cornerRadius = 10
        returnDescription.contentInset = UIEdgeInsets(top: 10, left: 25, bottom: 0, right: 10)
        submitBtn.layer.cornerRadius = 30
        submitBtn.clipsToBounds = true
        submitBtn.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        selectReasonTF.containerRadius = 30.0
        selectReasonTF.leadingEdgePaddingOverride = 35.0
        selectReasonTF.setOutlineColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .normal)
        let attriburedString = NSMutableAttributedString(string: "Select Reason")
        let asterix = NSAttributedString(string: "*", attributes: [.foregroundColor: UIColor.red])
        attriburedString.append(asterix)
        selectReasonTF.label.attributedText = attriburedString
    }
    
}
extension ReturnOrderViewController{
    @IBAction func backBtn(_ sender: Any) {
        self.backBtn()
    }
    
    @IBAction func selectReasonBtn(_ sender: Any) {
        reasonPickerView.reloadAllComponents()
        reasonView.isHidden = false
        transparentView.isHidden = false
    }
    @IBAction func cancelReasonView(_ sender: Any) {
        reasonView.isHidden = true
        transparentView.isHidden = true
    }
    
    
    @IBAction func yesBtnAction(_ sender: Any) {
        is_opened = 1
        yesBtn.setImage(UIImage(named: "red_small_ball"), for: .normal)
        noBtn.setImage(nil, for: .normal)
    }
    @IBAction func noBtnAction(_ sender: Any) {
        is_opened = 0
        noBtn.setImage(UIImage(named: "red_small_ball"), for: .normal)
        yesBtn.setImage(nil, for: .normal)
    }
    @IBAction func submitBtn(_ sender: Any) {
        returnOrder()
    }
}


extension ReturnOrderViewController: UITextViewDelegate
{
    func textViewDidBeginEditing(_ textView: UITextView) {

        if returnDescription.textColor == UIColor.darkGray {
            returnDescription.text = ""
            returnDescription.textColor = UIColor.black
            returnDescription.layer.borderColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {

        if returnDescription.text == "" {
            returnDescription.text = "Comment (Optional)"
            returnDescription.textColor = UIColor.darkGray
        }
    }
}

//MARK:-  Picker View
extension ReturnOrderViewController: UIPickerViewDelegate,UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
         return reasons_list.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return (reasons_list[row]["name"] as! String)
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
            selectReasonTF.text! = reasons_list[row]["name"] as! String
            reason_id = reasons_list[row]["id"] as! String

        reasonView.isHidden = true
        transparentView.isHidden = true

    }
}


//MARK:- Getting Return Reasons List
extension ReturnOrderViewController
{
    func gettingReasonsLists() -> Void {
        ProgressHud.show()
        self.reasons_list.removeAll()
        let success:successHandler = {  response in
            ProgressHud.hide()
            let json = response as! [String : Any]
            if json["responseCode"] as! Int == 1
            {
                let responseData = json["reasonData"] as? [[String : Any]]
                for data in responseData!
                    {
                        
                        let id = data["id"] as! String
                        let name = data["name"] as! String
                    let dic:[String : Any] = ["id":id,"name":name]
                    self.reasons_list.append(dic)
                    }
                DispatchQueue.main.async
                {
                    self.reasonPickerView.reloadAllComponents()
                    self.selectReasonTF.text! = self.reasons_list[0]["name"] as! String
                    self.reason_id = self.reasons_list[0]["id"] as! String
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
        let parameters:EIDictonary = [:]
            
            SERVICE_CALL.sendRequest(parameters: parameters, httpMethod: "POST", methodType: RequestedUrlType.return_reason_list, successCall: success, failureCall: failure)
           
        }
}


//MARK:-  Return API
extension ReturnOrderViewController
{
    func returnOrder() -> Void {
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
        let parameters:EIDictonary = ["order_product_id":order_id,"return_reason":reason_id,"is_opened":is_opened,"other_description":returnDescription.text!]
            
            SERVICE_CALL.sendRequest(parameters: parameters, httpMethod: "POST", methodType: RequestedUrlType.return_order, successCall: success, failureCall: failure)
           
        }
}

//
//  CheckoutViewController.swift
//  Dorothy
//
//  Created by Adarsh Raj on 16/07/21.
//

import UIKit
import SideMenuSwift
import MaterialComponents.MaterialTextControls_OutlinedTextFields

class CheckoutViewController: UIViewController {

    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var addAddressBtn: UIButton!
    @IBOutlet weak var userAddressView: UIStackView!
    
    @IBOutlet weak var onlinePaymentView: UIView!
    
    @IBOutlet weak var cashOnDeliveryView: UIView!
    
    @IBOutlet weak var billingView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var onlinePaymentBtn: UIButton!
    @IBOutlet weak var cashOnDeliveryBtn: UIButton!
    
    @IBOutlet weak var addressName: UILabel!
    @IBOutlet weak var billingAddress: UILabel!
    
    @IBOutlet weak var cartQty: UILabel!
    @IBOutlet weak var originalPrice: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var shippingCharge: UILabel!
    @IBOutlet weak var finalAmount: UILabel!
    @IBOutlet weak var proceed_to_pay_btn: UIButton!
    
    let user_id = (getStringValueFromLocal(key: "user_id") ?? "0")
    var cart_listArray: [[String:Any]] = []
    var responseExtraData_dic:[String:Any] = [:]
    var address_data: [[String:Any]] = []
    
    var addressId:String = ""
    var billing_name:String = ""
    var billing_address:String = ""
    var isComeFromMyAddress:Bool = false
    var cartIds:String = ""
    var shipping_code:String = ""
    var shipping_name:String = ""
    var shipping_rate:String = ""
    var order_description:String = ""
    var address_not_found = 0
    var paymentMethod = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        addressView.dropShadow()
        onlinePaymentView.dropShadow()
        billingView.dropShadow()
        
        bottomView.layer.cornerRadius = 30
        bottomView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        cashOnDeliveryView.dropShadow()
        addAddressBtn.layer.cornerRadius = 20
        //couponTF.leadingViewMode = .always
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        gettingData()
    }
    
    @IBAction func onlinePaymentButtonAction(_ sender: Any) {
            paymentMethod = 1
            onlinePaymentBtn.setImage(UIImage(named: "red_small_ball"), for: .normal)
            cashOnDeliveryBtn.setImage(nil, for: .normal)
            self.proceed_to_pay_btn.setTitle("Proceed to Pay", for: .normal)
    }
    
    @IBAction func cashOnDeliveryBtnAction(_ sender: Any) {
            paymentMethod = 0
            cashOnDeliveryBtn.setImage(UIImage(named: "red_small_ball"), for: .normal)
            onlinePaymentBtn.setImage(nil, for: .normal)
            self.proceed_to_pay_btn.setTitle("Place Order", for: .normal)
    }
    
    @IBAction func addOrChangeAddress(_ sender: Any) {
        if self.address_not_found != 1{
            self.goToMyAddressPage()
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddAddressViewController") as! AddAddressViewController
            self.isComeFromMyAddress = false
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func proceedBtn(_ sender: Any) {
        if self.address_not_found != 1{
            if paymentMethod == 0{
                makeOrderAPI()
               // showAlertWith(title: "Success", message: "Placed Successfully", view: self)
            }else{
            showToast(message: "Online Payment Commin Soon", seconds: 2.0)
            }
        }else{
            showAlertWithCancel(title: "Address required", message: "Address Not Found", view: self, btn_title: "Add Address", actionHandler: {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddAddressViewController") as! AddAddressViewController
                self.isComeFromMyAddress = false
                self.navigationController?.pushViewController(vc, animated: true)
            })
        }
    }
    
    func goToMyAddressPage(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyAddressTableViewController") as! MyAddressTableViewController
        vc.isComeFromCheckout = true
        billing_name = ""
        billing_address = ""
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
}

//MARK:- Navigation Action Buttons
extension CheckoutViewController
{
    @IBAction func backBtn(_ sender: Any) {
        self.backBtn()
    }
}


//MARK:- API Calling
extension CheckoutViewController
{
    func gettingData() -> Void {
    ProgressHud.show()

    let success:successHandler = {  response in

        let json = response as! [String : Any]
       self.cart_listArray.removeAll()
        if json["responseCode"] as! Int == 1
        {
            let responseData = json["responseData"] as? [String : Any]
            let cart = responseData?["cart"] as? [[String : Any]]
            let responseExtraData = responseData?["responseExtraData"] as! [String : Any]
            var cartIdArr:[String] = []
            for data in cart!
                {
                    
                    let cartId = data["cartId"] as! String
                
                    cartIdArr.append(cartId)
                    self.cartIds = cartIdArr.joined(separator:",")
                
                    let productId = data["productId"] as! String
                    let thumb = data["thumb"] as! String
                    let name = data["name"] as! String
                    let model = data["model"] as! String
                
                    let quantity = data["quantity"] as! String
                    let orginalPrice = data["orginalPrice"] as! String
                    let price = data["price"] as! String
                    let total = data["total"] as! String
                    let prdTotal = data["prdTotal"] as! String
                
                    let option = data["option"] as! [[String : Any]]
                    var option_listArray: [[String:Any]] = []
                    for opt in option
                    {
                        let product_option_id = opt["product_option_id"] as! String
                        let product_option_value_id = opt["product_option_value_id"] as! String
                        let option_id = opt["option_id"] as! String
                        
                        let option_value_id = opt["option_value_id"] as! String
                        let name = opt["name"] as! String
                        let value = opt["value"] as! String
                        let type = opt["type"] as! String
                        let quantity = opt["quantity"] as! String
                    
                        let subtract = opt["subtract"] as! String
                        let price = opt["price"] as! String
                        let price_prefix = opt["price_prefix"] as! String
                        let points = opt["points"] as! String
                        
                        let points_prefix = opt["points_prefix"] as! String
                        let weight = opt["weight"] as! String
                        let weight_prefix = opt["weight_prefix"] as! String

                        
                        let dic:[String : Any] = ["product_option_id":product_option_id,"product_option_value_id":product_option_value_id,"option_id":option_id,"option_value_id":option_value_id,"name":name,"value":value,"quantity":quantity,"type":type,"subtract":subtract,"price":price,"price_prefix":price_prefix,"points":points,"points_prefix":points_prefix,"weight":weight,"weight_prefix":weight_prefix,]
                        
                        option_listArray.append(dic)
                    }
                    
                let dic:[String : Any] = ["cartId":cartId,"productId":productId,"thumb":thumb,"name":name,"model":model,"quantity":quantity,"orginalPrice":orginalPrice,"price":price,"total":total,"prdTotal":prdTotal,"option":option_listArray]

                    self.cart_listArray.append(dic)
                }
                
                let orginal_cost_total = responseExtraData["orginal_cost_total"] as! String
                let cart_total = responseExtraData["cart_total"] as! String
                let tax_total = responseExtraData["tax_total"] as! String
                let couponAmount = responseExtraData["coupon_total"] as! String
            
                let shipping_total = responseExtraData["shipping_total"] as! [[String : Any]]
            
                var shipping_total_dictionary: [String:Any] = [:]
                for st in shipping_total
                {
                    let code = st["code"] as! String
                    let title = st["title"] as! String
                    let cost = st["cost"] as! String
                    let taxClassId = st["taxClassId"] as! String
                    let text = st["text"] as! String
                    
                    shipping_total_dictionary = ["code":code,"title":title,"cost":cost,"taxClassId":taxClassId,"text":text]
                    self.shipping_code = code
                    self.shipping_name = title
                    self.shipping_rate = cost
                }
            
            
            self.responseExtraData_dic = ["orginal_cost_total":orginal_cost_total,"cart_total":cart_total,"tax_total":tax_total,"coupon_total":couponAmount,"shipping_total":shipping_total_dictionary]
            
                //Reloading Table Views And Collection View
                DispatchQueue.main.async
                {[self] in
                    ProgressHud.hide()
                    self.originalPrice.text! = "$ \(self.responseExtraData_dic["orginal_cost_total"] as! String)"
                    
                    self.cartQty.text! = "(\(self.cart_listArray.count) Items)"
                    self.taxLabel.text! = "$ \(self.responseExtraData_dic["tax_total"] as! String)"
                    let shippingCost = self.responseExtraData_dic["shipping_total"] as! [String:Any]
                      print("shippingCost",shippingCost)
                    self.shippingCharge.text! = "$ \(shippingCost["cost"] as! String)"
                    self.discountLabel.text! = "$ \( Float(self.responseExtraData_dic["orginal_cost_total"] as! String)! - Float(self.responseExtraData_dic["cart_total"] as! String)!)"
                    let total = (Float(self.responseExtraData_dic["cart_total"] as! String)! + Float(self.responseExtraData_dic["tax_total"] as! String)! + Float(shippingCost["cost"] as! String)!) - Float(self.responseExtraData_dic["coupon_total"] as! String)!
                    self.finalAmount.text! = "$ \(total)"
                    
                    
                    if isComeFromMyAddress == true{
                        addressName.text! = billing_name
                        billingAddress.text! = billing_address
                    }else{
                        self.gettingAddressAPI()
                        print("kkkk")
                    }
                }
        }else{
            ProgressHud.hide()
            print("Comming Soon................................")
        }
    }
        let failure:failureHandler = { [weak self] error, errorMessage in
            ProgressHud.hide()
            DispatchQueue.main.async {
               showAlertWith(title: "Error", message: errorMessage, view: self!)
            }
        }
        
        //Calling API
        let parameters:EIDictonary = ["currency_code": "USD","customer_id": user_id,"coupon_code":""]
        
        SERVICE_CALL.sendRequest(parameters: parameters, httpMethod: "POST", methodType: RequestedUrlType.checkout, successCall: success, failureCall: failure)
    }
}


//MARK:- API Calling
extension CheckoutViewController
{
    func gettingAddressAPI() -> Void {
        ProgressHud.show()

        let success:successHandler = {  response in
            ProgressHud.hide()
            self.address_data.removeAll()
            let json = response as! [String : Any]
            if json["responseCode"] as! Int == 1
            {
                
                let responseData = json["responseData"] as? [[String : Any]]
                for data in responseData!
                    {
                        
                        let addressId = data["addressId"] as! String
                        let firstname = data["firstname"] as! String
                        let lastname = data["lastname"] as! String
                        let company = data["company"] as! String
                        let address1 = data["address1"] as! String
                        let address2 = data["address2"] as! String
                
                        let postcode = data["postcode"] as! String
                        let city = data["city"] as! String
                        let zoneId = data["zoneId"] as! String
                        let zone = data["zone"] as! String
                        let phone = data["phone"] as! String
                        let countryId = data["countryId"] as! String
                        let country = data["country"] as! String
                        let strAddress = data["strAddress"] as! String
                        let defaultAddress = data["defaultAddress"] as! Int
                        
                        let dic:[String : Any] = ["addressId":addressId,"firstname":firstname,"lastname":lastname,"company":company,"address1":address1,"address2":address2,"postcode":postcode,"city":city,"zoneId":zoneId,"zone":zone,"phone":phone,"countryId":countryId,"country":country,"strAddress":strAddress,"defaultAddress":defaultAddress]
                        self.address_data.append(dic)
                }
                    
                DispatchQueue.main.async {[self] in
                    self.userAddressView.isHidden = false
                    self.address_not_found = 0
                    for address in address_data
                    {
                        let default_address = address["defaultAddress"] as! Int
                        if default_address == 1
                        {
                            self.addressId = address["addressId"] as! String
                            let firstname = address["firstname"] as! String
                            let lastname = address["lastname"] as! String
                            let address1 = address["address1"] as! String
                            let address2 = address["address2"] as! String
                    
                            let postcode = address["postcode"] as! String
                            let city = address["city"] as! String
                            let zone = address["zone"] as! String
                            let phone = address["phone"] as! String
                            let strAddress = address["strAddress"] as! String
                            let address_full_name = firstname + " " + lastname
                            let default_addresses = address1 + ", " + address2 + ", " + strAddress  + ", " + city + ", " + zone + " - " + postcode + ", " + phone
                            self.addressName.text! = address_full_name
                            self.billingAddress.text! = default_addresses
                            break
                        }else{
                            self.addressId = address["addressId"] as! String
                            let firstname = address["firstname"] as! String
                            let lastname = address["lastname"] as! String
                            let address1 = address["address1"] as! String
                            let address2 = address["address2"] as! String
                    
                            let postcode = address["postcode"] as! String
                            let city = address["city"] as! String
                            let zone = address["zone"] as! String
                            let phone = address["phone"] as! String
                            let strAddress = address["strAddress"] as! String
                            let address_full_name = firstname + " " + lastname
                            let default_addresses = address1 + ", " + address2 + ", " + strAddress  + ", " + city + ", " + zone + " - " + postcode + ", " + phone
                           
                            self.addressName.text! = address_full_name
                            self.billingAddress.text! = default_addresses
                        }
                    }
                }
            }else{
                print("Comming Soon......ADARSH.......................lj...")
                self.userAddressView.isHidden = true
                self.address_not_found = 1
                self.addAddressBtn.setTitle("Add Address", for: .normal)

            }
                
        }
        
        let failure:failureHandler = { [weak self] error, errorMessage in
            ProgressHud.hide()
            DispatchQueue.main.async {
                showAlertWith(title: "Error", message: errorMessage, view: self!)
            }
        }
        
        //Calling API
        let parameters:EIDictonary = ["customer_id":user_id]
        SERVICE_CALL.sendRequest(parameters: parameters, httpMethod: "POST", methodType: RequestedUrlType.gettingAddress, successCall: success, failureCall: failure)
    }
}

//MARK:- API Calling
extension CheckoutViewController
{
    func makeOrderAPI() -> Void {
        ProgressHud.show()

        let success:successHandler = {  response in
            ProgressHud.hide()
            let json = response as! [String : Any]
            if json["responseCode"] as! Int == 1
            {
                self.showToast(message: json["responseText"] as! String, seconds: 1.5)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    //self.navigationController?.popToRootViewController(animated: true)
                    self.homePage()
                    
                }
            }else{
                self.showToast(message: json["responseText"] as! String, seconds: 1.5)

            }
                
        }
        
        let failure:failureHandler = { [weak self] error, errorMessage in
            ProgressHud.hide()
            DispatchQueue.main.async {
                showAlertWith(title: "Error", message: errorMessage, view: self!)
            }
        }
        
        //Calling API
        let parameters:EIDictonary = ["customer_id":user_id,"cart_id":cartIds,"shipping_code":shipping_code,"shipping_name":shipping_name,"shipping_rate":shipping_rate,"order_description":order_description,"address_id":addressId,"billing_address":addressId,"coupon":getStringValueFromLocal(key: "coupon") ?? "","coupon_amount":"","transaction_id":"","currency_code":"USD"]
        SERVICE_CALL.sendRequest(parameters: parameters, httpMethod: "POST", methodType: RequestedUrlType.makeOrder, successCall: success, failureCall: failure)
    }
}


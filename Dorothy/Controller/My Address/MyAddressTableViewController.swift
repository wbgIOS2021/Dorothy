//
//  MyAddressTableViewController.swift
//  Dorothy
//
//  Created by Adarsh Raj on 02/09/21.
//

import UIKit

class MyAddressTableViewController: UITableViewController {

    @IBOutlet var addressTableView: UITableView!
    @IBOutlet weak var cartBtn: UIBarButtonItem!
    
    var user_id = getStringValueFromLocal(key: "user_id") ?? "0"
    var address_data: [[String:Any]] = []
    var isComeFromCheckout:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        addressTableView.dataSource = self
        cellRegister()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        DispatchQueue.main.async
        {
            self.gettingAddress()
            self.cartCount()
        }
    }
    
    func cellRegister()
    {
        addressTableView.register(UINib(nibName: "MyAddressTableViewCell", bundle: nil), forCellReuseIdentifier: "MyAddressTableViewCell")

    }

    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSection: NSInteger = 1

        if address_data.count > 0 {

            self.addressTableView.backgroundView = nil
              numOfSection = 1


        } else {

            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.addressTableView.bounds.size.width, height: self.addressTableView.bounds.size.height))
            noDataLabel.text = "No Address Found!!"
            noDataLabel.textColor = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
            noDataLabel.textAlignment = NSTextAlignment.center
            self.addressTableView.backgroundView = noDataLabel

        }
        return numOfSection
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return address_data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = addressTableView.dequeueReusableCell(withIdentifier: "MyAddressTableViewCell", for: indexPath) as! MyAddressTableViewCell
        let cellData = address_data[indexPath.row]
        cell.userNameLabel.text! = "\(cellData["firstname"] as! String)" + " " + "\(cellData["lastname"] as! String)"
        cell.mobileLabel.text! = cellData["phone"] as! String
        cell.statePincodeLabel.text! = "\(cellData["zone"] as! String)" + " - " + "\(cellData["postcode"] as! String)"
        
        cell.fullAddressLabel.text! = "\(cellData["address1"] as! String)" + ", " + "\(cellData["address2"] as! String)" + ", " + "\(cellData["strAddress"] as! String)" + "\(cellData["company"] as! String)" + ", " + "\(cellData["city"] as! String)"
        if cellData["defaultAddress"] as! Int == 1
        {
            cell.isDefaultLabel.isHidden = false
        }else{
            cell.isDefaultLabel.isHidden = true
        }
        cell.editAddressBtn.tag = indexPath.row
        cell.editAddressBtn.addTarget(self, action: #selector(self.editAddress), for: .touchUpInside)
        
        cell.deleteAddressbtn.tag = indexPath.row
        cell.deleteAddressbtn.addTarget(self, action: #selector(self.deleteAddress), for: .touchUpInside)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
       UIView.animate(withDuration: 0.8) {
           cell.transform = CGAffineTransform.identity
       }
    cell.alpha = 0
        UIView.animate(withDuration: 0.8) {
            cell.alpha = 1
        }
   }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isComeFromCheckout == true{
            let address = address_data[indexPath.row]
            let addressId = address["addressId"] as! String
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
            let vc = storyboard?.instantiateViewController(withIdentifier: "CheckoutViewController") as! CheckoutViewController
            vc.isComeFromMyAddress = true
            vc.addressId = addressId
            vc.billing_name = "\(address_full_name)"
            vc.billing_address = "\(default_addresses)"
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // Edit Address
    @objc func editAddress(_ sender: UIButton)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddAddressViewController") as! AddAddressViewController
        vc.userdata = address_data[sender.tag]
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    // Delete Address
    @objc func deleteAddress(_ sender:UIButton)
    {
        let address =  address_data[sender.tag]
        deleteAddressAction(addressId:address["addressId"] as! String,index:sender.tag)
       
    }
}

//MARK:- Action Buttons
extension MyAddressTableViewController
{
    @IBAction func backBtn(_ sender: Any) {
        backBtn()
    }
    
    @IBAction func addNewAddressBtn(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddAddressViewController") as! AddAddressViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func searchBtn(_ sender: Any) {
        searchBtn()
    }
}


//MARK:- API Calling
extension MyAddressTableViewController
{
    func gettingAddress() -> Void {
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
                    
                DispatchQueue.main.async
                {[self] in
                    addressTableView.reloadData()
                }
            }else{
                //self.showToast(message: json["responseText"] as! String, seconds: 1.0)
                
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




//MARK:- Delete Address
extension MyAddressTableViewController
{
    func deleteAddressAction(addressId:String,index:Int) -> Void {
        ProgressHud.show()

        let success:successHandler = {  response in
            ProgressHud.hide()
            let json = response as! [String : Any]
            if json["responseCode"] as! Int == 1
            {

                self.showToast(message: json["responseText"] as! String, seconds: 1.5)
                
                DispatchQueue.main.async
                {
                    self.address_data.remove(at: index)
                    self.addressTableView.reloadData()
                    if self.address_data.count > 1{
                        self.gettingAddress()
                    }
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
        let parameters:EIDictonary = ["address_id": addressId,"customer_id":user_id]
            
            SERVICE_CALL.sendRequest(parameters: parameters, httpMethod: "POST", methodType: RequestedUrlType.deleteAddress, successCall: success, failureCall: failure)
           
        }
    }

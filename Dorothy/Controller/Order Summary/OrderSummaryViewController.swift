//
//  OrderSummaryViewController.swift
//  Dorothy
//
//  Created by Adarsh Raj on 31/08/21.
//

import UIKit

class OrderSummaryViewController: UIViewController {
    
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var productsTableView: UITableView!
    @IBOutlet weak var productsTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var billingFullAddress: UILabel!
    @IBOutlet weak var orderMethod: UILabel!
    @IBOutlet weak var orderStatus: UILabel!
    @IBOutlet weak var itemTotal: UILabel!
    @IBOutlet weak var discountOnOriginalPrice: UILabel!
    @IBOutlet weak var packagingCharge: UILabel!
    @IBOutlet weak var totalTax: UILabel!
    @IBOutlet weak var deliveryCost: UILabel!
    @IBOutlet weak var finalAmount: UILabel!
    @IBOutlet weak var orderTotal: UILabel!
    @IBOutlet weak var totalMRP: UILabel!
    @IBOutlet weak var bottomReturnView: UIView!
    @IBOutlet weak var bottomReturnBtnViewHeight: NSLayoutConstraint!
    @IBOutlet weak var cartBtn: UIBarButtonItem!
    @IBOutlet weak var orderDetailsView: UIView!
    
    var orderId:String = ""
    var product_listArray: [[String:Any]] = []
    var orderDetails_Array: [String:Any] = [:]
    var Amount_Array: [[String:Any]] = []
    var history_Array: [[String:Any]] = []
    var shippingAddress_Array: [String:Any] = [:]
    var paymentAddress_Array: [String:Any] = [:]
    var user_id = getStringValueFromLocal(key: "user_id") ?? "0"
    var isCancelled:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cellregister()
        bottomReturnView.layer.cornerRadius = 30
        bottomReturnView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bottomReturnView.isHidden = true
        bottomReturnBtnViewHeight.constant = 0
        orderIdLabel.text = "Order ID: " + orderId
    }
    
    func cellregister()
    {
        //Table view
        productsTableView.register(UINib(nibName: "OrdersTableViewCell", bundle: nil), forCellReuseIdentifier: "OrdersTableViewCell")
    }
    override func viewWillAppear(_ animated: Bool) {
        gettingData()
        self.cartCount()
        navigationController?.navigationBar.isHidden = false
        self.productsTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.productsTableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if let obj = object as? UIScrollView {
            if obj == self.productsTableView && keyPath == "contentSize" {
                if let newvalue = change?[.newKey]{
                    let newsize  = newvalue as! CGSize
                    self.productsTableViewHeight.constant = newsize.height
                }
            }
        }
    }

    
    @IBAction func searchBtn(_ sender: Any) {
        searchBtn()
    }
    @IBAction func backBtn(_ sender: Any) {
        backBtn()
    }
    @IBAction func orderReturnBtn(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ReturnOrderViewController") as! ReturnOrderViewController
        vc.order_id = orderId 
        navigationController?.pushViewController(vc, animated: true)

    }
}

extension OrderSummaryViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  product_listArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = productsTableView.dequeueReusableCell(withIdentifier: "OrdersTableViewCell", for: indexPath) as! OrdersTableViewCell

        let cellData = product_listArray[indexPath.row]
        let st = cellData["productImage"] as! String
        let urlString = st.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        cell.productImage.sd_setImage(with: URL(string: urlString!), placeholderImage: UIImage(named: "bbq"))
        
        let weight = Float(cellData["weight"] as! String)!
        cell.productQty.text! = "Quantity - \(cellData["quantity"] as! String) x " + " \(weight.clean)" + " \(cellData["weight_type"] as! String)"
    
        cell.productName.text! = cellData["name"] as! String
        cell.productPrice.text! = cellData["total"] as! String
        
        return cell
    }

}
//MARK:- Table View Data Source
extension OrderSummaryViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
       UIView.animate(withDuration: 0.8) {
           cell.transform = CGAffineTransform.identity
       }
    cell.alpha = 0
        UIView.animate(withDuration: 0.8) {
            cell.alpha = 1
        }
   }
}

//MARK:- API Calling
extension OrderSummaryViewController
{
    func gettingData() -> Void {
    ProgressHud.show()
    self.product_listArray.removeAll()
    let success:successHandler = {  response in

        let json = response as! [String : Any]
        
        if json["responseCode"] as! Int == 1
        {
            let responseData = json["responseData"] as! [String: Any]
            
            let orderNo = responseData["orderNo"] as! String
            let orderDate = responseData["orderDate"] as! String
            let paymentMethod = responseData["paymentMethod"] as! String
            let shippingMethod = responseData["shippingMethod"] as! String
            let statusId = responseData["statusId"] as! String
            let statusName = responseData["statusName"] as! String
            let taxAmount = responseData["taxAmount"] as! String
            let subTotal = responseData["subTotal"] as! String
            let deliveryCharge = responseData["deliveryCharge"] as! String
            let discountAmount = responseData["discountAmount"] as! String
            let finalTotal = responseData["finalTotal"] as! String
            
            
            let dic:[String : Any] = ["orderNo":orderNo,"orderDate":orderDate,"paymentMethod":paymentMethod,"shippingMethod":shippingMethod,"statusId":statusId,"statusName":statusName,"taxAmount":taxAmount,"subTotal":subTotal,"deliveryCharge":deliveryCharge,"discountAmount":discountAmount,"finalTotal":finalTotal]
            
            self.orderDetails_Array = dic
            
            let products = responseData["product"] as! [[String:Any]] //
            for data in products
            {
                let productOrderId = data["productOrderId"] as! String
                let productId = data["productId"] as! String
                let name = data["name"] as! String
                let details = data["details"] as! String
                let model = data["model"] as! String
                let productImage = data["productImage"] as! String
                
                let quantity = data["quantity"] as! String
                let weight = data["weight"] as! String
                let weight_type = data["weight_type"] as! String
                
                let price = data["price"] as! String
                let total = data["total"] as! String
                
                let isReview = data["isReview"] as! String
                let rating = data["rating"] as! Int
                let prdOption = data["prdOption"] as! [[String:Any]]
                
                var prdOptionArray:[[String:Any]] = []
                for option in prdOption
                {
                    let name = option["name"] as! String
                    let value = option["value"] as! String
                    let type = option["type"] as! String
                    
                    let dic = ["name":name,"value":value,"type":type]
                    prdOptionArray.append(dic)
                }
                let dic:[String : Any] = ["productOrderId":productOrderId,"productId":productId,"name":name,"details":details,"model":model,"productImage":productImage,"quantity":quantity,"weight":weight,"weight_type":weight_type,"price":price,"total":total,"isReview":isReview,"rating":rating,"prdOption":prdOptionArray]
                self.product_listArray.append(dic)
            }
            
            //Amount
            let Amount = responseData["Amount"] as! [[String:Any]]
            for data in Amount
            {
                let title = data["title"] as! String
                let amount = data["amount"] as! String
                let dic = ["title":title,"amount":amount]
                self.Amount_Array.append(dic)
            }
            //Status
            let history = responseData["history"] as! [[String:Any]]
            for data in history
            {
                let status_id = data["status_id"] as! String
                let status_name = data["status_name"] as! String
                let date = data["date"] as! String
                let dic = ["status_id":status_id,"status_name":status_name,"date":date]
                self.history_Array.append(dic)
            }
           
            let shippingAddress = responseData["shippingAddress"] as! [String: Any]
            
            let firstName = shippingAddress["firstName"] as! String
            let lastName = shippingAddress["lastName"] as! String
            let company = shippingAddress["company"] as! String
            let address = shippingAddress["address"] as! String
            let city = shippingAddress["city"] as! String
            
            let postCode = shippingAddress["postCode"] as! String
            let country = shippingAddress["country"] as! String
            let state = shippingAddress["state"] as! String
            let address1 = shippingAddress["address1"] as! String
            let address2 = shippingAddress["address2"] as! String
            let phone = shippingAddress["phone"] as! String
            
            let shippingAdd_dic:[String : Any] = ["firstName":firstName,"lastName":lastName,"company":company,"address":address,"city":city,"postCode":postCode,"country":country,"state":state,"address1":address1,"address2":address2,"phone":phone]
            
            self.shippingAddress_Array = shippingAdd_dic
            
            let paymentAddress = responseData["paymentAddress"] as! [String: Any]
            
            let first_name = paymentAddress["firstName"] as! String
            let last_name = paymentAddress["lastName"] as! String
            let company_name = paymentAddress["company"] as! String
            let street_address = paymentAddress["address"] as! String
            let city_name = paymentAddress["city"] as! String
            
            let post_code = paymentAddress["postCode"] as! String
            let country_name = paymentAddress["country"] as! String
            let state_name = paymentAddress["state"] as! String
            let address_1 = paymentAddress["address1"] as! String
            let address_2 = paymentAddress["address2"] as! String
            let phone_no = paymentAddress["phone"] as! String
            
            let paymentAdd_dic:[String : Any] = ["firstName":first_name,"lastName":last_name,"company":company_name,"address":street_address,"city":city_name,"postCode":post_code,"country":country_name,"state":state_name,"address1":address_1,"address2":address_2,"phone":phone_no]
            
            self.paymentAddress_Array = paymentAdd_dic
            

                //Reloading Table Views
                DispatchQueue.main.async
                {
                    self.productsTableView.reloadData()
                    self.ApplyApi()
                    ProgressHud.hide()
                    
                }
        }else{
            print("Comming Soon................................")
            ProgressHud.hide()
        }

        }
        
        let failure:failureHandler = { [weak self] error, errorMessage in
            ProgressHud.hide()
            DispatchQueue.main.async {
                showAlertWith(title: "Error", message: errorMessage, view: self!)
            }
        }
        
        //Calling API
        let parameters:EIDictonary = ["order_no": self.orderId]
        
        SERVICE_CALL.sendRequest(parameters: parameters, httpMethod: "POST", methodType: RequestedUrlType.orderDetails, successCall: success, failureCall: failure)
    }
}

//Applying Api on Page
extension OrderSummaryViewController
{
    func ApplyApi()
    {
        orderIdLabel.text! = "Order ID - \(orderDetails_Array["orderNo"] as! String)"
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMMM dd, yyyy"

        let date: NSDate? = dateFormatterGet.date(from: orderDetails_Array["orderDate"] as! String) as NSDate?
        orderDateLabel.text! = "\(dateFormatterPrint.string(from: date! as Date))"
        
        
        packagingCharge.text! = "$ 0.0"
        
        
        billingFullAddress.text! = "\(shippingAddress_Array["address1"] as! String)" + ", " + "\(shippingAddress_Array["address2"] as! String)" + ", " + "\(shippingAddress_Array["address"] as! String)" + "\(shippingAddress_Array["company"] as! String)" + ", " + "\(shippingAddress_Array["city"] as! String)" + "\(shippingAddress_Array["state"] as! String)" + " - " + "\(shippingAddress_Array["postCode"] as! String)" + " " + "\(shippingAddress_Array["phone"] as! String)"
        
        orderMethod.text! = orderDetails_Array["paymentMethod"] as! String
        
        itemTotal.text! = "\(product_listArray.count) Items"
        
        discountOnOriginalPrice.text! = orderDetails_Array["discountAmount"] as! String
        totalTax.text! = orderDetails_Array["taxAmount"] as! String
        deliveryCost.text! = orderDetails_Array["deliveryCharge"] as! String
        finalAmount.text! = orderDetails_Array["finalTotal"] as! String
        orderTotal.text! = orderDetails_Array["finalTotal"] as! String
        totalMRP.text! = orderDetails_Array["subTotal"] as! String
        
        orderStatus.text! = orderDetails_Array["statusName"] as! String
        if orderDetails_Array["statusId"] as! String == "1"{
            orderStatus.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        }else if orderDetails_Array["statusId"] as! String == "2"{
            orderStatus.textColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        }
        else if orderDetails_Array["statusId"] as! String == "3"{
            orderStatus.textColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
            orderStatus.text! = "On the way"
        }
        else if orderDetails_Array["statusId"] as! String == "5"{
            orderStatus.textColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
            orderStatus.text! = "Delivered"
            bottomReturnView.isHidden = false
            bottomReturnBtnViewHeight.constant = 60
        }
        else if orderDetails_Array["statusId"] as! String == "7"{
            orderStatus.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        }
        else if orderDetails_Array["statusId"] as! String == "11"{
            orderStatus.textColor = #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1)
        }
        else{
            orderStatus.textColor = #colorLiteral(red: 0.422540761, green: 0.422540761, blue: 0.422540761, alpha: 1)
        }
    }
}

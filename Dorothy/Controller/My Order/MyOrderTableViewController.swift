//
//  MyOrderTableViewController.swift
//  Dorothy
//
//  Created by Adarsh Raj on 17/07/21.
//

import UIKit

class MyOrderTableViewController: UITableViewController {

    @IBOutlet var myOrdertableView: OwnTableView!
    @IBOutlet weak var cartBtn: UIBarButtonItem!
    var product_listArray: [[String:Any]] = []
    let user_id = (getStringValueFromLocal(key: "user_id") ?? "0")
    override func viewDidLoad() {
        super.viewDidLoad()
        cellregister()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        gettingData()
        self.cartCount()
    }
    
    //registering cell
    func cellregister()
    {
        //Table view
        myOrdertableView.register(UINib(nibName: "MyOrderTableViewCell", bundle: nil), forCellReuseIdentifier: "MyOrderTableViewCell")
    }
  
}


//MARK:- Navigation Action Button
extension MyOrderTableViewController
{
    
    @IBAction func backBtn(_ sender: Any) {
        backBtn()
    }

    @IBAction func searchBtn(_ sender: Any) {
        searchBtn()
    }
}


// MARK: - Table view data source
extension MyOrderTableViewController
{
    override func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSection: NSInteger = 1

        if product_listArray.count > 0 {
            myOrdertableView.backgroundView = nil
            numOfSection = 1
        } else {

            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.myOrdertableView.bounds.size.width, height: self.myOrdertableView.bounds.size.height))
            noDataLabel.text = "No Order Found!!!"
            noDataLabel.textColor = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
            noDataLabel.textAlignment = NSTextAlignment.center
            self.myOrdertableView.backgroundView = noDataLabel

        }
        return numOfSection
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return product_listArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myOrdertableView.dequeueReusableCell(withIdentifier: "MyOrderTableViewCell", for: indexPath) as! MyOrderTableViewCell
        
        let cellData = product_listArray[indexPath.row]
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd, yyyy"

        let date: NSDate? = dateFormatterGet.date(from: cellData["orderDate"] as! String) as NSDate?
        cell.orderStatusDate.text! = " " + "\(dateFormatterPrint.string(from: date! as Date))"
        cell.orderId.text! = "Order ID: \(cellData["orderNo"] as! String)"
        cell.orderPrice.text! = cellData["orderTotalSymbol"] as! String
        cell.orderStatus.text! = cellData["statusName"] as! String
        
        if cellData["statusId"] as! String == "1"{
            cell.orderStatus.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        }else if cellData["statusId"] as! String == "2"{
            cell.orderStatus.textColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        }
        else if cellData["statusId"] as! String == "3"{
            cell.orderStatus.textColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
            cell.orderStatus.text! = "On the way"
        }
        else if cellData["statusId"] as! String == "5"{
            cell.orderStatus.textColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
            cell.orderStatus.text! = "Delivered"
            
        }
        else if cellData["statusId"] as! String == "7"{
            cell.orderStatus.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            
        }
        else if cellData["statusId"] as! String == "11"{
            cell.orderStatus.textColor = #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1)
        }
        else{
            cell.orderStatus.textColor = #colorLiteral(red: 0.422540761, green: 0.422540761, blue: 0.422540761, alpha: 1)
        }
        cell.data = cellData["items"] as! [[String : Any]]
        cell.order_Id = cellData["orderId"] as! String
        cell.productsTableView.reloadData()

        return cell

    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "OrderSummaryViewController") as! OrderSummaryViewController
        let cellData = product_listArray[indexPath.row]
        vc.orderId = cellData["orderId"] as! String
        navigationController?.pushViewController(vc, animated: true)

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
}


//MARK:- API Calling
extension MyOrderTableViewController
{
    func gettingData() -> Void {
    ProgressHud.show()

    let success:successHandler = {  response in

        let json = response as! [String : Any]
        self.product_listArray.removeAll()
        if json["responseCode"] as! Int == 1
        {
            let responseData = json["responseData"] as? [[String : Any]]
            for data in responseData!
                {
                    
                    let orderId = data["orderId"] as! String
                    let orderNo = data["orderNo"] as! String
                    let orderDate = data["orderDate"] as! String
                    let orderTotal = data["orderTotal"] as! String
                    let orderTotalSymbol = data["orderTotalSymbol"] as! String
                    let totalItems = data["totalItems"] as! String
                    let customerName = data["customerName"] as! String
                    let shippingAddress = data["shippingAddress"] as! String
                    let statusId = data["statusId"] as! String
                    let statusName = data["statusName"] as! String
                    let items = data["prdDataList"] as! [[String:Any]]
                
                    var items_list: [[String:Any]] = []
                    for item in items
                        {
                        
                            let name = item["name"] as! String
                            let model_name = item["model_name"] as! String
                            let weight = item["weight"] as! String
                            let weight_type = item["weight_type"] as! String
                            let reviewCount = item["reviewCount"] as! String
                        
                            let dict:[String : Any] = ["name":name,"model_name":model_name,"weight":weight,"weight_type":weight_type,"reviewCount":reviewCount]
                            items_list.append(dict)
                        }
                
                    let dic:[String : Any] = ["orderId":orderId,"orderNo":orderNo,"orderDate":orderDate,"orderTotal":orderTotal,"orderTotalSymbol":orderTotalSymbol,"totalItems":totalItems,"customerName":customerName,"shippingAddress":shippingAddress,"statusId":statusId,"statusName":statusName,"items":items_list]

                    self.product_listArray.append(dic)
                }
                
                //Reloading Table Views And Collection View
                DispatchQueue.main.async
                {
                    ProgressHud.hide()
                    self.myOrdertableView.reloadData()
                }
        }else{
            ProgressHud.hide()
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
        let parameters:EIDictonary = ["customer": user_id]
        
        SERVICE_CALL.sendRequest(parameters: parameters, httpMethod: "POST", methodType: RequestedUrlType.orderList, successCall: success, failureCall: failure)
    }
}

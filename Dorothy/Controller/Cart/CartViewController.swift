//
//  CartViewController.swift
//  Dorothy
//
//  Created by Adarsh Raj on 02/09/21.
//

import UIKit

class CartViewController: UIViewController {

    @IBOutlet weak var checkoutBtnView: UIView!
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var shadowImage: UIImageView!
    @IBOutlet weak var totalPayLabel: UILabel!
    @IBOutlet weak var totalSaveLabel: UILabel!
    
    var cart_listArray: [[String:Any]] = []
    var responseExtraData_dic:[String:Any] = [:]
    let user_id = (getStringValueFromLocal(key: "user_id") ?? "0")
    override func viewDidLoad() {
        super.viewDidLoad()
        cartTableView.dataSource = self
        cartTableView.delegate = self
        cellRegister()

        checkoutBtnView.layer.cornerRadius = 30
        checkoutBtnView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        shadowImage.addTopShadow(shadowColor: UIColor.white, shadowOpacity: 1.0, shadowRadius: 10, offset: CGSize(width: 0, height: -35))
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        gettingData()
        self.bottomView.isHidden = false
    }
    
    func cellRegister()
    {
        cartTableView.register(UINib(nibName: "CartTableViewCell", bundle: nil), forCellReuseIdentifier: "CartTableViewCell")
    }
    
    @IBAction func checkoutBtn(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "CheckoutViewController") as! CheckoutViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
}


//MARK:- Navigation Button
extension CartViewController
{
    @IBAction func backBtn(_ sender: Any) {
        backBtn()
    }
    @IBAction func searchBtn(_ sender: Any) {
        searchBtn()
    }
}

//MARK:- Table view Data Source
extension CartViewController: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSection: NSInteger = 1

        if cart_listArray.count > 0 {

            self.cartTableView.backgroundView = nil
            self.bottomView.isHidden = false
              numOfSection = 1


        } else {

            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.cartTableView.bounds.size.width, height: self.cartTableView.bounds.size.height))
            noDataLabel.text = "Empty Cart"
            noDataLabel.textColor = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
            noDataLabel.textAlignment = NSTextAlignment.center
            self.cartTableView.backgroundView = noDataLabel
            self.bottomView.isHidden = true

        }
        return numOfSection


}
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cart_listArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = cartTableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as! CartTableViewCell
        
        
        let cellData = cart_listArray[indexPath.row]
        cell.productImage.sd_setImage(with: URL(string: cellData["thumb"] as! String), placeholderImage: UIImage(named: "no-image"))
        cell.productName.text! = cellData["name"] as! String
//        if cellData["price"] as! String == "0.00" || cellData["price"] as! String == "0" || cellData["price"] as! String == cellData["orginalPrice"] as! String{
//            cell.specialPrice!.text! = "$ \(cellData["orginalPrice"] as! String)"
//            cell.price.isHidden = true
//        }else{
//            cell.price.isHidden = true
//            cell.specialPrice!.text! = "$ \(cellData["price"] as! String)"
//        }
        cell.price.isHidden = true
        cell.specialPrice!.text! = "$ \(cellData["price"] as! String)"
        cell.productModal.text! = cellData["model"] as! String
        cell.productQuantity.text! = cellData["quantity"] as! String
        cell.increaseButton.tag = indexPath.row
        cell.increaseButton.addTarget(self, action: #selector(self.cartIncrease), for: .touchUpInside)
        cell.decreaseButton.tag = indexPath.row
        cell.decreaseButton.addTarget(self, action: #selector(self.cartDecrease), for: .touchUpInside)
        if cellData["quantity"] as! String == "1"{
            cell.qtyView.isHidden = true
            cell.addProductButton.isHidden = false
        }else{
            cell.qtyView.isHidden = false
            cell.addProductButton.isHidden = true
        }
        cell.addProductButton.tag = indexPath.row
        cell.addProductButton.addTarget(self, action: #selector(self.addProduct), for: .touchUpInside)
        return cell
    }
    
    @objc func cartIncrease(_ sender:UIButton)
    {

        var qty =  Int(cart_listArray[sender.tag]["quantity"] as! String)!
        if qty < 10
        {
            qty += 1
            self.updateCartAction(cartId:self.cart_listArray[sender.tag]["cartId"] as! String,quantity:qty)
        }
        
    }
    @objc func cartDecrease(_ sender:UIButton)
    {
        var qty =  Int(cart_listArray[sender.tag]["quantity"] as! String)!
        if qty >= 2
        {
            qty -= 1
            updateCartAction(cartId:cart_listArray[sender.tag]["cartId"] as! String,quantity:qty)
        }
    }
    @objc func addProduct(_ sender:UIButton)
    {
        let cell = self.cartTableView.cellForRow(at: NSIndexPath(row: sender.tag, section: 0) as IndexPath) as! CartTableViewCell
        cell.addProductButton.isHidden = true
        cell.qtyView.isHidden = false
    }
}


//MARK:- Table view Delegate
extension CartViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

            let action =  UIContextualAction(style: .normal, title: "", handler: { (action,view,completionHandler ) in
                    //self.product_listArray.removeAll()
                self.removeCartAction(cartId:self.cart_listArray[indexPath.row]["cartId"] as! String)
                let a = Float(self.cart_listArray[indexPath.row]["orginalPrice"] as! String)!
                let b = Float(self.cart_listArray[indexPath.row]["total"] as! String)!
                
                let total = Float(self.responseExtraData_dic["orginal_cost_total"] as! String)!
                let cartTotal = Float(self.responseExtraData_dic["cart_total"] as! String)!
                self.responseExtraData_dic["orginal_cost_total"]  = "\(Float(total) - Float(a))"
                self.responseExtraData_dic["cart_total"] = "\(Float(cartTotal) - Float(b))"
                    self.cart_listArray.remove(at: indexPath.row)
                    self.cartTableView.deleteRows(at: [indexPath], with: .fade)
                    self.cartTableView.reloadData()
                self.totalPayLabel.text! = "$ \( self.responseExtraData_dic["cart_total"] as! String )"
                self.totalSaveLabel.text! = "$ \(Float(total) - Float(cartTotal))"

                completionHandler(true)

            })
            
                action.image = UIGraphicsImageRenderer(size: CGSize(width: 20, height: 20)).image { _ in
                    UIImage(named: "delete_icon")?.draw(in: CGRect(x: 0, y: 0, width: 20, height: 20))
                }
                action.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                let confrigation = UISwipeActionsConfiguration(actions: [action])
                confrigation.performsFirstActionWithFullSwipe = false
                return confrigation
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vC = storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        navigationController?.pushViewController(vC, animated: true)

    }
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
extension CartViewController
{
    func gettingData() -> Void {
    ProgressHud.show()

    let success:successHandler = {  response in

        let json = response as! [String : Any]
       self.cart_listArray.removeAll()
        if json["responseCode"] as! Int == 1
        {
            let responseData = json["responseData"] as? [[String : Any]]
            let responseExtraData = json["responseExtraData"] as! [String : Any]
            
            for data in responseData!
                {
                    
                    let cartId = data["cartId"] as! String
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
                        let name = opt["name"] as! String
                        let value = opt["value"] as! String
                        let type = opt["type"] as! String
                        let dic:[String : Any] = ["name":name,"value":value,"type":type]
                        option_listArray.append(dic)
                    }
                    
                let dic:[String : Any] = ["cartId":cartId,"productId":productId,"thumb":thumb,"name":name,"model":model,"quantity":quantity,"orginalPrice":orginalPrice,"price":price,"total":total,"prdTotal":prdTotal,"option":option_listArray]

                    self.cart_listArray.append(dic)
                }
                
                let orginal_cost_total = responseExtraData["orginal_cost_total"] as! String
                let cart_total = responseExtraData["cart_total"] as! String
                let tax_total = responseExtraData["tax_total"] as! String
                let shipping_total = responseExtraData["shipping_total"] as! [[String : Any]]
            
                var shipping_total_listArray: [[String:Any]] = []
                for st in shipping_total
                {
                    let code = st["code"] as! String
                    let title = st["title"] as! String
                    let cost = st["cost"] as! String
                    let taxClassId = st["taxClassId"] as! String
                    let text = st["text"] as! String
                    
                    let dic:[String : Any] = ["code":code,"title":title,"cost":cost,"taxClassId":taxClassId,"text":text]
                    shipping_total_listArray.append(dic)
                }
            
            
            self.responseExtraData_dic = ["orginal_cost_total":orginal_cost_total,"cart_total":cart_total,"tax_total":tax_total,"shipping_total":shipping_total_listArray]
                //Reloading Table Views And Collection View
                DispatchQueue.main.async
                {
                    ProgressHud.hide()
                    let total = Float(self.responseExtraData_dic["orginal_cost_total"] as! String)
                    let cartTotal = Float(self.responseExtraData_dic["cart_total"] as! String)
                    self.totalPayLabel.text! = "$ \(cartTotal!)"
                    self.totalSaveLabel.text! = "$ \(Float(total!) - Float(cartTotal!))"
                    self.cartTableView.reloadData()
                    
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
        let parameters:EIDictonary = ["currency_code": "USD","customer_id": user_id]
        
        SERVICE_CALL.sendRequest(parameters: parameters, httpMethod: "POST", methodType: RequestedUrlType.cart_list, successCall: success, failureCall: failure)
    }
}

//MARK:- Remove cart
extension CartViewController
{
    //Add or Remove wishlist
    func removeCartAction(cartId:String) -> Void {
    ProgressHud.show()

    let success:successHandler = {  response in
        ProgressHud.hide()
        let json = response as! [String : Any]
        if json["responseCode"] as! Int == 1
        {

            self.showToast(message: json["responseText"] as! String, seconds: 2.0)
            
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
        let parameters:EIDictonary = ["CartId": cartId]
        
        SERVICE_CALL.sendRequest(parameters: parameters, httpMethod: "POST", methodType: RequestedUrlType.removeCart, successCall: success, failureCall: failure)
       
    }
}
//MARK:- Update cart
extension CartViewController
{
    //Update Cart Qty
    func updateCartAction(cartId:String,quantity:Int) -> Void {
    ProgressHud.show()

    let success:successHandler = {  response in
        ProgressHud.hide()
        let json = response as! [String : Any]
        if json["responseCode"] as! Int == 1
        {

            self.showToast(message: json["responseText"] as! String, seconds: 2.0)
            self.gettingData()

        }else{
            //ProgressHud.hide()
            showAlertWith(title: "Error", message: json["responseText"] as! String, view: self)
        }
        
    }
        let failure:failureHandler = { [weak self] error, errorMessage in
            ProgressHud.hide()
            DispatchQueue.main.async {
                showAlertWith(title: "Error", message: errorMessage, view: self!)
            }
        }
        
        //Calling API
        let parameters:EIDictonary = ["customer_id":user_id,"cart_id": cartId,"quantity":quantity]
        
        SERVICE_CALL.sendRequest(parameters: parameters, httpMethod: "POST", methodType: RequestedUrlType.updateCart, successCall: success, failureCall: failure)
       
    }
}

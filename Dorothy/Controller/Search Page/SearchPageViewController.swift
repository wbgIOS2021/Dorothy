//
//  SearchPageViewController.swift
//  Dorothy
//
//  Created by Adarsh raj on 27/09/21.
//

import UIKit

class SearchPageViewController: UIViewController {

    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var productSearchBtn: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    
    var product_listArray: [[String:Any]] = []
    var filtered_product_listArray: [[String:Any]] = []
    let user_id = (getStringValueFromLocal(key: "user_id") ?? "0")
    var msg:String = "Search Products"
    override func viewDidLoad() {
        super.viewDidLoad()
        productSearchBtn.layer.cornerRadius = 25
        searchTextField.layer.cornerRadius = 25
        self.searchTextField.delegate = self

        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 50))
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 50))
        searchTextField.leftView = leftView
        searchTextField.leftViewMode = .always
        searchTextField.rightView = rightView
        searchTextField.rightViewMode = .always
        cellRegister()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        self.cartCount()
    }
    
    func cellRegister()
    {
        searchTableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductTableViewCell")

    }
    @IBAction func backBtn(_ sender: Any) {
        backBtn()
    }
    
    
    @IBAction func ProductSearchBtn(_ sender: Any) {
        if searchTextField!.text! == ""
        {
            Alert.showError(title: "Error", message: "Please enter product name", vc: self)
            self.msg = "Search Products"
            self.product_listArray.removeAll()
            self.searchTableView.reloadData()
        }else{
            gettingData()
        }
    }
}


extension SearchPageViewController:UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        ProductSearchBtn(UIButton.self)
        return true
    }
}


extension SearchPageViewController: UITableViewDataSource
{
    
    func numberOfSections(in tableView: UITableView) -> Int {
    var numOfSection: NSInteger = 1
        if product_listArray.count > 0 {
            self.searchTableView.backgroundView = nil
              numOfSection = 1
        } else {
            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.searchTableView.bounds.size.width, height: self.searchTableView.bounds.size.height))
            noDataLabel.text = msg
            noDataLabel.textColor = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
            noDataLabel.textAlignment = NSTextAlignment.center
            self.searchTableView.backgroundView = noDataLabel
        }
        return numOfSection
    }

    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return product_listArray.count
        
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as! ProductTableViewCell
        let cellData = product_listArray[indexPath.row]
        
          
        cell.productImage.sd_setImage(with: URL(string: cellData["thumb"] as! String), placeholderImage: UIImage(named: "no-image"))

        cell.productName!.text! = cellData["name"] as! String
        let weight = Float(cellData["weight"] as! String)!
        cell.productweight.text! = " \(weight.clean)" + " \(cellData["weight_type"] as! String)"
        if cellData["special"] as! String == "0.00" || cellData["special"] as! String == "0" || cellData["special"] as! String == cellData["price"] as! String{
            cell.specialPrice!.text! = "\(cellData["price"] as! String)"
            cell.productPrice.isHidden = true
        }else{
            cell.productPrice!.text! = "\(cellData["price"] as! String)"
            cell.specialPrice!.text! = "\(cellData["special"] as! String)"
        }
        if cellData["isWishlist"] as! String == "1"{
            cell.likeBtn.setBackgroundImage(UIImage(named: "fill_heart"), for: .normal)
        }else{
            cell.likeBtn.setBackgroundImage(UIImage(named: "empty_heart"), for: .normal)
        }
        if cellData["stock_status_id"] as! String == "7"{
            cell.outOfStockView.isHidden = true
            cell.addToCartBtn.isHidden = false
        }else{
            cell.outOfStockView.isHidden = false
            cell.addToCartBtn.isHidden = true
        }
        cell.likeBtn.tag = indexPath.row
        cell.likeBtn.addTarget(self, action: #selector(self.wishlistCheck), for: .touchUpInside)
        cell.addToCartBtn.tag = indexPath.row
        cell.addToCartBtn.addTarget(self, action: #selector(self.productsAddToCart), for: .touchUpInside)
        return cell
    }
        
    // checking wishlist
    @objc func wishlistCheck(_ sender: UIButton)
    {
        let list =  product_listArray[sender.tag]
        let success:successHandler = {  response in
            let json = response as! [String : Any]
            let cell = self.searchTableView.cellForRow(at: NSIndexPath(row: sender.tag, section: 0) as IndexPath) as! ProductTableViewCell
            if json["responseStatus"] as! String == "1"
            {
                cell.likeBtn.setBackgroundImage(UIImage(named: "fill_heart"), for: .normal)
            }else{
                cell.likeBtn.setBackgroundImage(UIImage(named: "empty_heart"), for: .normal)
            }
        }
        self.wishlistAction(product_id: list["productId"] as! String,actionHandler:success)
    }
    
    
    @objc func productsAddToCart(_ sender:UIButton)
    {
        let product = product_listArray[sender.tag]
            addCart2(product:product)
        
    }
    
    
    
}

extension SearchPageViewController:UITableViewDelegate
{
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        vc.productId = product_listArray[indexPath.row]["productId"] as! String
        navigationController?.pushViewController(vc, animated: true)
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
extension SearchPageViewController
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
                    
                    let productId = data["product_id"] as! String
                    let thumb = data["thumb"] as! String
                    let name = data["name"] as! String
                    let description = data["description"] as! String
                    let price = data["price"] as! String
                    let special = data["special"] as! String
                    let tax = data["tax"] as! String
                    let rating = data["rating"] as! String
                    let minimum = data["minimum"] as! String
                    let weight = data["weight"] as! String
                    let weight_type = data["weight_type"] as! String
                    let stock_status_id = data["stock_status_id"] as! String
                    let stock_status = data["stock_status"] as! String
                    let option_count = data["option_count"] as! Int
                    let is_wishlist = data["is_wishlist"] as! String
                        
                    let dic:[String : Any] = ["productId":productId,"thumb":thumb,"name":name,"description":description,"price":price,"special":special,"tax":tax,"rating":rating,"minimum":minimum,"weight":weight,"weight_type":weight_type,"stock_status_id":stock_status_id,"stock_status":stock_status,"option_count":option_count,"isWishlist":is_wishlist]

                    self.product_listArray.append(dic)
                }
                
                //Reloading Table Views And Collection View
                DispatchQueue.main.async
                {
                    ProgressHud.hide()
                    self.searchTableView.reloadData()
                }
        }else{
            ProgressHud.hide()
            self.msg = "No Product Available \n Search Different products"
            self.searchTableView.reloadData()
        }
    }
        let failure:failureHandler = { [weak self] error, errorMessage in
            ProgressHud.hide()
            DispatchQueue.main.async {
              showAlertWith(title: "Error", message: errorMessage, view: self!)
            }
        }
        
        //Calling API
        let parameters:EIDictonary = ["currency_code": "USD","customer_id": user_id,"product_name":searchTextField.text!]
        
        SERVICE_CALL.sendRequest(parameters: parameters, httpMethod: "POST", methodType: RequestedUrlType.searchProduct, successCall: success, failureCall: failure)
    }
}

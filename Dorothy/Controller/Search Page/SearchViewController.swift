//
//  SearchViewController.swift
//  Dorothy
//
//  Created by Adarsh Raj on 28/08/21.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate{

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var productsTableView: UITableView!
    @IBOutlet weak var cartBtn: UIBarButtonItem!
    
    var product_listArray: [[String:Any]] = []
    var filtered_product_listArray: [[String:Any]] = []
    let user_id = (getStringValueFromLocal(key: "user_id") ?? "0")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cellRegister()
//        searchBar.showsCancelButton = true
        searchBar.delegate = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        gettingData()
        self.cartCount()
    }
    
    func cellRegister()
    {
        productsTableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductTableViewCell")

    }

    @IBAction func backBtn(_ sender: Any) {
        backBtn()
    }
}
extension SearchViewController: UITableViewDataSource
{
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filtered_product_listArray.count > 0
        {
            return filtered_product_listArray.count
        }
        return product_listArray.count
        
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = productsTableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as! ProductTableViewCell
        var cellData:[String:Any] = [:]
        if filtered_product_listArray.count > 0
        {
            cellData = filtered_product_listArray[indexPath.row]
        }else{
            cellData = product_listArray[indexPath.row]
        }
          
        cell.productImage.sd_setImage(with: URL(string: cellData["thumb"] as! String), placeholderImage: UIImage(named: "no-image"))

        cell.productName!.text! = cellData["name"] as! String
        cell.productweight.text! = cellData["description"] as! String
        if cellData["special"] as! String == "0.00" || cellData["special"] as! String == "0" || cellData["special"] as! String == cellData["price"] as! String{
            cell.specialPrice!.text! = "\(cellData["price"] as! String)"
            cell.productPrice.isHidden = true
        }else{
            cell.productPrice!.text! = "\(cellData["price"] as! String)"
            cell.specialPrice!.text! = "\(cellData["special"] as! String)"
        }
        cell.likeBtn.isHidden = true
        cell.addToCartBtn.tag = indexPath.row
        cell.addToCartBtn.addTarget(self, action: #selector(self.productsAddToCart), for: .touchUpInside)
        return cell
        
    }
        
        
    @objc func productsAddToCart(_ sender:UIButton)
    {
        var product:[String:Any] = [:]
        
        if filtered_product_listArray.count > 0
        {
            product =  filtered_product_listArray[sender.tag]
            addCart2(product:product)
        }else{
            product = product_listArray[sender.tag]
            addCart2(product:product)
        }
    }
    
    
    
}

extension SearchViewController:UITableViewDelegate
{
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


extension SearchViewController
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filtered_product_listArray = product_listArray.filter({
            ($0["name"]! as AnyObject).contains(searchText) || ($0["description"]! as AnyObject).contains(searchText)
        })
        productsTableView.reloadData()
    }
}



//MARK:- API Calling
extension SearchViewController
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
                    
                    let product_id = data["product_id"] as! String
                    let thumb = data["thumb"] as! String
                    let name = data["name"] as! String
                    let description = data["description"] as! String
                    let price = data["price"] as! String
                    let special = data["special"] as! String
                    let tax = data["tax"] as! String
                    let rating = data["rating"] as! String
                    let minimum = data["minimum"] as! String
                    let stock_status_id = data["stock_status_id"] as! String
                    let stock_status = data["stock_status"] as! String
                    let option_count = data["option_count"] as! Int
                    let is_wishlist = data["is_wishlist"] as! String
                        
                    let dic:[String : Any] = ["productId":product_id,"thumb":thumb,"name":name,"description":description,"price":price,"special":special,"tax":tax,"rating":rating,"minimum":minimum,"stock_status_id":stock_status_id,"stock_status":stock_status,"option_count":option_count,"is_wishlist":is_wishlist]

                    self.product_listArray.append(dic)
                }
                
                //Reloading Table Views And Collection View
                DispatchQueue.main.async
                {
                    ProgressHud.hide()
                    self.productsTableView.reloadData()
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
        let parameters:EIDictonary = ["currency_code": "USD","customer_id": user_id,"product_name":""]
        
        SERVICE_CALL.sendRequest(parameters: parameters, httpMethod: "POST", methodType: RequestedUrlType.searchProduct, successCall: success, failureCall: failure)
    }
}

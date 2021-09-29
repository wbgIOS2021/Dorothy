//
//  WishlistTableViewController.swift
//  Dorothy
//
//  Created by Adarsh Raj on 15/07/21.
//

import UIKit

class WishlistTableViewController: UITableViewController {

    @IBOutlet var wishlistTableView: UITableView!
    @IBOutlet weak var cartBtn: UIBarButtonItem!
    var product_listArray: [[String:Any]] = []
    let user_id = (getStringValueFromLocal(key: "user_id") ?? "0")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cellRegister()

    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        gettingData()
        self.cartCount()
    }
    func cellRegister()
    {
        wishlistTableView.register(UINib(nibName: "CartTableViewCell", bundle: nil), forCellReuseIdentifier: "CartTableViewCell")

    }
        
}

//MARK:- All Navigation Action Buttons
extension WishlistTableViewController
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
}


// MARK: - Table view data source
extension WishlistTableViewController
{
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        var numOfSection: NSInteger = 1

            if product_listArray.count > 0 {

                self.tableView.backgroundView = nil
                  numOfSection = 1


            } else {

                let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
                noDataLabel.text = "Empty Wishlist!"
                noDataLabel.textColor = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
                noDataLabel.textAlignment = NSTextAlignment.center
                self.tableView.backgroundView = noDataLabel

            }
            return numOfSection


    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return product_listArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = wishlistTableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as! CartTableViewCell
        
        let cellData = product_listArray[indexPath.row]
        cell.productImage.sd_setImage(with: URL(string: cellData["thumb"] as! String), placeholderImage: UIImage(named: "no-image"))
        cell.productName!.text! = cellData["name"] as! String
        cell.productModal.text! = cellData["product_model"] as! String
        if cellData["special"] as! String == "0.00" || cellData["special"] as! String == "0" || cellData["special"] as! String == cellData["price"] as! String{
            cell.specialPrice!.text! = "$ \(cellData["price"] as! String)"
            cell.price.text! = " "
        }else{
            cell.price!.text! = "$ \(cellData["price"] as! String)"
            cell.specialPrice!.text! = "$ \(cellData["special"] as! String)"
        }
        cell.qtyView.isHidden = true
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

            let action =  UIContextualAction(style: .normal, title: "", handler: { (action,view,completionHandler ) in
                let success:successHandler = {  response in
                    self.product_listArray.remove(at: indexPath.row)
                    self.wishlistTableView.deleteRows(at: [indexPath], with: .fade)
                    self.wishlistTableView.reloadData()

                }

                self.wishlistAction(product_id: self.product_listArray[indexPath.row]["productId"] as! String,actionHandler:success)
//
                self.showToast(message: "Product deleted successfully", seconds: 0.5)
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
    

}
//MARK:- Table View Delegate
extension WishlistTableViewController
{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        vc.productId = product_listArray[indexPath.row]["productId"] as! String
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
extension WishlistTableViewController
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
                    
                    let productId = data["productId"] as! String
                    let thumb = data["thumb"] as! String
                    let name = data["name"] as! String
                    let price = data["price"] as! String
                    let special = data["special"] as! String
                    let tax = data["tax"] as! String
                    let rating = data["rating"] as! String
                    let minimum = data["minimum"] as! String
                    let hasOption = data["hasOption"] as! String
                let product_model = data["product_model"] as! String
                let product_weight = data["product_weight"] as! String
                let product_weight_type = data["product_weight_type"] as! String
                  
                
                
                let dic:[String : Any] = ["productId":productId,"thumb":thumb,"name":name,"price":price,"special":special,"tax":tax,"rating":rating,"minimum":minimum,"hasOption":hasOption,"product_model":product_model,"product_weight":product_weight,"product_weight_type":product_weight_type]

                    self.product_listArray.append(dic)
                }
                
                //Reloading Table Views And Collection View
                DispatchQueue.main.async
                {
                    ProgressHud.hide()
                    self.wishlistTableView.reloadData()
                }
        }else{
            ProgressHud.hide()
            print("Comming Soon................................")
        }
    }
        let failure:failureHandler = { [weak self] error, errorMessage in
            ProgressHud.hide()
            DispatchQueue.main.async {
               // showAlertWith(title: "Error", message: errorMessage, view: self!)
            }
        }
        
        //Calling API
        let parameters:EIDictonary = ["currency_code": "USD","customer_id": user_id]
        
        SERVICE_CALL.sendRequest(parameters: parameters, httpMethod: "POST", methodType: RequestedUrlType.wishlist_products, successCall: success, failureCall: failure)
    }
}


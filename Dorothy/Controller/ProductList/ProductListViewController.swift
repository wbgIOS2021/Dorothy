//
//  ProductListViewController.swift
//  Dorothy
//
//  Created by Adarsh Raj on 15/07/21.
//

import UIKit

class ProductListViewController: UIViewController {

    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var itemsTableView: UITableView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var cartBtn: UIBarButtonItem!

    var category_listArray: [[String:Any]] = []
    var product_listArray: [[String:Any]] = []

    var category_id:String = ""
    var product_id:String = ""
    var bolValue:[Bool] = []
    var selectedIndex = 0
    var categoryName:String = ""
    var isComeFromProductDetailPage = false
    let user_id = (getStringValueFromLocal(key: "user_id") ?? "0")

    override func viewDidLoad() {
        super.viewDidLoad()
        cellRegister()
        
        
       
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        if isComeFromProductDetailPage == false{
            for _ in 0..<category_listArray.count{
                bolValue.append(false)
            }
            bolValue[selectedIndex] = true
            gettingData(category_id: category_id)
        }else{
            gettingCategories()
            
        }
        
        self.cartCount()
    }
    override func viewDidLayoutSubviews() {
        UIView.animate(withDuration: 1, animations: { [weak self] in
            self?.categoryCollectionView.scrollToItem(at: IndexPath(item: self!.selectedIndex, section: 0), at: .centeredHorizontally, animated: false)
        })
    }
    // Registering cell data
    func cellRegister()
    {
        // Collection view
        categoryCollectionView.register(UINib(nibName: "SmallCategoriesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SmallCategoriesCollectionViewCell")
        
        //Table view
        itemsTableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductTableViewCell")
    }
    
    
    
}

//MARK:- MARK:- Navigation Action Buttons
extension ProductListViewController
{
    @IBAction func backBtn(_ sender: Any) {
        backBtn()
    }
    @IBAction func searchBtn(_ sender: Any) {
        searchBtn()
    }
    
    
}

//MARK:- Collection view Data Source
extension ProductListViewController: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return category_listArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "SmallCategoriesCollectionViewCell", for: indexPath) as! SmallCategoriesCollectionViewCell
        
        let cellData = category_listArray[indexPath.row]
        let string = cellData["image"] as! String
        let urlNew:String = string.replacingOccurrences(of: " ", with: "%20")
        cell.categoryImage.sd_setImage(with: URL(string: urlNew), placeholderImage: UIImage(named: "no-image"))
        cell.categoryName!.text! = cellData["title"] as! String
       
        if bolValue[indexPath.row]
        {
            cell.categoryView.layer.backgroundColor = #colorLiteral(red: 0.9971496463, green: 0.8193712831, blue: 0.07595702261, alpha: 1)
            selectedIndex = indexPath.row
        }else{
            cell.categoryView.layer.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)

        }
        return cell
    }
}

//MARK:- Collection view Delegate
extension ProductListViewController: UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        isComeFromProductDetailPage = false
        title = "\(category_listArray[indexPath.row]["title"]!)"
        let category_ids = "\(category_listArray[indexPath.row]["id"]!)"
        gettingData(category_id: category_ids)
        
        if bolValue[indexPath.row]{
            for x in 0..<bolValue.count{
                 if x == indexPath.row{
                     bolValue[x] = true
                 }
                 }
        }else{
            for x in 0..<bolValue.count{
                 if x == indexPath.row{
                     bolValue[x] = true
                 }
                 else{
                    bolValue[x] = false
                 }
            }
        }
        categoryCollectionView.reloadData()
    }
    
    // For some animations
//    func collectionView(_ collectionView: UICollectionView,
//                                willDisplay cell: UICollectionViewCell,
//                                forItemAt indexPath: IndexPath) {
//       cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
//          UIView.animate(withDuration: 0.8) {
//              cell.transform = CGAffineTransform.identity
//          }
//       cell.alpha = 0
//       UIView.animate(withDuration: 0.8) {
//           cell.alpha = 1
//       }
//   }
}

//MARK:- Collection
extension ProductListViewController: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSection: NSInteger = 1

        if product_listArray.count > 0 {
            self.itemsTableView.backgroundView = nil
              numOfSection = 1
        }else {

            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.itemsTableView.bounds.size.width, height: self.itemsTableView.bounds.size.height))
            noDataLabel.text = "No Product Available!!!"
            noDataLabel.textColor = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
            noDataLabel.textAlignment = NSTextAlignment.center
            self.itemsTableView.backgroundView = noDataLabel
        }
        return numOfSection
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return product_listArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = itemsTableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as! ProductTableViewCell
        
        let cellData = product_listArray[indexPath.row]
        cell.productImage.sd_setImage(with: URL(string: cellData["thumb"] as! String), placeholderImage: UIImage(named: "no-image"))
        cell.productName!.text! = cellData["name"] as! String
        cell.productweight!.text! = "\(cellData["description"] as! String)"
        if cellData["special"] as! String == "0.00" || cellData["special"] as! String == "0" || cellData["special"] as! String == cellData["price"] as! String{
            cell.specialPrice!.text! = "$ \(cellData["price"] as! String)"
            cell.productPrice.isHidden = true
        }else{
            cell.productPrice!.text! = "$ \(cellData["price"] as! String)"
            cell.specialPrice!.text! = "$ \(cellData["special"] as! String)"
        }
        if cellData["isWishlist"] as! String == "1"{
            cell.likeBtn.setBackgroundImage(UIImage(named: "fill_heart"), for: .normal)
        }else{
            cell.likeBtn.setBackgroundImage(UIImage(named: "empty_heart"), for: .normal)
        }
        if cellData["stockStatusId"] as! String == "7"{
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
            let cell = self.itemsTableView.cellForRow(at: NSIndexPath(row: sender.tag, section: 0) as IndexPath) as! ProductTableViewCell
            if json["responseStatus"] as! String == "1"
            {
                cell.likeBtn.setBackgroundImage(UIImage(named: "fill_heart"), for: .normal)
            }else{
                cell.likeBtn.setBackgroundImage(UIImage(named: "empty_heart"), for: .normal)
            }
        }
        self.wishlistAction(product_id: list["productId"] as! String,actionHandler:success)
    }
    
    //Add to cart Action
    @objc func productsAddToCart(_ sender:UIButton)
    {
        let product =  product_listArray[sender.tag]
        addCart2(product:product)
    }
   
}
//MARK:- Table View Delegate
extension ProductListViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        vc.productId = product_listArray[indexPath.row]["productId"] as! String
        navigationController?.pushViewController(vc, animated: true)
        }
    
    
    // for some animations
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
extension ProductListViewController
{
    func gettingData(category_id:String) -> Void {
    
    ProgressHud.show()
    let success:successHandler = {  response in

        let json = response as! [String : Any]
        self.product_listArray.removeAll()
        if json["responseCode"] as! Int == 1
        {
            let responseData = json["responseData"] as? [[String : Any]]
            self.categoryName = json["categoryName"]  as! String
            _ = json["cartItemTotal"]  as! String
            _ = json["minPrice"]  as! String
            _ = json["maxPrice"]  as! String
            
            for data in responseData!
                {
                    
                    let productId = data["productId"] as! String
                    let thumb = data["thumb"] as! String
                    let name = data["name"] as! String
                    let description = data["description"] as! String
                    let price = data["price"] as! String
                    let special = data["special"] as! String
                    let specialInNumber = data["specialInNumber"] as! String
                    
                    let tax = data["tax"] as! String
                    let rating = data["rating"] as! String
                    let minimum = data["minimum"] as! String
                    let stockStatusId = data["stockStatusId"] as! String
                    
                    let stockStatus = data["stockStatus"] as! String
                    let manufacturerId = data["manufacturerId"] as! String
                    let optionCount = data["optionCount"] as! String
                    let isWishlist = data["isWishlist"] as! String
                    
                    let dic:[String : Any] = ["productId":productId,"thumb":thumb,"name":name,"description":description,"price":price,"special":special,"specialInNumber":specialInNumber,"tax":tax,"rating":rating,"minimum":minimum,"stockStatusId":stockStatusId,"stockStatus":stockStatus,"manufacturerId":manufacturerId,"optionCount":optionCount,"isWishlist":isWishlist]

                    self.product_listArray.append(dic)
                }
            
                //Reloading Table Views And Collection View
                DispatchQueue.main.async
                {
                    ProgressHud.hide()
                    self.categoryNameLabel.isHidden = false
                    self.categoryNameLabel.text! = self.categoryName
                    UIView.animate(withDuration: 1, animations: { [weak self] in
                        self?.categoryCollectionView.scrollToItem(at: IndexPath(item: self!.selectedIndex, section: 0), at: .centeredHorizontally, animated: false)
                    })
                    self.itemsTableView.reloadData()
                }
        }else{
            DispatchQueue.main.async
            {
            ProgressHud.hide()
                UIView.animate(withDuration: 1, animations: { [weak self] in
                    self?.categoryCollectionView.scrollToItem(at: IndexPath(item: self!.selectedIndex, section: 0), at: .centeredHorizontally, animated: false)
                })
            if self.product_listArray.isEmpty{
                self.categoryNameLabel.isHidden = true
            }
            self.itemsTableView.reloadData()
            }
        }
        }
        
        let failure:failureHandler = { [weak self] error, errorMessage in
            ProgressHud.hide()
            DispatchQueue.main.async {
               showAlertWith(title: "Error", message: errorMessage, view: self!)
            }
        }
        
        //Calling API
        let parameters:EIDictonary = ["currency_code": "USD","category_id":category_id,"customer_id": user_id,"is_filter": "1","sort":"2","range_start":"0","range_end":"2000","brand":"6"]
        
        SERVICE_CALL.sendRequest(parameters: parameters, httpMethod: "POST", methodType: RequestedUrlType.category_wise_product, successCall: success, failureCall: failure)
    }
}
 
//MARK:- API Calling
extension ProductListViewController
{
    func gettingRelatedProduct() -> Void {
    
    ProgressHud.show()
    let success:successHandler = {  response in

        let json = response as! [String : Any]
        self.product_listArray.removeAll()
        ProgressHud.hide()
        if json["responseCode"] as! Int == 1
        {
            let responseData = json["responseData"] as? [[String : Any]]
            self.categoryName = json["categoryName"]  as! String
            _ = json["cartItemTotal"]  as! String
            _ = json["minPrice"]  as! String
            _ = json["maxPrice"]  as! String
            
            for data in responseData!
                {
                    
                    let productId = data["productId"] as! String
                    let thumb = data["thumb"] as! String
                    let name = data["name"] as! String
                    let description = data["description"] as! String
                    let price = data["price"] as! String
                    let special = data["special"] as! String
                    let specialInNumber = data["specialInNumber"] as! String
                    
                    let tax = data["tax"] as! String
                    let rating = data["rating"] as! String
                    let minimum = data["minimum"] as! String
                    let stockStatusId = data["stockStatusId"] as! String
                    
                    let stockStatus = data["stockStatus"] as! String
                    let manufacturerId = data["manufacturerId"] as! String
                    let optionCount = data["optionCount"] as! String
                    let isWishlist = data["isWishlist"] as! String
                    
                    let dic:[String : Any] = ["productId":productId,"thumb":thumb,"name":name,"description":description,"price":price,"special":special,"specialInNumber":specialInNumber,"tax":tax,"rating":rating,"minimum":minimum,"stockStatusId":stockStatusId,"stockStatus":stockStatus,"manufacturerId":manufacturerId,"optionCount":optionCount,"isWishlist":isWishlist]

                    self.product_listArray.append(dic)
                }
            DispatchQueue.main.async
            {
                ProgressHud.hide()
                self.categoryNameLabel.text! = self.categoryName
                self.itemsTableView.reloadData()
            }
                
        }else{
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
        let parameters:EIDictonary = ["category_id":category_id,"product_id":product_id,"customer_id": user_id,"currency_code":"USD"]
        
        SERVICE_CALL.sendRequest(parameters: parameters, httpMethod: "POST", methodType: RequestedUrlType.get_similar_product, successCall: success, failureCall: failure)
    }
}
 

//MARK:- API Calling
extension ProductListViewController
{
    func gettingCategories() -> Void {
        ProgressHud.show()

        let success:successHandler = {  [self] response in
            let json = response as! [String : Any]
            let responseData = json["responseData"] as? [[String : Any]]
                
            category_listArray.removeAll()
            for data in responseData!
                {
                    
                    let id = data["id"] as! String
                    let title = data["title"] as! String
                    let image = data["image"] as! String
                    let description = data["description"] as! String
                    let subCategory = data["subCategory"] as! [[String:Any]]
                    
                    let dic:[String : Any] = ["id":id,"title":title,"image":image,"description":description,"subCategory":subCategory]

                    self.category_listArray.append(dic)
                }
                
                //Reloading Table Views And Collection View
                DispatchQueue.main.async
                { [self] in
                    for _ in 0..<category_listArray.count{
                        bolValue.append(false)
                    }
                    bolValue[selectedIndex] = false
                    ProgressHud.hide()
                    gettingRelatedProduct()
                    self.categoryCollectionView.reloadData()
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
        SERVICE_CALL.sendRequest(parameters: parameters, httpMethod: "GET", methodType: RequestedUrlType.category_list, successCall: success, failureCall: failure)
    }
}
 



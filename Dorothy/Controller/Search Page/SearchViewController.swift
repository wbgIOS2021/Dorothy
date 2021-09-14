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
    var product_listArray: [[String:Any]] = [["product_id": "57","thumb":"http://13.127.27.45/dorothy/image/cache/catalog/product/img702-350x350.png","name": "Authentic  African Nigerian Suya","description": "FRESHLY Made home Suya Very HOT and SPICY..","price": "$32.00","special": "0","tax": "$32.00","rating": "0","minimum": "1","stock_status_id": "7","stock_status": "In Stock","option_count": 0,"is_wishlist": "0"],["product_id": "55","thumb":"http://13.127.27.45/dorothy/image/cache/catalog/product/image%2048-350x350.png","name": "dry ground  ogbono ","description": "dry ground ogbono&nbsp;..","price": "$23.30","special": "0","tax": "$23.30","rating": "3","minimum": "1","stock_status_id": "7","stock_status": "In Stock","option_count": 0,"is_wishlist": "0"],["product_id": "54","thumb":"http://13.127.27.45/dorothy/image/cache/catalog/product/image%2051-350x350.png","name": "dry grounded  pepper","description": "dry grounded pepper..","price":"$80.00","special": "0","tax": "$80.00","rating": "3","minimum": "1","stock_status_id": "7","stock_status": "In Stock","option_count": 0,"is_wishlist": "1"],["product_id": "56","thumb":"http://13.127.27.45/dorothy/image/cache/catalog/product/img703-350x350.png","name": "Genuine African Nigerian Suya","description": "freshly prepared with homemade Signature Suya spice..","price": "$32.00","special": "0","tax": "$32.00","rating": "3","minimum": "1","stock_status_id": "7","stock_status": "In Stock","option_count": 0,"is_wishlist": "0"],["product_id": "53","thumb": "http://13.127.27.45/dorothy/image/cache/catalog/product/image%2040-350x350.png","name":"Knorr Chicken  Cube","description": "Knorr Chicken Cube..","price": "$250.00","special": "0","tax": "$250.00","rating": "3","minimum": "1","stock_status_id": "7","stock_status": "In Stock","option_count": 0,"is_wishlist": "0"],["product_id": "51","thumb": "http://13.127.27.45/dorothy/image/cache/catalog/product/image%2037-350x350.png","name": "Milo","description": "Milo..","price": "$250.00","special": "0","tax": "$250.00","rating": "2","minimum": "1","stock_status_id": "7","stock_status": "In Stock","option_count": 0,"is_wishlist": "1"],["product_id": "50","thumb": "http://13.127.27.45/dorothy/image/cache/catalog/product/image%2036-350x350.png","name": "Peak Milk","description": "Peak Milk..","price": "$200.00","special": "0","tax": "$200.00","rating": "3","minimum": "1","stock_status_id": "6","stock_status": "2-3 Days","option_count": 1,"is_wishlist": "0"],["product_id": "52","thumb": "http://13.127.27.45/dorothy/image/cache/catalog/product/image%2039-350x350.png","name": "Suya Spice","description": "Suya Spice..","price": "$250.00","special": "0","tax": "$250.00","rating": "4","minimum": "1","stock_status_id": "7","stock_status": "In Stock","option_count": 0,"is_wishlist": "1"]]

    var filtered_product_listArray: [[String:Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cellRegister()
        searchBar.delegate = self
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        self.cartCount()
    }
    func cellRegister()
    {
        productsTableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductTableViewCell")

    }
//    @IBAction func cartBtn(_ sender: Any) {
//        cartBtn()
//    }
    @IBAction func backBtn(_ sender: Any) {
        backBtn()
    }
}
extension SearchViewController: UITableViewDataSource
{
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filtered_product_listArray.count > 0{
            return filtered_product_listArray.count
        }
        return product_listArray.count
    }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if filtered_product_listArray.count > 0
        {
            let cell = productsTableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as! ProductTableViewCell
            
            let cellData = filtered_product_listArray[indexPath.row]
        
            
            cell.productImage.sd_setImage(with: URL(string: cellData["thumb"] as! String), placeholderImage: UIImage(named: "no-image"))

            cell.productName!.text! = cellData["name"] as! String
            cell.productweight.text! = cellData["description"] as! String
            if cellData["special"] as! String == "0.00" || cellData["special"] as! String == "0" || cellData["special"] as! String == cellData["price"] as! String{
                cell.productPrice!.text! = "$ \(cellData["price"] as! String)"
            }else{
                cell.productPrice!.text! = "$ \(cellData["special"] as! String)"
            }
            if cellData["is_wishlist"] as! String == "1"{
                cell.likeBtn.setBackgroundImage(UIImage(named: "fill_heart"), for: .normal)
            }else{
                cell.likeBtn.setBackgroundImage(UIImage(named: "empty_heart"), for: .normal)
            }
            return cell
        }else{
            
            let cell = productsTableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as! ProductTableViewCell
            let cellData = product_listArray[indexPath.row]
        
            
            cell.productImage.sd_setImage(with: URL(string: cellData["thumb"] as! String), placeholderImage: UIImage(named: "no-image"))

            cell.productName!.text! = cellData["name"] as! String
            cell.productweight.text! = cellData["description"] as! String
            if cellData["special"] as! String == "0.00" || cellData["special"] as! String == "0" || cellData["special"] as! String == cellData["price"] as! String{
                cell.productPrice!.text! = "$ \(cellData["price"] as! String)"
            }else{
                cell.productPrice!.text! = "$ \(cellData["special"] as! String)"
            }
            if cellData["is_wishlist"] as! String == "1"{
                cell.likeBtn.setBackgroundImage(UIImage(named: "fill_heart"), for: .normal)
            }else{
                cell.likeBtn.setBackgroundImage(UIImage(named: "empty_heart"), for: .normal)
            }
            return cell

        }
        return UITableViewCell()
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





//
//  CategoriesTableViewController.swift
//  Dorothy
//
//  Created by Adarsh Raj on 15/07/21.
//

import UIKit

class CategoriesTableViewController: UITableViewController {

    @IBOutlet var categoryTableView: UITableView!
    @IBOutlet weak var cartBtn: UIBarButtonItem!

    var category_listArray: [[String:Any]] = [["id": "61","image": "http://13.127.27.45/dorothy/image/cache/catalog/category/rice%201-144x128.png","title": "Grains"],["id": "60","image": "http://13.127.27.45/dorothy/image/cache/catalog/category/soup%201-144x128.png","title": "Soups"],["id": "62","image": "http://13.127.27.45/dorothy/image/cache/catalog/category/beverage%201-144x128.png","title": "Beverages"],["id": "63","image": "http://13.127.27.45/dorothy/image/cache/catalog/category/spice-144x128.png","title": "Spices",],["id": "64","image": "http://13.127.27.45/dorothy/image/cache/catalog/product/img701-144x128.png","title": "Suya Spices"],["id": "59","image": "http://13.127.27.45/dorothy/image/cache/catalog/category/steak-144x128.png","title": "Suya"]]
    override func viewDidLoad() {
        super.viewDidLoad()
        cellRegister()
        cartBadgeIcon(qty:"5")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }

    //Celling Register
    func cellRegister()
    {
        categoryTableView.register(UINib(nibName: "AllCategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "AllCategoryTableViewCell")

    }
    
}

//MARK:- Navigation  Action Button
extension CategoriesTableViewController
{
    
    @IBAction func backBtn(_ sender: Any) {
        backBtn()

    }
//    @IBAction func cartBtn(_ sender: Any) {
//        cartBtn()
//    }
}

// MARK: - Table view data source
extension CategoriesTableViewController
{

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category_listArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoryTableView.dequeueReusableCell(withIdentifier: "AllCategoryTableViewCell", for: indexPath) as! AllCategoryTableViewCell
        
        let cellData = category_listArray[indexPath.row]
        cell.categoryImage.sd_setImage(with: URL(string: cellData["image"] as! String), placeholderImage: UIImage(named: "no-image"))
        cell.categoryNameLabel!.text! = cellData["title"] as! String
        return cell
    }
    
}


//MARK:- Table view Delegate
extension CategoriesTableViewController
{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.categoryTableView.cellForRow(at: indexPath) as! AllCategoryTableViewCell
        cell.categoryView.layer.backgroundColor = #colorLiteral(red: 0.9775478244, green: 0.7881384492, blue: 0.2792427242, alpha: 1)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let vC = self.storyboard?.instantiateViewController(withIdentifier: "ProductListViewController") as! ProductListViewController
            vC.category_listArray = self.category_listArray
            vC.title = "\(self.category_listArray[indexPath.row]["title"]!)"
            vC.category_id = "\(self.category_listArray[indexPath.row]["id"]!)"
            vC.selectedIndex = indexPath.row
            self.navigationController?.pushViewController(vC, animated: true)
        }
    }
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = self.categoryTableView.cellForRow(at: indexPath) as! AllCategoryTableViewCell
        cell.categoryView.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
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



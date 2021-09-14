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
    var bolValue:[Bool] = []
    var selectedIndex = 0
    var categoryName:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        cellRegister()
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        itemsTableView.dataSource = self
        itemsTableView.delegate = self
        
        
        for _ in 0..<category_listArray.count{
            bolValue.append(false)
        }
        bolValue[selectedIndex] = true
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
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
        cell.categoryImage.sd_setImage(with: URL(string: cellData["image"] as! String), placeholderImage: UIImage(named: "no-image"))
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
//        let cell = categoryCollectionView.cellForItem(at: indexPath) as! SmallCategoriesCollectionViewCell
        
        title = "\(category_listArray[indexPath.row]["title"]!)"
        
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
    func collectionView(_ collectionView: UICollectionView,
                                willDisplay cell: UICollectionViewCell,
                                forItemAt indexPath: IndexPath) {
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

//MARK:- Collection
extension ProductListViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = itemsTableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as! ProductTableViewCell
        return cell
    }
   
}
//MARK:- Table View Delegate
extension ProductListViewController: UITableViewDelegate
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


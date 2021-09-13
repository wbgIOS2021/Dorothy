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
    @IBOutlet weak var mobile: UILabel!
    @IBOutlet weak var orderMethod: UILabel!
    @IBOutlet weak var orderStatus: UILabel!
    @IBOutlet weak var orderStatusDate: UILabel!
    @IBOutlet weak var itemTotal: UILabel!
    @IBOutlet weak var discountOnOriginalPrice: UILabel!
    @IBOutlet weak var packagingCharge: UILabel!
    @IBOutlet weak var totalTax: UILabel!
    @IBOutlet weak var deliveryCost: UILabel!
    @IBOutlet weak var totalSavingView: UIView!
    @IBOutlet weak var finalAmount: UILabel!
    @IBOutlet weak var orderTotal: UILabel!
    @IBOutlet weak var totalMRP: UILabel!
    @IBOutlet weak var orderNumber: UILabel!
    @IBOutlet weak var totalSaving: UILabel!
    @IBOutlet weak var bottomReturnView: UIView!
    @IBOutlet weak var cartBtn: UIBarButtonItem!
    @IBOutlet weak var orderDetailsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cellregister()
        cartBadgeIcon(qty:"5")
        totalSavingView.layer.borderWidth = 1
        totalSavingView.layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        bottomReturnView.layer.cornerRadius = 30
        bottomReturnView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func cellregister()
    {
        //Table view
        productsTableView.register(UINib(nibName: "OrdersTableViewCell", bundle: nil), forCellReuseIdentifier: "OrdersTableViewCell")
    }
    override func viewWillAppear(_ animated: Bool) {
        
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
//    @IBAction func cartBtn(_ sender: Any) {
//        cartBtn()
//    }
    @IBAction func searchBtn(_ sender: Any) {
        searchBtn()
    }
    @IBAction func backBtn(_ sender: Any) {
        backBtn()
    }
    @IBAction func orderReturnBtn(_ sender: Any) {
    }
}

extension OrderSummaryViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = productsTableView.dequeueReusableCell(withIdentifier: "OrdersTableViewCell", for: indexPath) as! OrdersTableViewCell
                
        return cell
    }

}
//MARK:- Table View Data Source
extension OrderSummaryViewController: UITableViewDelegate
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

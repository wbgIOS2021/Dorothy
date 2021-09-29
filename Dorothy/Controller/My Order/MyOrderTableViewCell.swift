//
//  MyOrderTableViewCell.swift
//  Dorothy
//
//  Created by Adarsh Raj on 17/07/21.
//

import UIKit

class MyOrderTableViewCell: UITableViewCell {
    @IBOutlet weak var orderId: UILabel!
    @IBOutlet weak var orderStatusDate: UILabel!
    @IBOutlet weak var orderStatus: UILabel!
    @IBOutlet weak var orderPrice: UILabel!
    @IBOutlet weak var orderView: UIView!
    @IBOutlet weak var productsTableView: OwnTableView!
    @IBOutlet weak var view_all: UILabel!
    @IBOutlet weak var productsTableViewHeight: NSLayoutConstraint!
    
    var count:Int = 3
    var data : [[String:Any]] = []
    var order_Id:String = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        self.orderView.dropShadow()
        cellregister()
        productsTableView.dataSource = self
        productsTableView.delegate = self
        self.productsTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func prepareForReuse() {
            super.prepareForReuse()
    }
    
    func cellregister()
    {
        //Table view
        productsTableView.register(UINib(nibName: "OrdersTableViewCell", bundle: nil), forCellReuseIdentifier: "OrdersTableViewCell")
    }
    
    deinit {
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
}

extension MyOrderTableViewCell: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if data.count < 4{
            view_all.isHidden = true
            return data.count
        }
        else{
            view_all.isHidden = false
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = productsTableView.dequeueReusableCell(withIdentifier: "OrdersTableViewCell", for: indexPath) as! OrdersTableViewCell
        cell.productPrice.isHidden = true
        let cellData = data[indexPath.row]
        cell.productImage.sd_setImage(with: URL(string: cellData["image"] as! String), placeholderImage: UIImage(named: "no-image"))
        
        cell.productName.text! = cellData["name"] as! String
        let weight = Float(cellData["weight"] as! String)!
        cell.productQty.text! = "Quantity - \(cellData["quantity"] as! String) x " + " \(weight.clean)" + " \(cellData["weight_type"] as! String)"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "OrderSummaryViewController") as! OrderSummaryViewController
        vc.orderId = order_Id
        let navigationController = self.window?.rootViewController as! UINavigationController
        navigationController.pushViewController(vc, animated: true)
    }
    
    
}

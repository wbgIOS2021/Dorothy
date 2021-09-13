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
    @IBOutlet weak var productsTableViewHeight: NSLayoutConstraint!
    var count:Int = 3
    override func awakeFromNib() {
        super.awakeFromNib()
        self.orderView.dropShadow()
        cellregister()
        productsTableView.dataSource = self
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

extension MyOrderTableViewCell: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = productsTableView.dequeueReusableCell(withIdentifier: "OrdersTableViewCell", for: indexPath) as! OrdersTableViewCell
        cell.productPrice.isHidden = true
        return cell
    }
    
    
}

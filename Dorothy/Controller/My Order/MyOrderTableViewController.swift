//
//  MyOrderTableViewController.swift
//  Dorothy
//
//  Created by Adarsh Raj on 17/07/21.
//

import UIKit

class MyOrderTableViewController: UITableViewController {

    @IBOutlet var myOrdertableView: OwnTableView!
    @IBOutlet weak var cartBtn: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        cellregister()
        cartBadgeIcon(qty:"5")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        
    }
    
    //registering cell
    func cellregister()
    {
        //Table view
        myOrdertableView.register(UINib(nibName: "MyOrderTableViewCell", bundle: nil), forCellReuseIdentifier: "MyOrderTableViewCell")

    }
  
}


//MARK:- Navigation Action Button
extension MyOrderTableViewController
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
extension MyOrderTableViewController
{
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        var numOfSection: NSInteger = 1

        
        return numOfSection

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myOrdertableView.dequeueReusableCell(withIdentifier: "MyOrderTableViewCell", for: indexPath) as! MyOrderTableViewCell
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let VC = storyboard?.instantiateViewController(withIdentifier: "OrderSummaryViewController") as! OrderSummaryViewController
        navigationController?.pushViewController(VC, animated: true)

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



//
//  MyAddressTableViewController.swift
//  Dorothy
//
//  Created by Adarsh Raj on 02/09/21.
//

import UIKit

class MyAddressTableViewController: UITableViewController {

    @IBOutlet var addressTableView: UITableView!
    @IBOutlet weak var cartBtn: UIBarButtonItem!
    
    var address_data: [[String:Any]] = []
    var isComeFromCheckout:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        addressTableView.dataSource = self
        cellRegister()
        cartBadgeIcon(qty:"5")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1058823529, green: 0.07450980392, blue: 0.07450980392, alpha: 1)
       // navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        //navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
    }
    
    func cellRegister()
    {
        addressTableView.register(UINib(nibName: "MyAddressTableViewCell", bundle: nil), forCellReuseIdentifier: "MyAddressTableViewCell")

    }

    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSection: NSInteger = 1

        return numOfSection
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = addressTableView.dequeueReusableCell(withIdentifier: "MyAddressTableViewCell", for: indexPath) as! MyAddressTableViewCell
        if indexPath.row != 0
        {
            cell.isDefaultLabel.isHidden = true
        }
        cell.fullAddressLabel.text! = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent in neque at est ultricies facilisis sit amet quis lectus."
        return cell
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

//MARK:- Action Buttons
extension MyAddressTableViewController
{
    @IBAction func backBtn(_ sender: Any) {
        backBtn()
    }
    
//    @IBAction func cartBtn(_ sender: Any) {
//        cartBtn()
//    }
    @IBAction func addNewAddressBtn(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddAddressViewController") as! AddAddressViewController

        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func searchBtn(_ sender: Any) {
        searchBtn()
    }
}



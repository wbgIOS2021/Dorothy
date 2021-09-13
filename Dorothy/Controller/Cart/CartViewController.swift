//
//  CartViewController.swift
//  Dorothy
//
//  Created by Adarsh Raj on 02/09/21.
//

import UIKit

class CartViewController: UIViewController {

    @IBOutlet weak var checkoutBtnView: UIView!
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var shadowImage: UIImageView!
    @IBOutlet weak var totalPayLabel: UILabel!
    @IBOutlet weak var totalSaveLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cartTableView.dataSource = self
        cartTableView.delegate = self
        cellRegister()

        checkoutBtnView.layer.cornerRadius = 30
        checkoutBtnView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        shadowImage.addTopShadow(shadowColor: UIColor.white, shadowOpacity: 1.0, shadowRadius: 10, offset: CGSize(width: 0, height: -35))
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    func cellRegister()
    {
        cartTableView.register(UINib(nibName: "CartTableViewCell", bundle: nil), forCellReuseIdentifier: "CartTableViewCell")
    }
    
    @IBAction func checkoutBtn(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "CheckoutViewController") as! CheckoutViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
}


//MARK:- Navigation Button
extension CartViewController
{
    @IBAction func backBtn(_ sender: Any) {
        backBtn()
    }
    @IBAction func searchBtn(_ sender: Any) {
        searchBtn()
    }
}

//MARK:- Table view Data Source
extension CartViewController: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSection: NSInteger = 1

        return numOfSection

}
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = cartTableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as! CartTableViewCell
        
        cell.qtyView.isHidden = true
        cell.addProductButton.tag = indexPath.row
        cell.addProductButton.addTarget(self, action: #selector(self.addProduct), for: .touchUpInside)
        return cell
    }
    
    
    @objc func addProduct(_ sender:UIButton)
    {
        let cell = self.cartTableView.cellForRow(at: NSIndexPath(row: sender.tag, section: 0) as IndexPath) as! CartTableViewCell
        cell.addProductButton.isHidden = true
        cell.qtyView.isHidden = false
    }
}


//MARK:- Table view Delegate
extension CartViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

            let action =  UIContextualAction(style: .normal, title: "", handler: { (action,view,completionHandler ) in
                //self.cartTableView.deleteRows(at: [indexPath], with: .fade)
                self.showToast(message: "Product deleted successfully", seconds: 0.5)
               // self.cartTableView.reloadData()
                completionHandler(true)

            })
            
                action.image = UIGraphicsImageRenderer(size: CGSize(width: 20, height: 20)).image { _ in
                    UIImage(named: "delete_icon")?.draw(in: CGRect(x: 0, y: 0, width: 20, height: 20))
                }
                action.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                let confrigation = UISwipeActionsConfiguration(actions: [action])
                //confrigation.performsFirstActionWithFullSwipe = false
                return confrigation
    }
    

    
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

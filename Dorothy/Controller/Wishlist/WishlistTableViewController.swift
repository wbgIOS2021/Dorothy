//
//  WishlistTableViewController.swift
//  Dorothy
//
//  Created by Adarsh Raj on 15/07/21.
//

import UIKit

class WishlistTableViewController: UITableViewController {

    @IBOutlet var wishlistTableView: UITableView!
    @IBOutlet weak var cartBtn: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        cellRegister()

    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        self.cartCount()
    }
    func cellRegister()
    {
        wishlistTableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductTableViewCell")

    }
        
}

//MARK:- All Navigation Action Buttons
extension WishlistTableViewController
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
extension WishlistTableViewController
{
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        var numOfSection: NSInteger = 1

            
            return numOfSection

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = wishlistTableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as! ProductTableViewCell
        cell.likeBtn.isHidden = true
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

            let action =  UIContextualAction(style: .normal, title: "", handler: { (action,view,completionHandler ) in
                //self.wishlistTableView.deleteRows(at: [indexPath], with: .fade)
                self.showToast(message: "Product deleted successfully", seconds: 0.5)
                completionHandler(true)

            })
            
                action.image = UIGraphicsImageRenderer(size: CGSize(width: 20, height: 20)).image { _ in
                    UIImage(named: "delete_icon")?.draw(in: CGRect(x: 0, y: 0, width: 20, height: 20))
                }
                action.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                let confrigation = UISwipeActionsConfiguration(actions: [action])
                confrigation.performsFirstActionWithFullSwipe = false
                return confrigation
            
    }
    
}
//MARK:- Table View Delegate
extension WishlistTableViewController
{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vC = storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        navigationController?.pushViewController(vC, animated: true)
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


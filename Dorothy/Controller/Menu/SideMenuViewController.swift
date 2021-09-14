//
//  SideMenuViewController.swift
//  Dorothy
//
//  Created by Adarsh Raj on 02/09/21.
//

import UIKit
import SideMenuSwift

class SideMenuViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var menuTable: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var menuView:UIView!
    @IBOutlet weak var upperSectionView: UIView!
    @IBOutlet weak var checkLoginBtn: UIButton!
    
    var menuItems = [["name":"Home","page_id":""],["name":"Category","page_id":""],["name":"My Profile","page_id":""],["name":"My Wishlist","page_id":""],["name":"About Us","page_id":""],["name":"Contact Us","page_id":""],["name":"Delivery Information","page_id":""],["name":"Term & Condition","page_id":""],["name":"Privacy Policy","page_id":""]]
    var user_pic:String = getStringValueFromLocal(key: "profile_pic") ?? "user1"
    override func viewDidLoad() {
        super.viewDidLoad()
        menuView.setGradientBackground1()
        menuTable.dataSource = self
        menuTable.delegate = self
        checkLoginBtn.layer.cornerRadius = 10
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        
        let isLogin = getStringValueFromLocal(key: "user_id")
        if isLogin != nil{
            checkLoginBtn.isHidden = true
        }else
        {
            checkLoginBtn.isHidden = false
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        menuTable.reloadData()
        user_pic = getStringValueFromLocal(key: "profile_pic") ?? "user1"
        profileImage.sd_setImage(with: URL(string: user_pic), placeholderImage: UIImage(named: "user1"))
        nameLabel!.text! = " \(getStringValueFromLocal(key: "name") ?? " ")"
    }
    
}

extension SideMenuViewController
{
    @IBAction func loginbtn(_ sender:UIButton)
    {
        let login = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(login, animated: true)
    }
}

// MARK:Menu View
extension SideMenuViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = menuTable.dequeueReusableCell(withIdentifier: "SideMneuTableViewCell", for: indexPath) as! SideMneuTableViewCell
        
        let cellData = menuItems[indexPath.row]
        cell.menuTitleLabel!.text! = cellData["name"] ?? "...."
        return cell
    }
    
}

extension SideMenuViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {


        switch indexPath.row{
        
        case 0:
            // Home
            print(menuItems[indexPath.row])
            sideMenuController?.hideMenu()
           
        case 1:
            // Category
            print(menuItems[indexPath.row])
            sideMenuController?.hideMenu()
            let vc = storyboard?.instantiateViewController(withIdentifier: "CategoriesTableViewController") as! CategoriesTableViewController
            navigationController?.pushViewController(vc, animated: true)
        case 2:
            //My Profile
            sideMenuController?.hideMenu()
            print(menuItems[indexPath.row])
            let isLogin = getStringValueFromLocal(key: "user_id")
            if isLogin != nil{
                sideMenuController?.hideMenu()
                let vc = storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
                navigationController?.pushViewController(vc, animated: true)
            }else
            {
                goToLogin(message: "You have not login yet. Please login")
            }
      
        case 3:
            //My Wishlist
            sideMenuController?.hideMenu()
            print(menuItems[indexPath.row])
            let isLogin = getStringValueFromLocal(key: "user_id")
            if isLogin != nil{
                sideMenuController?.hideMenu()
                let vc = storyboard?.instantiateViewController(withIdentifier: "WishlistTableViewController") as! WishlistTableViewController
                navigationController?.pushViewController(vc, animated: true)
            }else
            {
                goToLogin(message: "You have not login yet. Please login")
            }
            
        case 5:
            // Contact Us
            sideMenuController?.hideMenu()
            print(menuItems[indexPath.row])
            let vc = storyboard?.instantiateViewController(withIdentifier: "ContactUsViewController") as! ContactUsViewController

            navigationController?.pushViewController(vc, animated: true)
        
        default:
            sideMenuController?.hideMenu()
            print("default value")
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "PageDescriptionViewController") as! PageDescriptionViewController
            vc.title = menuItems[indexPath.row]["name"]
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
extension SideMenuViewController
{
    
}



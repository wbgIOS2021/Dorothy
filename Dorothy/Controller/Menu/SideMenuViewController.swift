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
    
    var menuItems:[[String:Any]] = [["name":"Home","page_id":""],["name":"Category","page_id":""],["name":"My Profile","page_id":""],["name":"My Wishlist","page_id":""],["name":"Contact Us","page_id":""]]
    var user_pic:String = getStringValueFromLocal(key: "profile_pic") ?? "user1"
    override func viewDidLoad() {
        super.viewDidLoad()
        gettingData()
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
        cell.menuTitleLabel!.text! = cellData["name"] as! String
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
            }else{
                goToLogin(title: "Login Require", message: "You have not login yet. Please login")
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
            }else{
                goToLogin(title: "Login Require", message: "You have not login yet. Please login")
            }
            
        case 4:
            // Contact Us
            sideMenuController?.hideMenu()
            print(menuItems[indexPath.row])
            let vc = storyboard?.instantiateViewController(withIdentifier: "ContactUsViewController") as! ContactUsViewController

            navigationController?.pushViewController(vc, animated: true)
        
        default:
            sideMenuController?.hideMenu()
            let vc = storyboard?.instantiateViewController(withIdentifier: "PageDescriptionViewController") as! PageDescriptionViewController
            let cellData = menuItems[indexPath.row]
            vc.page_id = cellData["page_id"] as! String
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}

//MARK:- Page List API Calling
extension SideMenuViewController
{
    func gettingData() -> Void {
    ProgressHud.show()

    let success:successHandler = {  response in

        let json = response as! [String : Any]
        if json["responseCode"] as! Int == 1
        {
            let responseData = json["responseData"] as? [[String : Any]]
            
            for data in responseData!
                {
                    let name = data["name"] as! String
                    let page_id = data["page_id"] as! String
                    
                    let dic:[String : Any] = ["name":name,"page_id":page_id]
                    self.menuItems.append(dic)
                }
                
                //Reloading Table Views And Collection View
                DispatchQueue.main.async
                {
                    ProgressHud.hide()
                    self.menuTable.reloadData()
                }
        }else{
            ProgressHud.hide()
            print("Comming Soon................................")
        }
    }
        let failure:failureHandler = { [weak self] error, errorMessage in
            ProgressHud.hide()
            DispatchQueue.main.async {
               // showAlertWith(title: "Error", message: errorMessage, view: self!)
            }
        }
        
        //Calling API
        let parameters:EIDictonary = [:]
        
        SERVICE_CALL.sendRequest(parameters: parameters, httpMethod: "POST", methodType: RequestedUrlType.pageLists, successCall: success, failureCall: failure)
    }

}




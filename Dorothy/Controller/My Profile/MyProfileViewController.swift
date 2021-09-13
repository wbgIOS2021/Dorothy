//
//  MyProfileViewController.swift
//  Dorothy
//
//  Created by Adarsh Raj on 03/09/21.
//

import UIKit
enum Menu:Int{
    case myOrder=0, myAddress=1, privacy=2
    
}
class MyProfileViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var user_pic: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userMobile: UILabel!
    @IBOutlet weak var menuListTV: UITableView!
    @IBOutlet weak var cartBtn:UIBarButtonItem!
    @IBOutlet weak var curveView: UIView!
    @IBOutlet weak var backView:UIView!
    @IBOutlet weak var profileScrollView: UIScrollView!
    
    var menuItems = [["title":"My Order","subTitle":"View all Orders"],
                     ["title":"My Address","subTitle":"Add or Update Address"],
                     ["title":"Privacy","subTitle":"Change your password"]]
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground(view: backView)
//        setGradientBackground1()
        user_pic.layer.cornerRadius = user_pic.frame.size.width / 2
        user_pic.clipsToBounds = true
        profileScrollView.delegate = self
        curveView.layer.cornerRadius = 100
        curveView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        cartBadgeIcon(qty:"5")
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.height {
            scrollView.contentOffset.y = scrollView.contentSize.height - scrollView.bounds.height
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.homePage()
    }
    
//    @IBAction func cartBtn(_ sender: Any) {
//        cartBtn()
//    }
    @IBAction func editProfileBtn(_ sender: Any) {
        let editProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
        self.navigationController?.pushViewController(editProfileVC, animated: true)
    }
    @IBAction func logoutBtn(_ sender: Any) {
    }
}

extension MyProfileViewController:UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = menuListTV.dequeueReusableCell(withIdentifier: "MyProfileMenuListTableViewCell", for: indexPath) as! MyProfileMenuListTableViewCell
        let cellData = menuItems[indexPath.row]
        cell.menuTitle.text! = cellData["title"] as! String
        cell.menuSubTitle!.text! = cellData["subTitle"] as!
            String
        cell.menuView.layer.cornerRadius = 10
        return cell
    }
}
extension MyProfileViewController: UITableViewDelegate
{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch Menu(rawValue: indexPath.row){
        
        case .myOrder:
            let cartVC = storyboard?.instantiateViewController(withIdentifier: "MyOrderTableViewController") as! MyOrderTableViewController
            navigationController?.pushViewController(cartVC, animated: true)
            print(menuItems[indexPath.row])
            
        case .myAddress:
            print(menuItems[indexPath.row])
            let VC = storyboard?.instantiateViewController(withIdentifier: "MyAddressTableViewController") as! MyAddressTableViewController
            navigationController?.pushViewController(VC, animated: true)
            
        case .privacy:
            print(menuItems[indexPath.row])
            
        case .none:
            print(".......")
        }
    }
}


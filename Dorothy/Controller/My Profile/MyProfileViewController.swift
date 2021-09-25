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
        
    var user_list_Dic: [String:Any] = [:]
    
    var user_id = getStringValueFromLocal(key: "user_id") ?? "0"

    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground(view: backView)
//        setGradientBackground1()
        user_pic.layer.cornerRadius = user_pic.frame.size.width / 2
        user_pic.clipsToBounds = true
        profileScrollView.delegate = self
        curveView.layer.cornerRadius = 100
        curveView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.height {
            scrollView.contentOffset.y = scrollView.contentSize.height - scrollView.bounds.height
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        gettingData()
        self.cartCount()
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.homePage()
    }
    

    @IBAction func editProfileBtn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
        vc.user_list_Dic = user_list_Dic
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func logoutBtn(_ sender: Any) {
        showAlertWithCancel(title: "Info.", message: "Do you sure want to logout?", view: self, btn_title: "Logout", actionHandler: {
            UserDefaults.standard.removeObject(forKey: "user_id")
            UserDefaults.standard.removeObject(forKey: "name")
            UserDefaults.standard.removeObject(forKey: "profile_pic")
            self.homePage()
        })
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
            let VC = storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
            navigationController?.pushViewController(VC, animated: true)
        case .none:
            print(".......")
        }
    }
}


//MARK:- API Calling
extension MyProfileViewController
{
    func gettingData() -> Void {
        ProgressHud.show()

        let success:successHandler = {  response in

            let json = response as! [String : Any]
            if json["responseCode"] as! Int == 1
            {
                
                let responseData = json["responseData"] as! [String : Any]

                    let customerId = responseData["customerId"] as! String
                    let firstName = responseData["firstName"] as! String
                    let lastName = responseData["lastName"] as! String
                    let email = responseData["email"] as! String
                    let telephone = responseData["telephone"] as! String
                    let profileImage = responseData["profileImage"] as! String
                        
                    self.userName.text! = firstName + " " + lastName
                    self.userEmail.text! = email
                    self.userMobile.text! = telephone
                    self.user_pic.sd_setImage(with: URL(string: profileImage), placeholderImage: UIImage(named: "user1"))

                    saveStringOnLocal(key: "profile_pic", value: profileImage)
                    saveStringOnLocal(key: "name", value: firstName + " " + lastName)
                
                self.user_list_Dic["firstName"] = firstName
                self.user_list_Dic["lastName"] = lastName
                self.user_list_Dic["email"] = email
                self.user_list_Dic["telephone"] = telephone
                self.user_list_Dic["profileImage"] = profileImage

                DispatchQueue.main.async
                {
                    ProgressHud.hide()
                   
                }
            }else{
                let mess = json["responseText"] as! String
                Alert.showError(title: "Error", message: mess, vc: self)
            }
                
        }
        
        let failure:failureHandler = { [weak self] error, errorMessage in
            ProgressHud.hide()
            DispatchQueue.main.async {
               // showAlertWith(title: "Error", message: errorMessage, view: self!)
            }
        }
        
        //Calling API
        let parameters:EIDictonary = ["customer_id":user_id]
        SERVICE_CALL.sendRequest(parameters: parameters, httpMethod: "POST", methodType: RequestedUrlType.view_profile, successCall: success, failureCall: failure)
    }
}
 

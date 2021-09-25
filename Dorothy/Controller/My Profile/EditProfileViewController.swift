//
//  EditProfileViewController.swift
//  Dorothy
//
//  Created by Adarsh Raj on 03/09/21.
//

import UIKit
import AVFoundation
import Alamofire

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, UIScrollViewDelegate  {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    
    @IBOutlet weak var changeProfilePicBtn: UIButton!
    @IBOutlet weak var mobileNumberTF: UITextField!
    
    @IBOutlet weak var curveView: UIView!
    @IBOutlet weak var emailIdTF: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var cartBtn: UIBarButtonItem!
    @IBOutlet weak var backView:UIView!
    @IBOutlet weak var profileScrollView: UIScrollView!
    
    var user_id = getStringValueFromLocal(key: "user_id") ?? "0"
    var user_list_Dic: [String:Any] = [:]
    var image = UIImage(named:"no-image")
    var country_code:String = "+91"
    override func viewDidLoad() {
        super.viewDidLoad()
        additionalSetup()

        profileImage.sd_setImage(with: URL(string: user_list_Dic["profileImage"] as! String), placeholderImage: UIImage(named: "user1"))
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        firstNameTF.text! = user_list_Dic["firstName"] as! String
        lastNameTF.text! = user_list_Dic["lastName"] as! String
        mobileNumberTF.text! = user_list_Dic["telephone"] as! String
        emailIdTF.text! = user_list_Dic["email"] as! String
        self.cartCount()
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.height {
            scrollView.contentOffset.y = scrollView.contentSize.height - scrollView.bounds.height
        }
    }
    
    func additionalSetup()
    {
        setGradientBackground(view: backView)
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        changeProfilePicBtn.layer.cornerRadius = changeProfilePicBtn.frame.size.width / 2
        changeProfilePicBtn.clipsToBounds = true
        saveBtn.layer.cornerRadius = 25
        curveView.layer.cornerRadius = 100
        curveView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        profileScrollView.delegate = self
    }
}


extension EditProfileViewController
{
    @IBAction func submitBtn(_ sender: Any) {
        if firstNameTF.text! == ""
        {
            Alert.showError(title: "Error", message: "Enter first name", vc: self)
        }else if lastNameTF.text! == ""
        {
            Alert.showError(title: "Error", message: "Enter last name", vc: self)
        }else{
            updateAccountAPi()
        }
    }
    @IBAction func profileChangeBtn(_ sender: Any) {
        checkCameraAccess()
        alertsheet(title: "Upload", txt: "Please select Image")
    }
    @IBAction func mobileUpdateBtn(_ sender: Any) {
        let mobile = validateNumber(mobileNumberTF.text!)
        if mobileNumberTF.text! == ""
        {
            Alert.showError(title: "Error", message: "Enter mobile number", vc: self)
        }else if mobile == false || mobileNumberTF.text?.count != 10
        {
            Alert.showError(title: "Error", message: "Invalid mobile", vc: self)
        }else if mobileNumberTF.text! == user_list_Dic["telephone"] as! String
        {
            Alert.showError(title: "Error", message: "Please enter another number", vc: self)
        }else{
            change_phonenoOTPAPi()
        }

    }
    @IBAction func emailUpdateBtn(_ sender: Any) {
        let email = validateEmailID(emailID: emailIdTF!.text!)
        if emailIdTF.text! == ""
        {
            Alert.showError(title: "Error", message: "Enter email address", vc: self)
        }else if email == false
        {
            Alert.showError(title: "Error", message: "Invalid email", vc: self)
        }else if emailIdTF.text! == user_list_Dic["email"] as! String
        {
            Alert.showError(title: "Error", message: "Please enter another email", vc: self)
        }else{
            updateEmailAddressAPi()
        }
    }

    @IBAction func backBtn(_ sender: Any) {
        backBtn()
    }
}



//MARK:- Gallery and Camera Access
extension EditProfileViewController
{
    
    // For Checking Camera Access:
    func checkCameraAccess() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .denied:
                print("Denied, request permission from settings")
                presentCameraSettings()
            case .restricted:
                print("Restricted, device owner must approve")
            case .authorized:
                print("Authorized, proceed")
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { success in
                    if success {
                        print("Permission granted, proceed")
                    } else {
                        print("Permission denied")
                    }
                }
        default:
            print("-----")
        }
        }
    
    //For  Camera Settings:
    func presentCameraSettings() {
            let alertController = UIAlertController(title: "Error",
                                          message: "Camera access is denied",
                                          preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .default))
            alertController.addAction(UIAlertAction(title: "Settings", style: .cancel,handler: {
                (UIAlertAction) in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: { _ in
                        // Handle
                    })
                }
            }))
     
            present(alertController, animated: true)
        }
    
        //For Opening Camera:
        func camera()
        {
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                
                let myPickerController = UIImagePickerController()
                myPickerController.delegate = self
                myPickerController.sourceType = .camera
                present(myPickerController, animated: true, completion: nil)
            }else{
                alert(title: "Warning", txt: "No camera found")
            }
            
        }
    
     //For Opening Gallery:
     func photoLibrary()
        {
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                
                let myPickerController = UIImagePickerController()
                myPickerController.delegate = self
                myPickerController.sourceType = .photoLibrary
                present(myPickerController, animated: true, completion: nil)
            }else{
                alert(title: "Warning", txt: "No PhotoLibrary found")
           }
        }
     
   // For event on cancel:
        //Delegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
              self.dismiss(animated: true, completion: nil)
          }
     
    //For set Image on image view:
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
              let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
              //image = img
                profileImage.image = img
                
                //update Profile APi
                let parameters:EIDictonary = ["customer_id": user_id]
                let headers: [String:String] = [
                    "Content-Type": "application/json;charset=UTF-8"
                ]
                uploadPhoto("http://13.127.27.45/dorothy/index.php?route=appapi/customer/profile_image", image: profileImage.image!, params: parameters, header: headers)
                    self.dismiss(animated: true, completion: nil)
        }
    
}

extension EditProfileViewController
{
    func alert(title:String,txt:String){
            let alert = UIAlertController(title: title, message: txt, preferredStyle: .alert)
            let okBtn = UIAlertAction(title: "Ok", style: .destructive, handler: nil)
            alert.addAction(okBtn)
            present(alert, animated: true, completion: nil)
        }
        func alertsheet(title:String,txt:String){
            let alert = UIAlertController(title: title, message: txt, preferredStyle: .actionSheet)
            let Gallary = UIAlertAction(title: "Open Gallery", style: .destructive, handler: {
                (UIAlertAction) in
                self.photoLibrary()
            })
            let camera = UIAlertAction(title: "Open Camera", style: .destructive, handler:{
                (UIAlertAction) in
                self.camera()
            })
            let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler:nil)
            alert.addAction(Gallary)
            alert.addAction(camera)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        }
}


//MARK:- API Calling
extension EditProfileViewController
{
    func updateAccountAPi() -> Void {
    ProgressHud.show()

    let success:successHandler = {  response in
        ProgressHud.hide()
        let json = response as! [String : Any]
        if json["responseCode"] as! Int == 1
        {
            self.backBtn()
            DispatchQueue.main.async {
                self.showToast(message: json["responseText"] as! String, seconds: 2.0)
            }
            

        }else{
            let mess = json["responseText"] as! String
            Alert.showError(title: "Error", message: mess, vc: self)
        }

    }
        
    let failure:failureHandler = { [weak self] error, errorMessage in
        ProgressHud.hide()
        DispatchQueue.main.async {
            Alert.showError(title: "Error", message: errorMessage, vc: self!)
        }
    }
        
    //Calling API
        let parameters:EIDictonary = ["customer_id": user_id,"firstname":firstNameTF.text!,"lastname":lastNameTF.text!]
    
    SERVICE_CALL.sendRequest(parameters: parameters, httpMethod: "POST", methodType: RequestedUrlType.edit_profile, successCall: success, failureCall: failure)
    }
}


//MARK:- API Calling for Profile Image Update
extension EditProfileViewController
{
    
    func uploadPhoto(_ url: String, image: UIImage, params: [String : Any], header: [String:String]) {
       let httpHeaders = HTTPHeaders(header)
       AF.upload(multipartFormData: { multiPart in
           for p in params {
               multiPart.append("\(p.value)".data(using: String.Encoding.utf8)!, withName: p.key)
           }
          multiPart.append(image.jpegData(compressionQuality: 0.4)!, withName: "image", fileName: "file.jpg", mimeType: "image/jpg")
       }, to: url, method: .post, headers: httpHeaders) .uploadProgress(queue: .main, closure: { progress in
           print("Upload Progress: \(progress.fractionCompleted)")
       }).responseJSON(completionHandler: { data in
           print("upload finished: \(data)")
       }).response { (response) in
           switch response.result {
           case .success( _):
                self.backBtn()
                DispatchQueue.main.async {
                    self.showToast(message: "Profile photo changed successfully", seconds: 2.0)
                }
           case .failure(let err):
                showAlertWithOK(title: "Error", message: "\(err)",view : self,actionHandler:{
                self.backBtn()
                })
           }
       }
   }
}

//MARK:- API Calling For Update Mobile Number
extension EditProfileViewController
{
    func change_phonenoOTPAPi() -> Void {
    ProgressHud.show()

    let success:successHandler = {  response in
        ProgressHud.hide()
        let json = response as! [String : Any]
        if json["responseCode"] as! Int == 1
        {            
            let vC = self.storyboard?.instantiateViewController(withIdentifier: "VerifyOtpViewController") as! VerifyOtpViewController
            vC.mobile = self.mobileNumberTF.text!
            vC.country_code = self.country_code
            vC.otp = json["responseData"] as! String
            vC.isLoggedUser = 1
            self.navigationController?.pushViewController(vC, animated: true)
            DispatchQueue.main.async {
                self.showToast(message: json["responseText"] as! String, seconds: 2.0)
            }
        }else{
            let mess = json["responseText"] as! String
            Alert.showError(title: "Error", message: mess, vc: self)
        }

    }
        
    let failure:failureHandler = { [weak self] error, errorMessage in
        ProgressHud.hide()
        DispatchQueue.main.async {
            Alert.showError(title: "Error", message: errorMessage, vc: self!)
        }
    }
        
    //Calling API
        let parameters:EIDictonary = ["code": country_code,"customer_id":user_id, "phone_no":mobileNumberTF.text!]
    
    SERVICE_CALL.sendRequest(parameters: parameters, httpMethod: "POST", methodType: RequestedUrlType.change_phoneno, successCall: success, failureCall: failure)
    }
}


//MARK:- API Calling For Update Email
extension EditProfileViewController
{
    func updateEmailAddressAPi() -> Void {
    ProgressHud.show()

    let success:successHandler = {  response in
        ProgressHud.hide()
        let json = response as! [String : Any]
        if json["responseCode"] as! Int == 1
        {
            self.backBtn()
            DispatchQueue.main.async {
                self.showToast(message: json["responseText"] as! String, seconds: 2.0)
            }
            
        }else{
            let mess = json["responseText"] as! String
            Alert.showError(title: "Error", message: mess, vc: self)
        }

    }
        
    let failure:failureHandler = { [weak self] error, errorMessage in
        ProgressHud.hide()
        DispatchQueue.main.async {
            Alert.showError(title: "Error", message: errorMessage, vc: self!)
        }
    }
        
    //Calling API
        let parameters:EIDictonary = ["customer_id":user_id, "email":emailIdTF.text!]
    
    SERVICE_CALL.sendRequest(parameters: parameters, httpMethod: "POST", methodType: RequestedUrlType.update_email, successCall: success, failureCall: failure)
    }
}



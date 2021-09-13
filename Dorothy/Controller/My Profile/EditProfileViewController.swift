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
    @IBOutlet weak var mobileNumberLabel: UILabel!
    
    @IBOutlet weak var curveView: UIView!
    @IBOutlet weak var emailIDLabel: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var cartBtn: UIBarButtonItem!
    @IBOutlet weak var backView:UIView!
    @IBOutlet weak var profileScrollView: UIScrollView!

    var image = UIImage(named:"no-image")
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground(view: backView)
//        setGradientBackground1()
        firstNameTF.text! = "Biswajit"
        lastNameTF.text! = "Hazari"
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        changeProfilePicBtn.layer.cornerRadius = changeProfilePicBtn.frame.size.width / 2
        changeProfilePicBtn.clipsToBounds = true
        saveBtn.layer.cornerRadius = 25
        curveView.layer.cornerRadius = 100
        curveView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        cartBadgeIcon(qty:"5")
        profileScrollView.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.height {
            scrollView.contentOffset.y = scrollView.contentSize.height - scrollView.bounds.height
        }
    }
}


extension EditProfileViewController
{
    @IBAction func submitBtn(_ sender: Any) {
       
    }
    @IBAction func profileChangeBtn(_ sender: Any) {
        checkCameraAccess()
        alertsheet(title: "Upload", txt: "Please select Image")
    }
    @IBAction func mobileUpdateBtn(_ sender: Any) {
    
    }
//    @IBAction func cartBtn(_ sender: Any) {
//        cartBtn()
//    }
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



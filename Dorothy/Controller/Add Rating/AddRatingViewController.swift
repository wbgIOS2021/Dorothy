//
//  AddRatingViewController.swift
//  Dorothy
//
//  Created by Adarsh Raj on 16/08/21.
//

import UIKit
import Cosmos

class AddRatingViewController: UIViewController,UITextViewDelegate {

    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var reviewTF: UITextView!
    @IBOutlet weak var starRatingBtns: CosmosView!
    var pdDelegate: ProductDetailsDelegate?
    var productId:String = ""
    var review_data: [String:Any] = [:]
    let user_id = (getStringValueFromLocal(key: "user_id") ?? "0")
    let user_name = (getStringValueFromLocal(key: "name") ?? "guest")

    

    override func viewDidLoad() {
        super.viewDidLoad()
        ratingView.dropShadow()
        reviewTF.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        reviewTF.layer.borderWidth = 0.5
        reviewTF.delegate = self
        reviewTF.text = "Write review here..."
        reviewTF.textColor = UIColor.lightGray
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        self.dismiss(animated: true, completion:nil)
    }
    @IBAction func submitBtn(_ sender: Any) {
        addReview()
        self.dismiss(animated: true, completion: nil)
        if let delegate = self.pdDelegate {
            delegate.review(product_id:self.productId)
        }
    }
    
}
extension AddRatingViewController
{
    func textViewDidBeginEditing(_ textView: UITextView) {

        if reviewTF.textColor == UIColor.lightGray {
            reviewTF.text = ""
            reviewTF.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {

        if reviewTF.text == "" {
            reviewTF.text = "Write review here..."
            reviewTF.textColor = UIColor.lightGray
        }
    }
}


//MARK:- API Calling
extension AddRatingViewController
{
    func addReview() -> Void {
        ProgressHud.show()

        let success:successHandler = {  response in
            ProgressHud.hide()
            let json = response as! [String : Any]
            if json["responseCode"] as! Int == 1
            {
                self.showToast(message: json["responseText"] as! String, seconds: 1.5)
                let responseData = json["responseData"] as! [String: Any]

                self.review_data["review_id"] = responseData["review_id"] as! String
                self.review_data["product_id"] = responseData["product_id"] as! String
                self.review_data["customer_id"] = responseData["customer_id"] as! String
                self.review_data["author"] = responseData["author"] as! String
                self.review_data["text"] = responseData["text"] as! String
                self.review_data["rating"] = responseData["rating"] as! String
                self.review_data["status"] = responseData["status"] as! String
                self.review_data["date_added"] = responseData["date_added"] as! String
                self.review_data["date_modified"] = responseData["date_modified"] as! String
            }else{
                self.showToast(message: json["responseText"] as! String, seconds: 1.5)
            }
        }
        
        let failure:failureHandler = { [weak self] error, errorMessage in
            ProgressHud.hide()
            DispatchQueue.main.async {
                showAlertWith(title: "Error", message: errorMessage, view: self!)
            }
        }
        
        //Calling API
        let parameters:EIDictonary = ["product_id":productId,"name":user_name,"review":reviewTF.text!,"rating":starRatingBtns.rating,"customer_id":user_id]
        SERVICE_CALL.sendRequest(parameters: parameters, httpMethod: "POST", methodType: RequestedUrlType.addReview, successCall: success, failureCall: failure)
    }
}

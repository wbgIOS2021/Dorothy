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
    var productId:String = "4"
    

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





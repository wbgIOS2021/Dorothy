//
//  ProductDetailsViewController.swift
//  Dorothy
//
//  Created by Adarsh Raj on 17/07/21.
//

import UIKit
import Cosmos

protocol ProductDetailsDelegate {
    func review(product_id:String)
}

class ProductDetailsViewController: UIViewController, UIPopoverPresentationControllerDelegate, UIScrollViewDelegate {
    
    
    
    // Collection View
    @IBOutlet weak var ratingAndReviewCollectionView: UICollectionView!
    @IBOutlet weak var similarProductCollectionView: UICollectionView!
    
    // Views
    @IBOutlet weak var productDescView: UIView!
    @IBOutlet weak var quantityView: UIView!
    @IBOutlet weak var similarItemsView: UIView!
    @IBOutlet weak var addToCartView: UIView!
    @IBOutlet weak var ratingReviewView: UIView!
    @IBOutlet weak var beTheFirstReview: UIView!
    
    // Labels
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productionSubTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productDesc: UILabel!
    @IBOutlet weak var productSpecialPrice: UILabel!
    @IBOutlet weak var ProductRating: UILabel!

    // Button
    @IBOutlet weak var addReviewView: UIButton!
    @IBOutlet weak var reviewViewAllButton: UIButton!
    @IBOutlet weak var wishlistBtn: UIButton!
    @IBOutlet var leftArrowBtn: UIButton!
    @IBOutlet var rightArrowBtn: UIButton!
    
    // Image
    @IBOutlet weak var productImage: UIImageView!
    
    // Stack View
    @IBOutlet weak var relatedProductStackView: UIStackView!
    
    //  CosmosView
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var cartBtn: UIBarButtonItem!
    @IBOutlet weak var productDetailsScrollView: UIScrollView!
    
    var productId:String = "50"
    var qty = 1
    var isWishlisted = false
    var i : Int = 0
    
    var imagelist = ["food_image3","food_image4","food_image5","food_image6"]
    override func viewDidLoad() {
        super.viewDidLoad()
        addSomeShadow()
        cellRegister()
        similarProductCollectionView.dataSource = self
        similarProductCollectionView.delegate = self
        ratingAndReviewCollectionView.dataSource = self
        ratingAndReviewCollectionView.delegate = self
        quantityLabel.text! = "\(qty)"
        
        beTheFirstReview.isHidden = true
        ratingView.isUserInteractionEnabled = false
        leftArrowBtn.isEnabled = false
        productDetailsScrollView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        self.cartCount()
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
                  scrollView.contentOffset.y = 0
              }
      }
    
    func addSomeShadow()
    {
        addToCartView.layer.cornerRadius = 30
        addToCartView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        productDescView.dropShadow()

        productDescView.layer.cornerRadius = 60
        productDescView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        ratingReviewView.dropShadow()
        quantityView.dropShadow()
        similarItemsView.layer.cornerRadius = 20
        addReviewView.layer.cornerRadius = 20

        quantityLabel.layer.cornerRadius = quantityLabel.frame.size.width / 2
        quantityLabel.clipsToBounds = true
        rightArrowBtn.layer.cornerRadius = rightArrowBtn.frame.size.width / 2
        rightArrowBtn.clipsToBounds = true
        leftArrowBtn.layer.cornerRadius = leftArrowBtn.frame.size.width / 2
        leftArrowBtn.clipsToBounds = true
    }
   
    // Registering cell data
    func cellRegister()
    {
        // Collection view
        similarProductCollectionView.register(UINib(nibName: "ProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductCollectionViewCell")
        ratingAndReviewCollectionView.register(UINib(nibName: "RatingReviewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RatingReviewCollectionViewCell")
    }
    @IBAction func decreaseBtn(_ sender: Any) {
        if qty >= 2
        {
            qty -= 1
            quantityLabel.text! = "\(qty)"
        }
    }
    @IBAction func increaseBtn(_ sender: Any) {
        if qty < 10
        {
            qty += 1
            quantityLabel.text! = "\(qty)"
        }
    }
    
    @IBAction func reviewViewAllBtnAction(_ sender: Any) {
        let vC = storyboard?.instantiateViewController(withIdentifier: "ShowReviewTableViewController") as! ShowReviewTableViewController
        navigationController?.pushViewController(vC, animated: true)
    }
    
    @IBAction func addReviewBtn(_ sender: Any) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let popupVC = storyboard.instantiateViewController(withIdentifier: "AddRatingViewController") as! AddRatingViewController
        popupVC.productId = productId
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.pdDelegate = self
        present(popupVC, animated: true, completion: nil)
    }
    @IBAction func productShareBtn(_ sender: Any) {
        //Set the default sharing message.

        share(message: "Dorothy", link: "link_here")
        }
    
    func share(message: String, link: String) {
        if let link = NSURL(string: link) {
            let objectsToShare = [message,link] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func productWishlistBtn(_ sender: Any) {
        if isWishlisted == true{
            isWishlisted = false
            wishlistBtn.setBackgroundImage(UIImage(named: "empty_heart"), for: .normal)
            }
        else{
            isWishlisted = true
            wishlistBtn.setBackgroundImage(UIImage(named: "fill_heart"), for: .normal)
            }
            
        
        
    }
    @IBAction func addToCartBtn(_ sender: Any) {
        self.showToast(message : "Product added to cart successfully", seconds: 2.0)
    }
    
    @IBAction func similarProductSeeAllBtn(_ sender: Any) {

    }
    
    @IBAction func leftArrowBtn(_ sender: Any) {
        if i == 0{
            leftArrowBtn.isEnabled = false
            productImage.image = UIImage(named: "food_icon2")
        }else{
            leftArrowBtn.isEnabled = true
            if(i > 0)
            {
                i=i-1;
                productImage.image = UIImage(named: imagelist[i])
                rightArrowBtn.isEnabled = true
            }
        }
        
    }
    
    @IBAction func rightArrowBtn(_ sender: Any) {
        
        if i == imagelist.count{
            rightArrowBtn.isEnabled = false
            i=i-1;
        }else{
            rightArrowBtn.isEnabled = true
            if (i < (imagelist.count))
            {
                
                productImage.image = UIImage(named: imagelist[i])
                i=i+1;
                leftArrowBtn.isEnabled = true
            }
            
        }
        
 
    }
    
    
}

//MARK:- Navigation Action Button
extension ProductDetailsViewController
{
    @IBAction func backBtn(_ sender: Any) {
        backBtn()
    }
    
    @IBAction func searchBtn(_ sender: Any) {
        searchBtn()
    }
//    @IBAction func cartBtn(_ sender: Any) {
//        cartBtn()
//    }
}


extension ProductDetailsViewController: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == ratingAndReviewCollectionView
        {
            return 4
        }
        return 5
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == ratingAndReviewCollectionView
        {
            let cell = ratingAndReviewCollectionView.dequeueReusableCell(withReuseIdentifier: "RatingReviewCollectionViewCell", for: indexPath) as! RatingReviewCollectionViewCell
            
            return cell
        }
        let cell = similarProductCollectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as! ProductCollectionViewCell
        
        
        return cell
        
    }
    
}
extension ProductDetailsViewController:UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == ratingAndReviewCollectionView{
            
        }
        if collectionView == similarProductCollectionView{
            let vC = storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
            navigationController?.pushViewController(vC, animated: true)
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                                willDisplay cell: UICollectionViewCell,
                                forItemAt indexPath: IndexPath) {
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


extension ProductDetailsViewController:ProductDetailsDelegate
{
    func review(product_id: String) {
        DispatchQueue.main.async {
//            self.gettingData(productId:product_id)
            print("this")
         }
    }
}

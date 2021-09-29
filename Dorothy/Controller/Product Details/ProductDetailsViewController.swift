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
    @IBOutlet weak var productWeight: UILabel!

    // Button
    @IBOutlet weak var addReviewView: UIButton!
    @IBOutlet weak var reviewViewAllButton: UIButton!
    @IBOutlet weak var wishlistBtn: UIButton!
    @IBOutlet var leftArrowBtn: UIButton!
    @IBOutlet var rightArrowBtn: UIButton!
    @IBOutlet var addToCartBtn: UIButton!
    
    // Image
    @IBOutlet weak var productImage: UIImageView!
    
    // Stack View
    @IBOutlet weak var relatedProductStackView: UIStackView!
    
    //  CosmosView
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var cartBtn: UIBarButtonItem!
    @IBOutlet weak var productDetailsScrollView: UIScrollView!
    
    
    //Arrays
    var productDetails_Array: [String:Any] = [:]
    var imageGallery_Array: [[String:Any]] = []
    var productReviews_Array: [[String:Any]] = []
    var productRelated_Array: [[String:Any]] = []
    var productOptions_Array: [[String:Any]] = []
    var productId:String = ""
    var qty = 0
    var minQty = 0
    var i : Int = 1
    var isStockAvailable = 0
    let user_id = (getStringValueFromLocal(key: "user_id") ?? "0")
  
    override func viewDidLoad() {
        super.viewDidLoad()
        addSomeShadow()
        cellRegister()
        similarProductCollectionView.dataSource = self
        similarProductCollectionView.delegate = self
        ratingAndReviewCollectionView.dataSource = self
        ratingAndReviewCollectionView.delegate = self
        
        beTheFirstReview.isHidden = true
        ratingView.isUserInteractionEnabled = false
        leftArrowBtn.isEnabled = false
        productDetailsScrollView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        gettingData(productId:productId)
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
        if qty > minQty
        {
            qty -= 1
            quantityLabel.text! = "\(qty)"
        }
    }
    
    @IBAction func increaseBtn(_ sender: Any) {
        qty += 1
        quantityLabel.text! = "\(qty)"
        
    }
    
    @IBAction func reviewViewAllBtnAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ShowReviewTableViewController") as! ShowReviewTableViewController
        vc.productId = productId
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func addReviewBtn(_ sender: Any) {
        let isLogin = getStringValueFromLocal(key: "user_id")
        if isLogin != nil{
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let popupVC = storyboard.instantiateViewController(withIdentifier: "AddRatingViewController") as! AddRatingViewController
            popupVC.productId = productId
            popupVC.modalPresentationStyle = .overCurrentContext
            popupVC.pdDelegate = self
            
            present(popupVC, animated: true, completion: nil)
        }else
        {
            goToLogin(title: "Login Required", message: "Please login to add review")
        }
    }
    
    @IBAction func productShareBtn(_ sender: Any) {
        //Set the default sharing message.
        share(message: "Dorothy", link: productDetails_Array["shareLink"] as! String)
        }
    
    func share(message: String, link: String) {
        if let link = NSURL(string: link) {
            let objectsToShare = [message,link] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    
    
    @IBAction func productWishlistBtn(_ sender: Any) {
        
        let success:successHandler = { [self]  response in
            let json = response as! [String : Any]
            if json["responseStatus"] as! String == "1"
            {
                wishlistBtn.setBackgroundImage(UIImage(named: "fill_heart"), for: .normal)
            }else{
                wishlistBtn.setBackgroundImage(UIImage(named: "empty_heart"), for: .normal)
            }
        }

        self.wishlistAction(product_id: self.productDetails_Array["productId"] as! String,actionHandler:success)
        
        
    }
    @IBAction func addToCartBtn(_ sender: Any) {
        if isStockAvailable == 0{
            let success:successHandler = {  response in
                let json = response as! [String : Any]
                if json["responseCode"] as! Int == 1
                {
                    self.showToast(message : json["responseText"] as! String, seconds: 2.0)
                    self.cartCount()
                }else{
                    self.showToast(message : json["responseText"] as! String, seconds: 1.5)
                    self.cartCount()
                }
            }
            self.addCartAction(product_id:productId, quantity:qty,actionHandler:success)
        }
        else{
            self.showToast(message : "Out of Stock", seconds: 1.5)
        }
    }
    

    @IBAction func similarProductSeeAllBtn(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ProductListViewController") as! ProductListViewController
        vc.category_id = productRelated_Array[0]["categoryId"] as! String
        vc.isComeFromProductDetailPage = true
        vc.product_id = productId
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func leftArrowBtn(_ sender: Any) {
        if(i >= 0)
            {
                i=i-1;
                leftArrowBtn.isEnabled = true
                let cellData = imageGallery_Array[i]
                productImage.sd_setImage(with: URL(string: (cellData["thumb_image"] as! String)), placeholderImage: UIImage(named: "no-image"))
                rightArrowBtn.isEnabled = true
                if i == 0{
                    leftArrowBtn.isEnabled = false
                    i = 0
                }
        }
    }
    
    
    @IBAction func rightArrowBtn(_ sender: Any) {
        if (i < (imageGallery_Array.count))
            {
                leftArrowBtn.isEnabled = true
                rightArrowBtn.isEnabled = true
                let cellData = imageGallery_Array[i]
                productImage.sd_setImage(with: URL(string: (cellData["thumb_image"] as! String)), placeholderImage: UIImage(named: "no-image"))
                i=i+1;
                if i == imageGallery_Array.count
                    {
                        rightArrowBtn.isEnabled = false
                        //i=i-1;
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

}


extension ProductDetailsViewController: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == ratingAndReviewCollectionView
        {
            if productReviews_Array.count > 4{
                return 5
            }
            else{
                return productReviews_Array.count
            }
        }
        return productRelated_Array.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == ratingAndReviewCollectionView
        {
            let cell = ratingAndReviewCollectionView.dequeueReusableCell(withReuseIdentifier: "RatingReviewCollectionViewCell", for: indexPath) as! RatingReviewCollectionViewCell
            
            let cellData = productReviews_Array[indexPath.row]
            
            cell.personName.text! = cellData["author"] as! String
            cell.reviewLabel.text! = cellData["text"] as! String
            cell.rating.rating = Double(cellData["rating"] as! String)!
            return cell
        }
        
        let cell = similarProductCollectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as! ProductCollectionViewCell
        let cellData = productRelated_Array[indexPath.row]
        cell.productImage.sd_setImage(with: URL(string: cellData["thumb"] as! String), placeholderImage: UIImage(named: "no-image"))
        
        cell.productName!.text! = cellData["name"] as! String
        let weight = Float(cellData["weight"] as! String)!
        cell.productWeight.text! = " \(weight.clean)" + " \(cellData["weight_type"] as! String)"
        if cellData["special"] as! String == "0.00" || cellData["special"] as! String == "0" || cellData["special"] as! String == cellData["price"] as! String{
            cell.specialPrice!.text! = "$ \(cellData["price"] as! String)"
            cell.productPrice.isHidden = true
        }else{
            cell.productPrice!.text! = "$ \(cellData["price"] as! String)"
            cell.specialPrice!.text! = "$ \(cellData["special"] as! String)"
        }
        
        if cellData["isWishlist"] as! String == "1"{
            cell.likeBtn.setBackgroundImage(UIImage(named: "fill_heart"), for: .normal)
        }else{
            cell.likeBtn.setBackgroundImage(UIImage(named: "empty_heart"), for: .normal)
        }

        if cellData["stockStatusId"] as! String == "7"{
            cell.outOfStockView.isHidden = true
            cell.addToCartBtn.isHidden = false
        }else{
            cell.outOfStockView.isHidden = false
            cell.addToCartBtn.isHidden = true
        }
        cell.likeBtn.tag = indexPath.row
        cell.likeBtn.addTarget(self, action: #selector(self.wishlistCheck), for: .touchUpInside)
        cell.addToCartBtn.tag = indexPath.row
        cell.addToCartBtn.addTarget(self, action: #selector(self.productsAddToCart), for: .touchUpInside)
        return cell
    }
    
    @objc func wishlistCheck(_ sender: UIButton)
    {
        let list =  productRelated_Array[sender.tag]
        let success:successHandler = {  response in
            let json = response as! [String : Any]
            let cell = self.similarProductCollectionView.cellForItem(at: NSIndexPath(row: sender.tag, section: 0) as IndexPath) as! ProductCollectionViewCell
            if json["responseStatus"] as! String == "1"
            {
                cell.likeBtn.setBackgroundImage(UIImage(named: "fill_heart"), for: .normal)
            }else{
                cell.likeBtn.setBackgroundImage(UIImage(named: "empty_heart"), for: .normal)
            }
        }
        self.wishlistAction(product_id: list["productId"] as! String,actionHandler:success)
    }
    
    //Add to cart Action
    @objc func productsAddToCart(_ sender:UIButton)
    {
        let product =  productRelated_Array[sender.tag]
        addCart2(product:product)
    }
    
}
extension ProductDetailsViewController:UICollectionViewDelegate
{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == ratingAndReviewCollectionView{
            
        }
        if collectionView == similarProductCollectionView{
        let vC = storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        vC.productId = productRelated_Array[indexPath.row]["productId"] as! String
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




//MARK:- API Calling
extension ProductDetailsViewController
{
    func gettingData(productId:String) -> Void {
    ProgressHud.show()
    let success:successHandler = {  response in

        let json = response as! [String : Any]
        self.productDetails_Array.removeAll()
        self.imageGallery_Array.removeAll()
        self.productReviews_Array.removeAll()
        self.productRelated_Array.removeAll()
        self.productOptions_Array.removeAll()
        if json["responseCode"] as! Int == 1
        {
            let responseData = json["responseData"] as! [String: Any]
            
            let productId = responseData["productId"] as! String
            let thumb = responseData["thumb"] as! String
            let name = responseData["name"] as! String
            let shareLink = responseData["shareLink"] as! String
            let categoryId = responseData["categoryId"] as! String
            
            let description = responseData["description"] as! String
            let mainPrice = responseData["mainPrice"] as! String
            let price = responseData["price"] as! String
            let special = responseData["special"] as! String
            let tax = responseData["tax"] as! String
            
            let productSaleOff = responseData["productSaleOff"] as! String
            let rating = responseData["rating"] as! String
            let minimum = responseData["minimum"] as! String
            let manufacturer = responseData["manufacturer"] as! String
            let model = responseData["model"] as! String
            let stockInfo = responseData["stockInfo"] as! String
            let stockStatusId = responseData["stockStatusId"] as! String
            let weight = responseData["weight"] as! String
            let weightName = responseData["weightName"] as! String
      
            let isWishlist = responseData["isWishlist"] as! String
            let isPurchase = responseData["isPurchase"] as! String
            let hasReview = responseData["hasReview"] as! String
            let cartCount = responseData["cartCount"] as! String
            let reviwCount = responseData["reviwCount"] as! String

            
            let dic:[String : Any] = ["productId":productId,"thumb":thumb,"name":name,"shareLink":shareLink,"categoryId":categoryId,"description":description,"mainPrice":mainPrice,"price":price,"special":special,"tax":tax,"productSaleOff":productSaleOff,"rating":rating,"minimum":minimum,"manufacturer":manufacturer,"model":model,"stockInfo":stockInfo,"stockStatusId":stockStatusId,"weight":weight,"weightName":weightName,"isWishlist":isWishlist,"isPurchase":isPurchase,"hasReview":hasReview,"cartCount":cartCount,"reviwCount":reviwCount]
            
            self.productDetails_Array = dic
            self.imageGallery_Array.append(["thumb_image":thumb])

            
            _ = responseData["productOptions"] as! [[String:Any]] //
            
            
            //Image Gallery
            let imageGallery = responseData["imageGallery"] as! [[String:Any]]
            for data in imageGallery
            {
                let thumb = data["thumb"] as! String
                let dic = ["thumb_image":thumb]
                self.imageGallery_Array.append(dic)
            }
            
            //Product Reviews
            let productReviews = responseData["productReviews"] as! [[String:Any]]
            for data in productReviews
            {
                let reviewId = data["reviewId"] as! String
                let author = data["author"] as! String
                let text = data["text"] as! String
                let rating = data["rating"] as! String
                
                let dic = ["reviewId":reviewId,"author":author,"text":text,"rating":rating]
                self.productReviews_Array.append(dic)
            }
            
            //Related Product
            let productRelated = responseData["productRelated"] as! [[String:Any]]
            for data in productRelated
            {
                let productId = data["productId"] as! String
                let thumb = data["thumb"] as! String
                let name = data["name"] as! String
                let description = data["description"] as! String
                let price = data["price"] as! String
                let special = data["special"] as! String
                let tax = data["tax"] as! String
                let rating = data["rating"] as! String
                let minimum = data["minimum"] as! String
                let weight = data["weight"] as! String
                let weight_type = data["weight_type"] as! String
                let stockStatusId = data["stockStatusId"] as! String
                let stockStatus = data["stockStatus"] as! String
                let optionCount = data["optionCount"] as! String
                let  isWishlist = data["isWishlist"] as! String
                let categoryId = data["categoryId"] as! String
                let  categoryName = data["categoryName"] as! String
                
                let dic = ["productId":productId,"thumb":thumb,"name":name,"description":description,"price":price,"special":special,"tax":tax,"rating":rating,"minimum":minimum,"weight":weight,"weight_type":weight_type,"stockStatusId":stockStatusId,"stockStatus":stockStatus,"optionCount":optionCount,"isWishlist":isWishlist,"categoryId":categoryId,"categoryName":categoryName]
                self.productRelated_Array.append(dic)
            }
            
                
            //Reloading Table Views And Collection View
            DispatchQueue.main.async
                {
                    self.cartCount() // cartCount
                    ProgressHud.hide()
                    self.applyAPI()
                    if self.productReviews_Array.isEmpty{
                        self.beTheFirstReview.isHidden = false
                        self.reviewViewAllButton.isHidden = true
                    }
                    if self.productReviews_Array.count < 5{
                        self.reviewViewAllButton.isHidden = true
                    }
                    if self.productRelated_Array.isEmpty{
                        self.relatedProductStackView.isHidden = true
                    }
                    
                    self.ratingAndReviewCollectionView.reloadData()
                    self.similarProductCollectionView.reloadData()
                print("IMAGE GALLERY VALUE",self.imageGallery_Array)
                }
        }else{
            print("Comming Soon................................")
        }

        }
        
        let failure:failureHandler = {error, errorMessage in
            ProgressHud.hide()
            DispatchQueue.main.async {
                print("NOT WORKING..............")
            }
        }
        
        //Calling API
        let parameters:EIDictonary = ["product_id": self.productId,"customer_id":user_id,"currency_code": "USD","device_id": "12345ABD"]
        
        SERVICE_CALL.sendRequest(parameters: parameters, httpMethod: "POST", methodType: RequestedUrlType.product_details, successCall: success, failureCall: failure)
    }
}
 
extension ProductDetailsViewController
{
    func applyAPI()
    {
        productImage.sd_setImage(with: URL(string: (productDetails_Array["thumb"] as! String)), placeholderImage: UIImage(named: "no-image"))
        
        productName.text! = productDetails_Array["name"] as! String
        productionSubTitle.text! = productDetails_Array["model"] as! String
        
        if productDetails_Array["special"] as! String == "0.00" || productDetails_Array["special"] as! String == "0" || productDetails_Array["special"] as! String == productDetails_Array["price"] as! String{
            productSpecialPrice.text! = "$ \(productDetails_Array["price"] as! String)"
            productPrice.isHidden = true
        }else{
            productPrice.text! = "$ \(productDetails_Array["price"] as! String)"
            productSpecialPrice.text! = "$ \(productDetails_Array["special"] as! String)"
        }
        
        productDesc.text! = productDetails_Array["description"] as! String
        
        ratingView.rating = Double(productDetails_Array["rating"] as! String)!
        ProductRating.text! = "(\(Double(productDetails_Array["rating"] as! String) ?? 0.0))"
        if productDetails_Array["isWishlist"] as! String == "1"{
            wishlistBtn.setBackgroundImage(UIImage(named: "fill_heart"), for: .normal)
        }else{
            wishlistBtn.setBackgroundImage(UIImage(named: "empty_heart"), for: .normal)
        }
        self.qty = Int(productDetails_Array["minimum"] as! String)!
        self.minQty = Int(productDetails_Array["minimum"] as! String)!
        quantityLabel.text! = "\(qty)"
        
        if productDetails_Array["stockStatusId"] as! String == "7"{
            self.isStockAvailable = 0
            self.addToCartBtn.setTitle("ADD TO CART", for: .normal)
        }else{
            self.isStockAvailable = 1
            self.addToCartBtn.setTitle("Out Of Stock", for: .normal)
        }
        
        let weight = Float(productDetails_Array["weight"] as! String)!
        productWeight.text! = "\(weight.clean)" + " \(productDetails_Array["weightName"] as! String)"
    }
    
}



//Custom Delegate Code
extension ProductDetailsViewController:ProductDetailsDelegate
{
    func review(product_id: String) {
        DispatchQueue.main.async {
            self.gettingData(productId:product_id)
         }
    }
}


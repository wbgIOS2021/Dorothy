//
//  HomeViewController.swift
//  Dorothy
//
//  Created by Adarsh Raj on 02/09/21.
//

import UIKit
import SideMenuSwift
class HomeViewController: UIViewController, UIScrollViewDelegate {
    
    //Tables views and Collection Views
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var beveragesCollectionView: UICollectionView!
    @IBOutlet weak var soupsCollectionView: UICollectionView!
    @IBOutlet weak var grainsCollectionView: UICollectionView!
    @IBOutlet weak var spicySuyaTableView: UITableView!
    @IBOutlet weak var spicesTableView: UITableView!
    @IBOutlet weak var popularTableView: UITableView!
    
    //Stack View
    @IBOutlet weak var beveragesStackView: UIView!
    @IBOutlet weak var soupsStackView: UIView!
    @IBOutlet weak var grainStackView: UIView!
    @IBOutlet weak var spicySuyaStackView: UIView!
    @IBOutlet weak var spicesStackView: UIView!
    @IBOutlet weak var popularStackView: UIView!
    
    // Home Offer Banners
    @IBOutlet weak var spicesBannerImage: UIImageView!
    @IBOutlet weak var soupBannerImage: UIImageView!
    @IBOutlet weak var grainsBannerImage: UIImageView!
    @IBOutlet weak var popularBannerImage: UIImageView!
    
    //Menu Button
    @IBOutlet weak var menuBtn: UIButton!
    
    @IBOutlet weak var iCarouselView: iCarousel!
    
    //TableView Height
    @IBOutlet weak var spicesTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var spicySuyaTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var popularTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var cartBtn: UIButton!
    
    @IBOutlet weak var homeScrollView: UIScrollView!
    @IBOutlet weak var topView: UIView!
    
    //Array declarations
    var home_category_listArray: [[String:Any]] = []
    var home_offer_banner_listArray: [[String:Any]] = []
    var banner_slider_Array: [[String:Any]] = []
    
    var soups_listArray: [[String:Any]] = []
    var grains_listArray: [[String:Any]] = []
    var beverages_listArray: [[String:Any]] = []
    var drinks_listArray: [[String:Any]] = []
    var spices_listArray: [[String:Any]] = []
    var suya_listArray: [[String:Any]] = []
    var picked_items_listArray: [[String:Any]] = []
    
    var timer = Timer()
    var counter = 0
    var bolValue:[Bool] = []
    var cart_count:String = "0"
    var height1:CGFloat = 0.0
    let user_id = (getStringValueFromLocal(key: "user_id") ?? "0")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cellRegister()
        sideMenu()
        iCarouselView.type = .linear
        iCarouselView.isPagingEnabled = true
        //homeBadgeBtn(qty:"0")
        homeScrollView.delegate = self
        //scrollViewDidScroll(scrollView: homeScrollView)
        for _ in 0..<8{
            self.bolValue.append(false)
        }
        
        
    }
    
    
    func sideMenu() {
        SideMenuController.preferences.basic.menuWidth = 300
        SideMenuController.preferences.basic.position = .above
        SideMenuController.preferences.basic.direction = .left
        SideMenuController.preferences.basic.enablePanGesture = true
        SideMenuController.preferences.basic.supportedOrientations = .portrait
        SideMenuController.preferences.basic.shouldRespectLanguageDirection = true
    }
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.contentOffset.y < 0 {
//                  scrollView.contentOffset.y = 0
//              }
//      }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
            gettingData()
        
        //Status Bar
        let topInset: CGFloat = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? UIApplication.shared.statusBarFrame.size.height
        let statusBarView = UIView(frame: CGRect(x: 0, y: 0, width:UIScreen.main.bounds.width, height: topInset))
        
        statusBarView.backgroundColor = #colorLiteral(red: 0.1058823529, green: 0.07450980392, blue: 0.07450980392, alpha: 1)
        self.navigationController?.view.addSubview(statusBarView)
        setNeedsStatusBarAppearanceUpdate()
        
        //Adding Observer
        self.spicesTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.spicySuyaTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.popularTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.handleTimer), userInfo: nil, repeats: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
        
        //Removing Observer
        self.spicesTableView.removeObserver(self, forKeyPath: "contentSize")
        self.spicySuyaTableView.removeObserver(self, forKeyPath: "contentSize")
        self.popularTableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override var prefersStatusBarHidden: Bool{
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //Calling Observer
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if let obj = object as? UIScrollView {
            if obj == self.spicesTableView && keyPath == "contentSize" {
                if let newvalue = change?[.newKey]{
                    let newsize  = newvalue as! CGSize
                    self.spicesTableViewHeight.constant = newsize.height
                }
            }else if obj == self.spicySuyaTableView && keyPath == "contentSize" {
                if let newvalue = change?[.newKey]{
                    let newsize  = newvalue as! CGSize
                    self.spicySuyaTableViewHeight.constant = newsize.height
                }
            }else if obj == self.popularTableView && keyPath == "contentSize" {
                if let newvalue = change?[.newKey]{
                    let newsize  = newvalue as! CGSize
                    self.popularTableViewHeight.constant = newsize.height
                }
            }
        }
    }
    func homeBadgeBtn(qty:String)
    {
        // badge label
        if qty != "0"
        {
          let label = UILabel(frame: CGRect(x: 10, y: -10, width: 15, height: 15))
          label.layer.borderColor = UIColor.clear.cgColor
          label.layer.borderWidth = 2
          label.layer.cornerRadius = label.bounds.size.height / 2
          label.textAlignment = .center
          label.layer.masksToBounds = true
          label.font = UIFont(name: "Poppins-SemiBold", size: 10)
          label.textColor = .white
          label.backgroundColor = .red
          label.text = qty
          cartBtn.addSubview(label)
        }
    }

    // Registering cell data
    func cellRegister()
    {
        // Collection view
        categoriesCollectionView.register(UINib(nibName: "HomeCategoryListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeCategoryListCollectionViewCell")
        
        beveragesCollectionView.register(UINib(nibName: "ProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductCollectionViewCell")
        
        soupsCollectionView.register(UINib(nibName: "ProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductCollectionViewCell")
        
        grainsCollectionView.register(UINib(nibName: "ProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductCollectionViewCell")
        
        //Table view
        spicySuyaTableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductTableViewCell")
        
        spicesTableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductTableViewCell")
        
        popularTableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductTableViewCell")
    }
    
    //Cart Button
    @IBAction func cartBtn(_ sender: Any) {
        cartBtn()
    }
    @IBAction func searchBtn(_ sender: Any) {
        searchBtn()
    }
    
    @IBAction func menuBtn(_ sender: Any) {
        sideMenuController?.revealMenu()
    }
    
    
    
    @IBAction func beveragesSeeAllBtn(_ sender: Any) {
        jumpToProductListpage(title:"Drinks",category_id:"68",index:9)
    }
    
    @IBAction func soupsSeeAllBtn(_ sender: Any) {
        jumpToProductListpage(title:"Soups",category_id:"60",index:0)
    }
    
    @IBAction func grainsSeeAllBtn(_ sender: Any) {
        jumpToProductListpage(title:"Grains",category_id:"61",index:1)
    }
    
    @IBAction func spicySuyaSeeAllBtn(_ sender: Any) {
        jumpToProductListpage(title:"Suya Spices",category_id:"64",index:4)
    }
    
    @IBAction func spicesSeeAllBtn(_ sender: Any) {
        jumpToProductListpage(title:"Spices",category_id:"63",index:3)
    }
    
    @IBAction func popularSeeAllBtn(_ sender: Any) {
        jumpToProductListpage(title:"Picked for you",category_id:"65",index:6)
    }
    
    
    func jumpToProductListpage(title:String,category_id:String,index:Int){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProductListViewController") as! ProductListViewController
        vc.category_listArray = self.home_category_listArray
        vc.title = title
        vc.category_id = category_id
        vc.selectedIndex = index
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == beveragesCollectionView{
            return drinks_listArray.count //value has been changed
        }
        
        if collectionView == soupsCollectionView{
            return soups_listArray.count
        }
        if collectionView == grainsCollectionView{
            return grains_listArray.count
        }
        return home_category_listArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == beveragesCollectionView
        {
            let cell = beveragesCollectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as! ProductCollectionViewCell
            
            let cellData = drinks_listArray[indexPath.row]
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
            cell.likeBtn.addTarget(self, action: #selector(self.beveragesWishlistCheck), for: .touchUpInside)
            cell.addToCartBtn.tag = indexPath.row
            cell.addToCartBtn.addTarget(self, action: #selector(self.beveragesAddToCart), for: .touchUpInside)
            return cell
        }
        
        if collectionView == soupsCollectionView{
            let cell = soupsCollectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as! ProductCollectionViewCell
            
            let cellData = soups_listArray[indexPath.row]
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
            cell.likeBtn.addTarget(self, action: #selector(self.soupsWishlistCheck), for: .touchUpInside)
            cell.addToCartBtn.tag = indexPath.row
            cell.addToCartBtn.addTarget(self, action: #selector(self.soupsAddToCart), for: .touchUpInside)
            
            return cell
        }
        if collectionView == grainsCollectionView{
            let cell = grainsCollectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as! ProductCollectionViewCell
            
            let cellData = grains_listArray[indexPath.row]
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
            cell.likeBtn.addTarget(self, action: #selector(self.grainsWishlistCheck), for: .touchUpInside)
            cell.addToCartBtn.tag = indexPath.row
            cell.addToCartBtn.addTarget(self, action: #selector(self.grainsAddToCart), for: .touchUpInside)
            return cell
        }
        let cell = categoriesCollectionView.dequeueReusableCell(withReuseIdentifier: "HomeCategoryListCollectionViewCell", for: indexPath) as! HomeCategoryListCollectionViewCell
        
        let cellData = home_category_listArray[indexPath.row]
        let yourString = cellData["image"] as! String
        let urlNew:String = yourString.replacingOccurrences(of: " ", with: "%20")
        cell.productImage.sd_setImage(with: URL(string: urlNew), placeholderImage: UIImage(named: "no-image"))
        cell.productName!.text! = cellData["title"] as! String
        if bolValue[indexPath.row]
        {
            cell.productView.layer.backgroundColor = #colorLiteral(red: 0.9971496463, green: 0.8193712831, blue: 0.07595702261, alpha: 1)
            cell.viewProductBtn.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }else{
            cell.productView.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.viewProductBtn.layer.backgroundColor = #colorLiteral(red: 0.9826640487, green: 0.1480134726, blue: 0, alpha: 1)
        }
        return cell
    }
    
    //Add to cart Action in Collection view
    @objc func beveragesAddToCart(_ sender:UIButton)
    {
        let product =  drinks_listArray[sender.tag]
        addCart1(product:product)
    }
    @objc func soupsAddToCart(_ sender:UIButton)
    {
        let product =  soups_listArray[sender.tag]
        addCart1(product:product)
    }
    @objc func grainsAddToCart(_ sender:UIButton)
    {
        let product =  grains_listArray[sender.tag]
        addCart1(product:product)
    }
    func addCart1(product:[String:Any])
    {
        let success:successHandler = {  response in
            let json = response as! [String : Any]
            if json["responseCode"] as! Int == 1
            {
                self.showToast(message: json["responseText"] as! String, seconds: 2.0)
                self.checkCartCount()
                
            }else{
                self.showToast(message: json["responseText"] as! String, seconds: 2.0)
                self.checkCartCount()
            }
        }
        self.addCartAction(product_id:product["product_id"] as! String, quantity:Int(product["minimum"] as! String)!,actionHandler:success)
    }
    
    //Add or remove Wishlist in Collection view
    @objc func beveragesWishlistCheck(_ sender:UIButton)
    {
        let bevervage =  drinks_listArray[sender.tag]
        let success:successHandler = {  response in
            let json = response as! [String : Any]
            let cell = self.beveragesCollectionView.cellForItem(at: NSIndexPath(row: sender.tag, section: 0) as IndexPath) as! ProductCollectionViewCell
            if json["responseStatus"] as! String == "1"
            {
                cell.likeBtn.setBackgroundImage(UIImage(named: "fill_heart"), for: .normal)
            }else{
                cell.likeBtn.setBackgroundImage(UIImage(named: "empty_heart"), for: .normal)
            }
        }
        
        self.wishlistAction(product_id: bevervage["product_id"] as! String,actionHandler:success)
    }
    
    @objc func soupsWishlistCheck(_ sender:UIButton)
    {
        let soups =  soups_listArray[sender.tag]
        let success:successHandler = {  response in
            let json = response as! [String : Any]
            let cell = self.soupsCollectionView.cellForItem(at: NSIndexPath(row: sender.tag, section: 0) as IndexPath) as! ProductCollectionViewCell
            if json["responseStatus"] as! String == "1"
            {
                cell.likeBtn.setBackgroundImage(UIImage(named: "fill_heart"), for: .normal)
            }else{
                cell.likeBtn.setBackgroundImage(UIImage(named: "empty_heart"), for: .normal)
            }
        }
        
        self.wishlistAction(product_id: soups["product_id"] as! String,actionHandler:success)
    }
    
    @objc func grainsWishlistCheck(_ sender:UIButton)
    {
        let grains =  grains_listArray[sender.tag]
        let success:successHandler = {  response in
            let json = response as! [String : Any]
            let cell = self.grainsCollectionView.cellForItem(at: NSIndexPath(row: sender.tag, section: 0) as IndexPath) as! ProductCollectionViewCell
            if json["responseStatus"] as! String == "1"
            {
                cell.likeBtn.setBackgroundImage(UIImage(named: "fill_heart"), for: .normal)
            }else{
                cell.likeBtn.setBackgroundImage(UIImage(named: "empty_heart"), for: .normal)
            }
        }
        self.wishlistAction(product_id: grains["product_id"] as! String,actionHandler:success)
    }

}

//MARK:- Collection View Delegate
extension HomeViewController: UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoriesCollectionView{
            
            if bolValue[indexPath.row]{
                for x in 0..<bolValue.count{
                    if x == indexPath.row{
                        bolValue[x] = true
                    }
                }
            }else{
                for x in 0..<bolValue.count{
                    if x == indexPath.row{
                        bolValue[x] = true
                    }else{
                        bolValue[x] = false
                    }
                }
            }
            categoriesCollectionView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProductListViewController") as! ProductListViewController
                vc.category_listArray = self.home_category_listArray
                vc.title = "\(self.home_category_listArray[indexPath.row]["title"]!)"
                vc.category_id = "\(self.home_category_listArray[indexPath.row]["id"]!)"
                vc.selectedIndex = indexPath.row
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else{
            let vc = storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
            
            if collectionView == beveragesCollectionView{
                vc.productId = drinks_listArray[indexPath.row]["product_id"] as! String
            }
            if collectionView == soupsCollectionView{
                vc.productId = soups_listArray[indexPath.row]["product_id"] as! String
            }
            if collectionView == grainsCollectionView{
                vc.productId = grains_listArray[indexPath.row]["product_id"] as! String
            }
            
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == categoriesCollectionView{
            let cell = categoriesCollectionView.cellForItem(at: indexPath) as? HomeCategoryListCollectionViewCell
            cell?.productView.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell?.viewProductBtn.layer.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.01568627451, blue: 0.01568627451, alpha: 1)
        }
        
    }
     func collectionView(_ collectionView: UICollectionView,
                                 willDisplay cell: UICollectionViewCell,
                                 forItemAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
           UIView.animate(withDuration: 0.8) {
               cell.transform = CGAffineTransform.identity
           }
     }

}


//MARK:- Table View Data Source
extension HomeViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == spicesTableView{
            return spices_listArray.count
        }
        if tableView == popularTableView{
            return picked_items_listArray.count
        }
        return suya_listArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == spicesTableView{
            let cell = spicesTableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as! ProductTableViewCell
            
            let cellData = spices_listArray[indexPath.row]
            cell.productImage.sd_setImage(with: URL(string: cellData["thumb"] as! String), placeholderImage: UIImage(named: "no-image"))
            cell.productName!.text! = cellData["name"] as! String
            let weight = Float(cellData["weight"] as! String)!
            cell.productweight.text! = " \(weight.clean)" + " \(cellData["weight_type"] as! String)"
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
            cell.likeBtn.addTarget(self, action: #selector(self.spicesWishlistCheck), for: .touchUpInside)
            cell.addToCartBtn.tag = indexPath.row
            cell.addToCartBtn.addTarget(self, action: #selector(self.spicesAddToCart), for: .touchUpInside)
            return cell
        }
        if tableView == popularTableView{
            let cell = popularTableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as! ProductTableViewCell
            
            let cellData = picked_items_listArray[indexPath.row]
            cell.productImage.sd_setImage(with: URL(string: cellData["thumb"] as! String), placeholderImage: UIImage(named: "no-image"))
            cell.productName!.text! = cellData["name"] as! String
            let weight = Float(cellData["weight"] as! String)!
            cell.productweight.text! = " \(weight.clean)" + " \(cellData["weight_type"] as! String)"
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
            cell.likeBtn.addTarget(self, action: #selector(self.popularWishlistCheck), for: .touchUpInside)
            cell.addToCartBtn.tag = indexPath.row
            cell.addToCartBtn.addTarget(self, action: #selector(self.popularAddToCart), for: .touchUpInside)
            return cell
        }
        let cell = spicySuyaTableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as! ProductTableViewCell
        
        let cellData = suya_listArray[indexPath.row]
        cell.productImage.sd_setImage(with: URL(string: cellData["thumb"] as! String), placeholderImage: UIImage(named: "no-image"))
        cell.productName!.text! = cellData["name"] as! String
        let weight = Float(cellData["weight"] as! String)!
        cell.productweight.text! = " \(weight.clean)" + " \(cellData["weight_type"] as! String)"
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
        cell.likeBtn.addTarget(self, action: #selector(self.spicySuyaWishlistCheck), for: .touchUpInside)
        cell.addToCartBtn.tag = indexPath.row
        cell.addToCartBtn.addTarget(self, action: #selector(self.spicySuyaAddToCart), for: .touchUpInside)
        return cell
    }
    
    //Add to cart Action in Collection view
    @objc func spicesAddToCart(_ sender:UIButton)
    {
        let product =  spices_listArray[sender.tag]
        addCart1(product:product)
    }
    @objc func popularAddToCart(_ sender:UIButton)
    {
        let product =  picked_items_listArray[sender.tag]
        addCart1(product:product)
        
    }
    @objc func spicySuyaAddToCart(_ sender:UIButton)
    {
        let product =  suya_listArray[sender.tag]
        addCart1(product:product)
    }
    
    //Add or Remove wishlist Action on Table view
    @objc func spicesWishlistCheck(_ sender:UIButton)
    {
        let spices =  spices_listArray[sender.tag]
        let success:successHandler = {  response in
            let json = response as! [String : Any]
            let cell = self.spicesTableView.cellForRow(at: NSIndexPath(row: sender.tag, section: 0) as IndexPath) as! ProductTableViewCell
            if json["responseStatus"] as! String == "1"
            {
                cell.likeBtn.setBackgroundImage(UIImage(named: "fill_heart"), for: .normal)
            }else{
                cell.likeBtn.setBackgroundImage(UIImage(named: "empty_heart"), for: .normal)
            }
        }
        
        self.wishlistAction(product_id: spices["product_id"] as! String,actionHandler:success)
    }
    @objc func popularWishlistCheck(_ sender:UIButton)
    {
        let popular =  picked_items_listArray[sender.tag]
        let success:successHandler = {  response in
            let json = response as! [String : Any]
            let cell = self.popularTableView.cellForRow(at: NSIndexPath(row: sender.tag, section: 0) as IndexPath) as! ProductTableViewCell
            if json["responseStatus"] as! String == "1"
            {
                cell.likeBtn.setBackgroundImage(UIImage(named: "fill_heart"), for: .normal)
            }else{
                cell.likeBtn.setBackgroundImage(UIImage(named: "empty_heart"), for: .normal)
            }
        }
        self.wishlistAction(product_id: popular["product_id"] as! String,actionHandler:success)
    }
    @objc func spicySuyaWishlistCheck(_ sender:UIButton)
    {
        let spicy =  suya_listArray[sender.tag]
        let success:successHandler = {  response in
            let json = response as! [String : Any]
            let cell = self.spicySuyaTableView.cellForRow(at: NSIndexPath(row: sender.tag, section: 0) as IndexPath) as! ProductTableViewCell
            if json["responseStatus"] as! String == "1"
            {
                cell.likeBtn.setBackgroundImage(UIImage(named: "fill_heart"), for: .normal)
            }else{
                cell.likeBtn.setBackgroundImage(UIImage(named: "empty_heart"), for: .normal)
            }
        }
        
        self.wishlistAction(product_id: spicy["product_id"] as! String,actionHandler:success)
    }
    
}

//MARK:- Table View Data Source
extension HomeViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        
        if tableView == spicesTableView{
            vc.productId = spices_listArray[indexPath.row]["product_id"] as! String
        }
        if tableView == popularTableView{
            vc.productId = picked_items_listArray[indexPath.row]["product_id"] as! String
        }
        if tableView == spicySuyaTableView{
            vc.productId = suya_listArray[indexPath.row]["product_id"] as! String
        }
        
        navigationController?.pushViewController(vc, animated: true)
    
    }
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.4) {
            cell.transform = CGAffineTransform.identity
        }
    }
}
    


extension HomeViewController: iCarouselDelegate, iCarouselDataSource
{
    func numberOfItems(in carousel: iCarousel) -> Int {
        banner_slider_Array.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        var imageView: UIImageView!
        if view == nil{
            imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width-30, height: 220))
            imageView.contentMode = .scaleToFill
        }else{
            imageView = view as? UIImageView
        }
        let cellData = banner_slider_Array[index]
        let yourString = cellData["image"] as! String
        let urlNew:String = yourString.replacingOccurrences(of: " ", with: "%20")
        imageView.sd_setImage(with: URL(string: urlNew), placeholderImage: UIImage(named: "no-image"))
        imageView.dropShadow()
        return imageView
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        switch option {
        case .wrap:
            return 1
        case .spacing:
            return 2
        default:
            return value
        }
    }
    @objc func handleTimer() {
        var newIndex = self.iCarouselView.currentItemIndex + 1
        
        if newIndex > self.iCarouselView.numberOfItems {
            newIndex = 0
        }
        
        iCarouselView.scrollToItem(at: newIndex, duration: 0.1)
    }
    
}
//MARK:- Setting Banner Images
extension HomeViewController
{
    func setBannerImage()
    {
        for x in 0..<home_offer_banner_listArray.count{
            let cellData = home_offer_banner_listArray[x]
            if x == 0{
                let yourString = cellData["image"] as! String
                let urlNew:String = yourString.replacingOccurrences(of: " ", with: "%20")
                spicesBannerImage.sd_setImage(with: URL(string: urlNew), placeholderImage: UIImage(named: "no-image"))
            }
            if x == 1
            {
                let yourString = cellData["image"] as! String
                let urlNew:String = yourString.replacingOccurrences(of: " ", with: "%20")
                soupBannerImage.sd_setImage(with: URL(string: urlNew), placeholderImage: UIImage(named: "no-image"))
            }
            if x == 2{
                let yourString = cellData["image"] as! String
                let urlNew:String = yourString.replacingOccurrences(of: " ", with: "%20")
                grainsBannerImage.sd_setImage(with: URL(string: urlNew), placeholderImage: UIImage(named: "no-image"))
            }
            if x == 3
            {
                let yourString = cellData["image"] as! String
                let urlNew:String = yourString.replacingOccurrences(of: " ", with: "%20")
                popularBannerImage.sd_setImage(with: URL(string: urlNew), placeholderImage: UIImage(named: "no-image"))
            }
            
        }
    }
}

//MARK:- API Calling
extension HomeViewController
{
    func gettingData() -> Void {
        ProgressHud.show()
        
        let success:successHandler = { [self]  response in
            
            let json = response as? [String : Any]
            let responseData = json?["responseData"] as! [String : Any]
            self.cart_count = responseData["cart_count"] as! String
            
            //Bottom Table View Api
            let home_category_list = responseData["homeCategoryList"] as? [[String : Any]]
            home_category_listArray.removeAll()
            home_offer_banner_listArray.removeAll()
            banner_slider_Array.removeAll()
            for data in home_category_list!
            {
                let category_id = data["categoryId"] as! String
                let title = data["title"] as! String
                let image = data["image"] as! String
                let dic = ["id":category_id,"title":title,"image":image]
                
                self.home_category_listArray.append(dic)
            }
            
            // All The Banner Present on Home Page
            let home_offer_banner_list = responseData["homeOfferBannerList"] as? [[String : Any]]
            for data in home_offer_banner_list!
            {
                
                let banner_id = data["bannerId"] as! String
                let title = data["title"] as! String
                let image = data["image"] as! String
                let dic = ["banner_id":banner_id,"title":title,"image":image]
                
                self.home_offer_banner_listArray.append(dic)
            }
            
            
            //Upper Slider Api
            let banner_slider = responseData["bannerSlider"] as! [[String:Any]]
            for data in banner_slider
            {
                let banner_id = data["bannerId"] as! String
                let title = data["title"] as! String
                let image = data["image"] as! String
                let dic:[String:Any] = ["banner_id":banner_id,"title":title,"image":image]
                
                self.banner_slider_Array.append(dic)
            }
            
            
            //Block Wise Products Lists
            let category_product_list = responseData["categoryProductList"] as! [String:Any]
            let category_blocks = category_product_list["categoryBlocks"] as? [[String : Any]]
            beverages_listArray.removeAll()
            soups_listArray.removeAll()
            grains_listArray.removeAll()
            spices_listArray.removeAll()
            suya_listArray.removeAll()
            picked_items_listArray.removeAll()
            
            
            for data in category_blocks!
            {
                let category_id = data["categoryId"] as! String
                let category_name = data["categoryName"] as! String
                let products = data["products"] as! [[String:Any]]
                
                for datas in products
                {
                    let product_id = datas["productId"] as! String
                    let thumb = datas["thumb"] as! String
                    
                    let name = datas["name"] as! String
                    let price = datas["price"] as! String
                    
                    let special = datas["special"] as! String
                    let weight_type = datas["weightType"] as! String
                    
                    let weight = datas["weight"] as! String
                    let tax = datas["tax"] as! String
                    
                    let minimum = datas["minimum"] as! String
                    let rating = datas["rating"] as! String
                    
                    let stockStatusId = datas["stockStatusId"] as! String
                    let stockStatus = datas["stockStatus"] as! String
                    
                    let option_count = datas["optionCount"] as! String
                    let isWishlist = datas["isWishlist"] as! String
                    
                    let dic:[String : Any] = ["product_id":product_id,"thumb":thumb,"name":name,"price":price,"special":special,"weight_type":weight_type,"weight":weight,"tax":tax,"minimum":minimum,"rating":rating,"stockStatusId":stockStatusId,"stockStatus":stockStatus,"option_count":option_count,"isWishlist":isWishlist,"category_id":category_id,"category_name":category_name]
                    
                    if category_name == "Spices"
                    {
                        self.spices_listArray.append(dic)
                    }
                    if category_name == "Soups"
                    {
                        self.soups_listArray.append(dic)
                        //self.grains_listArray.append(dic)
                    }
                    if category_name == "Grains"
                    {
                        self.grains_listArray.append(dic)
                    }
                    if category_name == "Beverages"
                    {
                        self.beverages_listArray.append(dic)
                        //self.suya_listArray.append(dic)
                    }
                    if category_name == "Suya"
                    {
                        self.suya_listArray.append(dic)
                    }
                    if category_name == "Picked for you"
                    {
                        self.picked_items_listArray.append(dic)
                    }
                    if category_name == "Drinks"
                    {
                        self.drinks_listArray.append(dic)
                        
                    }
                }
            }
            
            //Reloading Table Views And Collection View
            DispatchQueue.main.async
            {
                //self.drinks_listArray = self.picked_items_listArray
                self.setBannerImage()
                ProgressHud.hide()
                if self.grains_listArray.isEmpty
                {
                    self.grainStackView.isHidden = true
                }
                if self.beverages_listArray.isEmpty
                {
                    self.beveragesStackView.isHidden = true
                }
                if self.drinks_listArray.isEmpty
                {
                    self.beveragesStackView.isHidden = true
                }
                if self.suya_listArray.isEmpty
                {
                    self.spicySuyaStackView.isHidden = true
                }
                if self.spices_listArray.isEmpty
                {
                    self.spicesStackView.isHidden = true
                }
                if self.picked_items_listArray.isEmpty
                {
                    self.popularStackView.isHidden = true
                }
                for _ in 0..<self.home_category_listArray.count{
                    self.bolValue.append(false)
                }
                
                //Cart Icon Change
                
                self.homeBadgeBtn(qty: self.cart_count)
                
                
                self.categoriesCollectionView.reloadData()
                self.beveragesCollectionView.reloadData()
                self.soupsCollectionView.reloadData()
                self.grainsCollectionView.reloadData()
                self.spicySuyaTableView.reloadData()
                self.popularTableView.reloadData()
                self.spicesTableView.reloadData()
                self.iCarouselView.reloadData()
                
            }
            
        }
        
        let failure:failureHandler = { [weak self] error, errorMessage in
            ProgressHud.hide()
            DispatchQueue.main.async {
                // showAlertWith(title: "Error", message: errorMessage, view: self!)
            }
        }
        
        //Calling API
        
        let parameters:EIDictonary = ["currency_code": "USD","customer_id": self.user_id,"device_id": "12345ABD"]
        SERVICE_CALL.sendRequest(parameters: parameters, httpMethod: "POST", methodType: RequestedUrlType.HomePage, successCall: success, failureCall: failure)
    }
}


//Cart Count API
extension HomeViewController
{
    func checkCartCount() -> Void {
    ProgressHud.show()

    let success:successHandler = {  response in
        ProgressHud.hide()
        let json = response as! [String : Any]
        if json["responseCode"] as! Int == 1
        {
            if json["responseData"] as! String != "0"
            {
                self.homeBadgeBtn(qty: json["responseData"] as! String)
            }
        }else{
            ProgressHud.hide()
            
        }
        
    }
        let failure:failureHandler = { [weak self] error, errorMessage in
            ProgressHud.hide()
            DispatchQueue.main.async {
                showAlertWith(title: "Error", message: errorMessage, view: self!)
            }
            
        }
        
        //Calling API
        let parameters:EIDictonary = ["customer_id": getStringValueFromLocal(key: "user_id") ?? "0"]
        
        SERVICE_CALL.sendRequest(parameters: parameters, httpMethod: "POST", methodType: RequestedUrlType.cartCount, successCall: success, failureCall: failure)
       
    }
}

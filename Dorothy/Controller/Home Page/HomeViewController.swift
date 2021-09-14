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
    
    var timer = Timer()
    var counter = 0
    var bolValue:[Bool] = []
    let arrImage = ["banner1","banner2","banner3","banner4","banner5"]
    var category_listArray: [[String:Any]] = [["id": "61","image": "http://13.127.27.45/dorothy/image/cache/catalog/category/rice%201-144x128.png","title": "Grains"],["id": "60","image": "http://13.127.27.45/dorothy/image/cache/catalog/category/soup%201-144x128.png","title": "Soups"],["id": "62","image": "http://13.127.27.45/dorothy/image/cache/catalog/category/beverage%201-144x128.png","title": "Beverages"],["id": "63","image": "http://13.127.27.45/dorothy/image/cache/catalog/category/spice-144x128.png","title": "Spices"],["id": "64","image": "http://13.127.27.45/dorothy/image/cache/catalog/product/img701-144x128.png","title": "Suya Spices"],["id": "59","image": "http://13.127.27.45/dorothy/image/cache/catalog/category/steak-144x128.png","title": "Suya"]]
    override func viewDidLoad() {
        super.viewDidLoad()
        cellRegister()
        sideMenu()
        iCarouselView.type = .linear
        iCarouselView.isPagingEnabled = true
        homeBadgeBtn(qty:"0")
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
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
                  scrollView.contentOffset.y = 0
              }
      }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        
        
        //Status Bar
        let topInset: CGFloat = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? UIApplication.shared.statusBarFrame.size.height
        let statusBarView = UIView(frame: CGRect(x: 0, y: 0, width:UIScreen.main.bounds.width, height: topInset))
        //(int)[UIApplication sharedApplication].statusBarFrame.size.height;
        statusBarView.backgroundColor = #colorLiteral(red: 0.1058823529, green: 0.07450980392, blue: 0.07450980392, alpha: 1)
        self.navigationController?.view.addSubview(statusBarView)
        setNeedsStatusBarAppearanceUpdate()
        
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
    }
    
    @IBAction func soupsSeeAllBtn(_ sender: Any) {
    }
    
    @IBAction func grainsSeeAllBtn(_ sender: Any) {
    }
    
    @IBAction func spicySuyaSeeAllBtn(_ sender: Any) {
    }
    
    @IBAction func spicesSeeAllBtn(_ sender: Any) {
    }
    
    @IBAction func popularSeeAllBtn(_ sender: Any) {
    }
    
}

extension HomeViewController: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == beveragesCollectionView{
            return 2
        }
        
        if collectionView == soupsCollectionView{
            return 4
        }
        if collectionView == grainsCollectionView{
            return 6
        }
        return category_listArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == beveragesCollectionView
        {
            let cell = beveragesCollectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as! ProductCollectionViewCell
            return cell
        }
        
        if collectionView == soupsCollectionView{
            let cell = soupsCollectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as! ProductCollectionViewCell
            
            
            return cell
        }
        if collectionView == grainsCollectionView{
            let cell = grainsCollectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as! ProductCollectionViewCell
            
            
            return cell
        }
        let cell = categoriesCollectionView.dequeueReusableCell(withReuseIdentifier: "HomeCategoryListCollectionViewCell", for: indexPath) as! HomeCategoryListCollectionViewCell
        
        
        let cellData = category_listArray[indexPath.row]
        cell.productImage.sd_setImage(with: URL(string: cellData["image"] as! String), placeholderImage: UIImage(named: "no-image"))
        cell.productName!.text! = cellData["title"] as! String
        
        if bolValue[indexPath.row]
        {
            cell.productView.layer.backgroundColor = #colorLiteral(red: 0.9971496463, green: 0.8193712831, blue: 0.07595702261, alpha: 1)
            cell.viewProductBtn.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            //selectedIndex = indexPath.row
            
        }else{
            cell.productView.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.viewProductBtn.layer.backgroundColor = #colorLiteral(red: 0.9826640487, green: 0.1480134726, blue: 0, alpha: 1)
        }
        return cell
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
                let vC = self.storyboard?.instantiateViewController(withIdentifier: "ProductListViewController") as! ProductListViewController
                vC.category_listArray = self.category_listArray
                vC.title = "\(self.category_listArray[indexPath.row]["title"]!)"
                vC.category_id = "\(self.category_listArray[indexPath.row]["id"]!)"
                vC.selectedIndex = indexPath.row
                self.navigationController?.pushViewController(vC, animated: true)
            }
        }
        else{
            let vC = storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
            navigationController?.pushViewController(vC, animated: true)

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
//        cell.alpha = 0
//        UIView.animate(withDuration: 0.8) {
//            cell.alpha = 1
//        }
    }

}


//MARK:- Table View Data Source
extension HomeViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == spicesTableView{
            return 2
        }
        if tableView == popularTableView{
            return 3
        }
        return 4
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == spicesTableView{
            let cell = spicesTableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as! ProductTableViewCell
            
            
            return cell
        }
        if tableView == popularTableView{
            let cell = popularTableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as! ProductTableViewCell
            
            
            return cell
        }
        let cell = spicySuyaTableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as! ProductTableViewCell
        
                return cell
    }
    
}

//MARK:- Table View Data Source
extension HomeViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vC = storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        navigationController?.pushViewController(vC, animated: true)
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
        arrImage.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        var imageView: UIImageView!
        if view == nil{
            imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width-30, height: 220))
            imageView.contentMode = .scaleToFill
        }else{
            imageView = view as? UIImageView
        }
        imageView.image = UIImage(named: "\(arrImage[index])")
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

//
//  ShowReviewTableViewController.swift
//  Dorothy
//
//  Created by Adarsh Raj on 24/08/21.
//

import UIKit

class ShowReviewTableViewController: UITableViewController {
    
    var productReviews_Array: [[String:Any]] = []
    var productId:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        gettingReviews()
        title = "Rating and Reviews"
        
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        cartCount()
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSection: NSInteger = 1
            if productReviews_Array.count > 0 {
                self.tableView.backgroundView = nil
                  numOfSection = 1
            } else {
                let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
                noDataLabel.text = "No Review Available"
                noDataLabel.textColor = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
                noDataLabel.textAlignment = NSTextAlignment.center
                self.tableView.backgroundView = noDataLabel
            }
            return numOfSection
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productReviews_Array.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RatingTableViewCell", for: indexPath) as! RatingTableViewCell
        
        let cellData = productReviews_Array[indexPath.row]
        cell.userLabel!.text! = cellData["author"] as! String
        cell.rating.rating = Double(cellData["rating"] as! String)!
        cell.reviewText!.text! = cellData["text"] as! String
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMMM dd, yyyy"

        let date: NSDate? = dateFormatterGet.date(from: cellData["date_added"] as! String) as NSDate?
        cell.added_date!.text! = "\(dateFormatterPrint.string(from: date! as Date))"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
       UIView.animate(withDuration: 0.8) {
           cell.transform = CGAffineTransform.identity
       }
    cell.alpha = 0
        UIView.animate(withDuration: 0.8) {
            cell.alpha = 1
        }
   }
    @IBAction func backBtn(_ sender: Any) {
        backBtn()
    }
}


//MARK:- API Calling
extension ShowReviewTableViewController
{
    func gettingReviews() -> Void {
        ProgressHud.show()
        let success:successHandler = {  response in

        let json = response as! [String : Any]
        self.productReviews_Array.removeAll()
        if json["responseCode"] as! Int == 1
        {
            let responseData = json["responseData"] as? [[String : Any]]
            for data in responseData!
                {
                    let review_id = data["review_id"] as! String
                    let product_id = data["product_id"] as! String
                    let customer_id = data["customer_id"] as! String
                    let author = data["author"] as! String
                    let text = data["text"] as! String
                    let rating = data["rating"] as! String
                    let status = data["status"] as! String
                    let date_added = data["date_added"] as! String
                    let date_modified = data["date_modified"] as! String
                
                let dic:[String : Any] = ["review_id":review_id,"product_id":product_id,"customer_id":customer_id,"author":author,"text":text,"rating":rating,"status":status,"date_added":date_added,"date_modified":date_modified]

                    self.productReviews_Array.append(dic)
                }
                
                //Reloading Table Views And Collection View
                DispatchQueue.main.async
                {
                    ProgressHud.hide()
                    self.tableView.reloadData()
                }
        }else{
            ProgressHud.hide()
            print("Comming Soon................................")
        }
    }
        let failure:failureHandler = { error, errorMessage in
            ProgressHud.hide()
            DispatchQueue.main.async {
                print("Not Working All Review API")
            }
        }
        
        //Calling API
        let parameters:EIDictonary = ["product_id": productId]
        
        SERVICE_CALL.sendRequest(parameters: parameters, httpMethod: "POST", methodType: RequestedUrlType.all_review, successCall: success, failureCall: failure)
    }
}


//
//  Services.swift
//  LearnSomeNewCoding
//
//  Created by Adarsh Raj on 23/07/21.
//

import Foundation
import UIKit
import Alamofire

typealias successHandler = (Any?) -> Void
typealias successHandlers = (Any?) -> Void
typealias failureHandler = (Error?, String) -> Void


enum RequestedUrlType: String {

    case HomePage = "homepage"
    
    case product_details = "product_details"
    case all_review = "get_product_based_review"
    case addReview = "add_review"
    case get_similar_product = "get_similar_product"
        
    case user_login = "main_login"
    case user_register = "register"
    case sendOTP = "send_otp"
    case verifyOTP = "otp_verify"
    case forgot_password = "forgot_password"
        
    case view_profile = "myAccount"
    case edit_profile = "editAccount"
    case update_profile = "profile_image"
    case change_phoneno = "change_phoneno"
    case change_mobile_otp_verify = "mobile_otp_verify"
    case update_email = "update_email"
    case change_password = "change_password"
    
    case gettingAddress = "getAddress"
    case deleteAddress = "deleteAddress"
    case countryList = "countryList"
    case stateList = "stateList"
    case addAddress = "addressAdd"
    case updateAddress = "addressUpdate"
    
    case wishlist_products = "my_wishlist"
    case addRemoveWishlist = "add_remove_wishlist"
    
    case cart_list = "cart_list"
    case removeCart = "cart_data_delete"
    case addToCart = "add_to_cart_new"
    case updateCart = "update_to_cart"
    case cartCount = "cart_total_quantity"
    
    case checkout = "checkout"
    
    case makeOrder = "make_order"
    case orderList = "order_list"
    case orderDetails = "order_details"
    case return_reason_list = "return_reason_list"
    case return_order = "return_order"
    
    case category_list = "category_list"
    case category_wise_product = "category_wise_product"

    case searchProduct = "search_product"
    
    case pageLists = "page_list"
    case pageDescription = "page_desc"
    
    case contact_us = "contact_us"
    
    
}

class ServiceCall: NSObject
{
   
    static let kServerURL = "http://13.127.27.45/dorothy/index.php?route=" //URL

    static var mmm : DataRequest?
    
    
    let genericError = "Opps..Somthing went wrong."
    
    var sessionManager:URLSession?
    
    var storedSuccess:successHandler?
    var storedfailure:failureHandler?
  
    class var sharedInstance: ServiceCall {
        struct Singleton {
            static let instance = ServiceCall()
        }
        return Singleton.instance
    }
    
    override init() {
        self.sessionManager = URLSession.shared
    }
    
    
    
    
func sendRequest(parameters:[String : Any],httpMethod:String ,methodType:RequestedUrlType,successCall:@escaping successHandler,failureCall:@escaping failureHandler) -> Void
{
    let serverURL = self.getRequestedURL(url: methodType.rawValue,dictParam: parameters)
    let headers: HTTPHeaders = [
        "Content-Type": "application/json;charset=UTF-8"
    ]
    if httpMethod == "GET" {
        ServiceCall.mmm = AF.request(serverURL, method:.get, parameters: nil,encoding: JSONEncoding.default, headers: headers)
        
    }else if httpMethod == "POST"{
            ServiceCall.mmm = AF.request(serverURL, method: .post, parameters: parameters)

    }else if httpMethod == "PUT"{
            ServiceCall.mmm = AF.request(serverURL, method:.put, parameters: parameters,encoding: JSONEncoding.default,headers: headers)
  
    }
    else if httpMethod == "DELETE"{
            ServiceCall.mmm = AF.request(serverURL, method:.delete, parameters: parameters,encoding: JSONEncoding.default,headers: headers)
  
    }
    ServiceCall.mmm?.responseJSON { (response) in
        
           // print(response)
        
        switch response.result {
                      case .success(let data):
                          //print("Ok: \(data)")
                        successCall(response.value)
                          
                      case .failure(let error):
                        print(error.localizedDescription)
                        failureCall(nil, error.localizedDescription)
                      }
    }
}
    func getRequestedURL(url:String, dictParam: EIDictonary) -> String{
        var urlString = "";
        switch url {
        
        
        
        case RequestedUrlType.HomePage.rawValue:
            urlString = ServiceCall.kServerURL + "appapi/product/homepage";
            
        case RequestedUrlType.product_details.rawValue:
            urlString = ServiceCall.kServerURL + "appapi/product/product_details";
        case RequestedUrlType.all_review.rawValue:
            urlString = ServiceCall.kServerURL + "appapi/product/get_all_product_reviews";
        case RequestedUrlType.addReview.rawValue:
            urlString = ServiceCall.kServerURL + "appapi/product/add_rating";
        case RequestedUrlType.get_similar_product.rawValue:
            urlString = ServiceCall.kServerURL + "appapi/product/get_all_similar_products";
            
        case RequestedUrlType.user_login.rawValue:
            urlString = ServiceCall.kServerURL + "appapi/home/main_login";
        case RequestedUrlType.user_register.rawValue:
            urlString = ServiceCall.kServerURL + "appapi/customer/add";
        case RequestedUrlType.sendOTP.rawValue:
            urlString = ServiceCall.kServerURL + "appapi/home/login";
        case RequestedUrlType.verifyOTP.rawValue:
            urlString = ServiceCall.kServerURL + "appapi/home/otp_verify";
        case RequestedUrlType.forgot_password.rawValue:
            urlString = ServiceCall.kServerURL + "appapi/customer/forget_password";
        
        case RequestedUrlType.cartCount.rawValue:
            urlString = ServiceCall.kServerURL + "appapi/cart/cart_total_quantity";
            
        case RequestedUrlType.view_profile.rawValue:
            urlString = ServiceCall.kServerURL + "appapi/customer/myAccount";
        case RequestedUrlType.edit_profile.rawValue:
            urlString = ServiceCall.kServerURL + "appapi/customer/editAccount";
        case RequestedUrlType.update_profile.rawValue:
            urlString = ServiceCall.kServerURL + "appapi/customer/profile_image";
        case RequestedUrlType.change_phoneno.rawValue:
            urlString = ServiceCall.kServerURL + "appapi/customer/change_phoneno";
        case RequestedUrlType.change_mobile_otp_verify.rawValue:
            urlString = ServiceCall.kServerURL + "appapi/customer/mobile_otp_verify";
        case RequestedUrlType.update_email.rawValue:
            urlString = ServiceCall.kServerURL + "appapi/customer/update_customer_email";
        case RequestedUrlType.change_password.rawValue:
            urlString = ServiceCall.kServerURL + "appapi/customer/change_password";
            
        case RequestedUrlType.gettingAddress.rawValue:
            urlString = ServiceCall.kServerURL + "appapi/address/getAddress";
        case RequestedUrlType.deleteAddress.rawValue:
            urlString = ServiceCall.kServerURL + "appapi/address/deleteAddress";
        case RequestedUrlType.countryList.rawValue:
            urlString = ServiceCall.kServerURL + "appapi/customer/countryList";
        case RequestedUrlType.stateList.rawValue:
            urlString = ServiceCall.kServerURL + "appapi/customer/stateList";
        case RequestedUrlType.addAddress.rawValue:
            urlString = ServiceCall.kServerURL + "appapi/address/addressAdd";
        case RequestedUrlType.updateAddress.rawValue:
            urlString = ServiceCall.kServerURL + "appapi/address/addressUpdate";
            
        case RequestedUrlType.wishlist_products.rawValue:
            urlString = ServiceCall.kServerURL + "appapi/wishlist/my_wishlist";
        case RequestedUrlType.addRemoveWishlist.rawValue:
            urlString = ServiceCall.kServerURL + "appapi/wishlist/add";
            
        case RequestedUrlType.cart_list.rawValue:
            urlString = ServiceCall.kServerURL + "appapi/cart/cart_list";
        case RequestedUrlType.removeCart.rawValue:
            urlString = ServiceCall.kServerURL + "appapi/cart/cart_data_delete";
        case RequestedUrlType.addToCart.rawValue:
            urlString = ServiceCall.kServerURL + "appapi/cart/add_to_cart_new";
        case RequestedUrlType.updateCart.rawValue:
            urlString = ServiceCall.kServerURL + "appapi/cart/update_to_cart";
        case RequestedUrlType.cartCount.rawValue:
            urlString = ServiceCall.kServerURL + "appapi/cart/cart_total_quantity";
        case RequestedUrlType.checkout.rawValue:
            urlString = ServiceCall.kServerURL + "appapi/cart/checkOut";
         
        case RequestedUrlType.makeOrder.rawValue:
            urlString = ServiceCall.kServerURL + "appapi/order/make_order";
        case RequestedUrlType.orderList.rawValue:
            urlString = ServiceCall.kServerURL + "appapi/order/order_list";
        case RequestedUrlType.orderDetails.rawValue:
            urlString = ServiceCall.kServerURL + "appapi/order/order_details";
        case RequestedUrlType.return_reason_list.rawValue:
            urlString = ServiceCall.kServerURL + "appapi/product/return_reason_list";
        case RequestedUrlType.return_order.rawValue:
            urlString = ServiceCall.kServerURL + "appapi/product/order_return";
            
        case RequestedUrlType.category_list.rawValue:
            urlString = ServiceCall.kServerURL + "appapi/home/category_list";
        case RequestedUrlType.category_wise_product.rawValue:
            urlString = ServiceCall.kServerURL + "appapi/product/category_wise_product";
            
        case RequestedUrlType.searchProduct.rawValue:
            urlString = ServiceCall.kServerURL + "appapi/product/productSearch";
            
        case RequestedUrlType.pageLists.rawValue:
            urlString = ServiceCall.kServerURL + "appapi/home/page_list";
        case RequestedUrlType.pageDescription.rawValue:
            urlString = ServiceCall.kServerURL + "appapi/home/page_description";
            
        case RequestedUrlType.contact_us.rawValue:
            urlString = ServiceCall.kServerURL + "information/contact/send_mail";
        default:
            print("Default value")
        
        }
        return urlString
    }
    
}





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
    case user_login = "main_login"
    case user_register = "register"
    case sendOTP = "send_otp"
    case verifyOTP = "otp_verify"
    
    case cartCount = "cart_total_quantity"
    
    case view_profile = "myAccount"
    case edit_profile = "editAccount"
    case update_profile = "profile_image"
    case change_phoneno = "change_phoneno"
    case change_mobile_otp_verify = "mobile_otp_verify"
}

class ServiceCall: NSObject
{
   
    static let kServerURL = "http://13.127.27.45/dorothy/index.php?route=appapi" //URL

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
            urlString = ServiceCall.kServerURL + "/product/homepage";
            
        case RequestedUrlType.user_login.rawValue:
            urlString = ServiceCall.kServerURL + "/home/main_login";
        case RequestedUrlType.user_register.rawValue:
            urlString = ServiceCall.kServerURL + "/customer/add";
        case RequestedUrlType.sendOTP.rawValue:
            urlString = ServiceCall.kServerURL + "/home/login";
        case RequestedUrlType.verifyOTP.rawValue:
            urlString = ServiceCall.kServerURL + "/home/otp_verify";
        
        case RequestedUrlType.cartCount.rawValue:
            urlString = ServiceCall.kServerURL + "/cart/cart_total_quantity";
            
        case RequestedUrlType.view_profile.rawValue:
            urlString = ServiceCall.kServerURL + "/customer/myAccount";
        case RequestedUrlType.edit_profile.rawValue:
            urlString = ServiceCall.kServerURL + "/customer/editAccount";
        case RequestedUrlType.update_profile.rawValue:
            urlString = ServiceCall.kServerURL + "/customer/profile_image";
        case RequestedUrlType.change_phoneno.rawValue:
            urlString = ServiceCall.kServerURL + "/customer/change_phoneno";
        case RequestedUrlType.change_mobile_otp_verify.rawValue:
            urlString = ServiceCall.kServerURL + "/customer/mobile_otp_verify";

        default:
            print("Default value")
        
        }
        return urlString
    }
    
}





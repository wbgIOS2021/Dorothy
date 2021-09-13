//
//  AlertMessages.swift
//  Dorothy
//
//  Created by Adarsh Raj on 29/07/21.
//

import UIKit

class Alert
{
    static func showError(title: String, message: String, vc: UIViewController){
        let alertView = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        
      
        let btn = UIAlertAction.init(title: "ok", style: .cancel, handler: nil)
            alertView.addAction(btn)
         vc.present(alertView, animated: true, completion: nil)
    }
    
}

typealias alertActionHandler = () -> Void
func showAlertWithOK(title: String, message: String,view : UIViewController,actionHandler:@escaping alertActionHandler) -> Void {
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let OKAction = UIAlertAction(title: "OK", style: .default,handler :{
        (UIAlertAction) in
        actionHandler()
    })
    alert.addAction(OKAction)
    view.present(alert, animated: true, completion: nil)
}

func showAlertWithCancel(title: String, message: String,view : UIViewController,actionHandler:@escaping alertActionHandler) -> Void {
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let OKAction = UIAlertAction(title: "OK", style: .default,handler :{
        (UIAlertAction) in
        actionHandler()
    })
    let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
    alert.addAction(cancelAction)
    alert.addAction(OKAction)
    view.present(alert, animated: true, completion: nil)
}

func showAlertWith(title: String, message: String,view : UIViewController) -> Void {
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alert.addAction(OKAction)
    view.present(alert, animated: true, completion: nil)
}


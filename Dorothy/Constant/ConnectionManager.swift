//
//  ConnectionManager.swift
//  Dorothy
//
//  Created by Adarsh Raj on 29/09/21.
//

import Foundation

class NetworkListner : NSObject {

static  let shared = NetworkListner()

var reachabilityStatus: Reachability.Connection = .unavailable
let reachability = try! Reachability()
    var isNetAvailable = false
var isNetworkAvailable : Bool {
    return reachabilityStatus != .unavailable
}



func startNWListner() {
    
    NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
    
    reachability.whenReachable = { reachability in
        if reachability.connection == .wifi {
            print("Reachable via WiFi")
            
        } else {
            print("Reachable via Cellular")
        }
        self.isNetAvailable = true
    }
    reachability.whenUnreachable = { _ in
        print("Not reachable")
        self.isNetAvailable = false
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let conVC = storyboard.instantiateViewController(withIdentifier: "NoInternetViewController") as? NoInternetViewController,
            let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
            
            navController.pushViewController(conVC, animated: true)
        }
    }
    
    do {
        try reachability.startNotifier()
    } catch {
        print("Unable to start notifier")
    }
}

@objc func reachabilityChanged(note: Notification) {
    
    let reachability = note.object as! Reachability
    
    switch reachability.connection {
    case .wifi:
        print("Reachable via WiFi")
        isNetAvailable = true
    case .cellular:
        print("Reachable via Cellular")
        isNetAvailable = true
    case .unavailable:
         isNetAvailable = false
        print("Network not reachable")
    case .none:
        print("Network none")
    }
 }


}

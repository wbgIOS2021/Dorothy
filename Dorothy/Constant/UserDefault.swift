//
//  UserDefault.swift
//  Dorothy
//
//  Created by Adarsh Raj on 29/07/21.
//

import Foundation
public func saveStringOnLocal(key:String,value:String)
{
    UserDefaults.standard.set(value, forKey: key)
    UserDefaults.standard.synchronize()
}
public func getStringValueFromLocal(key:String) -> String?
{
    return UserDefaults.standard.string(forKey: key)
}

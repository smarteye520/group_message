//
//  Utility.swift
//  group_message
//
//  Created by Smart Eye on 3/24/20.
//  Copyright © 2020 personal. All rights reserved.
//

import Foundation
import UIKit

let DEVICE_TOKEN = "device-token"
let USER_GROUP = "user-groups"
let USER_MESSAGE = "user-messages"

class Utility: NSObject {
    
    class func saveStringToUserDefaults (value: String, key: String){
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func getStringFromUserDefaults(key: String) ->String{
        let val = UserDefaults.standard.value(forKey: key)
        if(val == nil){
            return ""
        }
        return val as! String
    }
    
    class func saveArrayToUserDefaults(value: [String?], key: String){
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func getArrayFromUserDefaults(key: String) -> [String?] {
        let val = UserDefaults.standard.value(forKey: key)
        if(val == nil){
            return []
        }
        return val as! [String?]
    }
    
    class func saveDictionaryToUserDefaults(value: [[String: Any?]], key: String){
           UserDefaults.standard.set(value, forKey: key)
           UserDefaults.standard.synchronize()
       }
    
    class func getDictionaryFromUserDefaults(key: String) -> [[String: Any?]] {
        let val = UserDefaults.standard.value(forKey: key)
        if(val == nil){
            return []
        }
        return val as! [[String: Any?]]
    }       
       
}


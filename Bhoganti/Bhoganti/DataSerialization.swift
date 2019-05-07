//
//  DataSerialization.swift
//  bhoganti
//
//  Created by Nascenia on 1/16/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

import Foundation

class DataSerialization {
    var brandName:String?
    var commentText:String?
    var rating:Int?
    var anonymous:Bool?
    var uid:String?
    var userName:String?
    
    init(brandName:String, rating:Int, commentText:String, anonymous:Bool, userName:String){
        self.brandName = brandName
        self.rating = rating
        self.commentText = commentText
        self.anonymous = anonymous
        if let uid = NSUserDefaults.standardUserDefaults().objectForKey("uid") as? String {
            self.uid = uid
        }
        if !userName.isEmpty {
            self.userName = userName
        }else{
            self.userName = "Anonymous"
        }
    }
    
    func createDictionary () -> NSDictionary{
        var Dictionary : NSMutableDictionary = NSMutableDictionary()
        
        var brand : NSMutableDictionary = NSMutableDictionary()
        brand.setValue(self.brandName!, forKey: "name")
        
        var comment : NSMutableDictionary = NSMutableDictionary()
        comment.setValue(self.commentText!, forKey: "text")
        comment.setValue(self.rating!, forKey: "rating")
        comment.setValue(self.anonymous!, forKey: "is_anonymous")
        
        var device : NSMutableDictionary = NSMutableDictionary()
        device.setValue(self.uid, forKey: "uid")
        device.setValue(self.userName, forKey: "username")
        
        Dictionary.setValue(brand, forKey: "brand")
        Dictionary.setValue(comment, forKey: "comment")
        Dictionary.setValue(device, forKey: "device")
        
        return Dictionary
    }
    
    func toJson() -> NSData! {
        var jsonCreationError:NSError?
        var convertableData : NSDictionary = self.createDictionary()
        let json:NSData = NSJSONSerialization.dataWithJSONObject(convertableData, options: NSJSONWritingOptions.PrettyPrinted, error: &jsonCreationError)!
        
        if jsonCreationError != nil {
            ShowAlert.alertWithMessage("Error!", message: "\(jsonCreationError)", buttons: "Ok")
        } else {
            return json
            //return String(data: json, encoding: NSUTF8StringEncoding)!
        }
        return nil
    }
}





   
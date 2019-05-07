//
//  Settings.swift
//  externalDBandAPICall
//
//  Created by Nascenia on 1/6/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

import Foundation

class Settings {
    var schema = "http://"
    var host = "www.bhoganti.com"
    
    func searchBrandByKeyword()-> String{
        return schema + host + "/api/brand/search?keyword="
    }
    
    func postComment()-> String{
        return schema + host + "/api/comment/create"
    }
    
    func registerDevice() -> String {
        return schema + host + "/api/device/register"
    }
    
    func getComments (id:Int) -> String{
        return schema + host + "/api/brand/\(id)/comments"
    }
    
    func getBrandList()->String{
        if NSUserDefaults.standardUserDefaults().objectForKey("last_modified") != nil {
            var last_modified_date = NSUserDefaults.standardUserDefaults().objectForKey("last_modified") as! String
            return schema + host + "/api/brand/list?last_access=" + last_modified_date
        } else {
            return schema + host + "/api/brand/list?last_access="
        }
    }
}
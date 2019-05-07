//
//  registerDevice.swift
//  bhoganti
//
//  Created by Nascenia on 1/13/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

import Foundation

class RegisterDevice {
    var getService:GetService!
    var settings:Settings!
    
    init(){
        getUserData()
    }
    
    func getUserData (){
        self.settings = Settings()
        self.getService = GetService()
        self.getService.apiCallToGet(self.settings.registerDevice(), callback: {
            (response) in
            if let data = response["data"] as? NSDictionary {
                if let uid = data["uid"] as? String{
                    NSUserDefaults.standardUserDefaults().setObject(uid, forKey: "uid")
                }
                if let username = data["username"] as? String{
                    NSUserDefaults.standardUserDefaults().setObject(username, forKey: "username")
                }
                NSUserDefaults.standardUserDefaults().synchronize()
            }
        })
    }
}
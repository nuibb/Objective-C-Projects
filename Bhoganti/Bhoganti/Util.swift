//
//  Util.swift
//  DemoProject
//
//  Created by Krupa-iMac on 24/07/14.
//  Copyright (c) 2014 TheAppGuruz. All rights reserved.
//

import UIKit

class Util: NSObject {
    
    class var sharedInstance : Util {
        struct Static {
            static let instance : Util = Util()
        }
        return Static.instance
    }
    
    var databaseName:String {
        return "BRANDS.db"
    }
    
    var fileManager:NSFileManager {
        return NSFileManager.defaultManager()
    }
    
    func getDatabasePath() -> String {
        return NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0].stringByAppendingPathComponent(self.databaseName as String)
    }
    
    func getDatabase() -> AnyObject! {
        return FMDatabase(path: self.getDatabasePath())
    }
}
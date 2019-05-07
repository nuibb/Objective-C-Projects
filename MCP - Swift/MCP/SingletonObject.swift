//
//  SingletonObject.swift
//  MCP
//
//  Created by Nascenia on 5/15/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

import Foundation

class Singleton {
    var locationsHolder = [[String: AnyObject]]()
    
    class var sharedInstance : Singleton {
        struct Static {
            static let instance : Singleton = Singleton()
        }
        return Static.instance
    }
    
    var gpsLocations : [[String: AnyObject]] {
        get{
            return self.locationsHolder
        }
    }
}

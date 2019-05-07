//
//  SingletonBrandName.swift
//  Bhoganti
//
//  Created by Nascenia on 2/12/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

import Foundation

class Singleton {
    var name : String = ""
    class var sharedInstance : Singleton {
        struct Static {
            static let instance : Singleton = Singleton()
        }
        return Static.instance
    }
    
    var brandName : String {
        get{
            return self.name
        }
        
        set {
            self.name = newValue
        }
    }
}

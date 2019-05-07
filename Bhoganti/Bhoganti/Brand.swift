//
//  Brand.swift
//  bhoganti
//
//  Created by Nascenia on 1/12/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

import Foundation

class Brand {
    var id:Int
    var rating:Int
    var no_of_comments:String
    var name:String
    var aliases:NSArray
    
    init(id:Int, rating:Int, no_of_comments:String, name:String, aliases:NSArray){
        self.id = id
        self.rating = rating
        self.no_of_comments = no_of_comments
        self.name = name
        self.aliases = aliases
    }
    
    func getBrandName() -> String {
        return self.name
    }
}
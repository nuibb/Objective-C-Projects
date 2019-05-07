//
//  Comments.swift
//  bhoganti
//
//  Created by Nascenia on 1/13/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

import Foundation

class CommentsList {
    var rating:Int!
    var name:String!
    var text:String!
    
    init(rating:Int, name:String, text:String){
        self.rating = rating
        self.name = name
        self.text = text
    }
}
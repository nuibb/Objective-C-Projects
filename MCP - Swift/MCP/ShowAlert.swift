//
//  ShowAlert.swift
//  bhoganti
//
//  Created by Nascenia on 1/29/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

import UIKit

class ShowAlert {
    class func alertWithMessage(title:String, message:String, buttons:String){
        var alert : UIAlertView = UIAlertView()
        alert.title = title
        alert.message = message
        alert.addButtonWithTitle(buttons)
        alert.show()
    }
}
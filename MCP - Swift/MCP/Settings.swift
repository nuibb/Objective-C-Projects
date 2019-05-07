//
//  Settings.swift
//  MCP
//
//  Created by Nascenia on 5/15/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

import Foundation

class Settings {
    var schema = "http://"
    //var host = "sms.mcp.com/iPhone/trajectory.php?shipId=22"
    var host = "console.mcp.com"
    
    func getCoordinates()-> String{
        //return schema + host + "/iPhone/trajectory.php?shipId=22"
        return schema + host + "/mtracking.php?ship=25"//22/25/23
    }
}


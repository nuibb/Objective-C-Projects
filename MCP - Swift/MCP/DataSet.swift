//
//  DataSet.swift
//  MCP
//
//  Created by Nascenia on 5/15/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

import Foundation

extension String {
    func toDouble() -> Double? {
        return NSNumberFormatter().numberFromString(self)?.doubleValue
    }
}

class DataSet{
    var settings : Settings!
    var getService : GetService!
    var currentLocation : [String: AnyObject]!
    
    //Object initialization for API call
    init(){
        self.settings = Settings()
        self.getService = GetService()
    }
    
    func getCurrentLocation(callback:([String: AnyObject]) -> ()){
        self.getService.apiCallToGet(self.settings.getCoordinates(), callback: {
            (response) in
            var location = [String: AnyObject]()
            
            for item in response {
                if let dictionary = item as? NSDictionary {
                    
                    if let lat = dictionary["Lat"] as? String {
                        if lat.toDouble() != nil {
                            location["latitude"] = lat.toDouble()!
                        }
                    }
                    
                    if let long = dictionary["Long"] as? String {
                        if long.toDouble() != nil {
                            location["longitude"] = long.toDouble()!
                        }
                    }
                    
                    if let name = dictionary["Name"] as? String {
                        location["locationName"] = name
                    }
                    
                    if let territory = dictionary["Territory"] as? String {
                        location["territory"] = territory
                    }
                    
                    //println(location)
                    
                    if self.currentLocation != nil {
                        if ((self.currentLocation["latitude"] as? Double) != (location["latitude"] as? Double)) && ((self.currentLocation["longitude"] as? Double) != (location["longitude"] as? Double)){
                            
                            self.currentLocation = location
                            callback(location)
                        }
                    } else {
                        self.currentLocation = location
                        callback(location)
                    }
                }
            }
        })
    }
    
    //Make API call to get location co-ordinates from server
    func getCoordinates(callback:() -> ()){
        self.getService.apiCallToGet(self.settings.getCoordinates(), callback: {
            (response) in
            //println(response)
            var location = [String: AnyObject]()
            
            for item in response {
                if let dictionary = item as? NSDictionary {
                    
                    if let lat = dictionary["Lat"] as? String {
                        if lat.toDouble() != nil {
                            location["latitude"] = lat.toDouble()!
                        }
                    }
                    
                    if let long = dictionary["Long"] as? String {
                        if long.toDouble() != nil {
                            location["longitude"] = long.toDouble()!
                        }
                    }
                    
                    if let name = dictionary["Name"] as? String {
                        location["locationName"] = name
                    }
                    
                    if let territory = dictionary["Territory"] as? String {
                        location["territory"] = territory
                    }
                    
                    /*
                    // Add gps location to the singleton object's array if the consecutive coordinate is different
                    // and update location on the map view in app lifetime
                    */
                    
                    //callback(location)
                    
                    if let previous = Singleton.sharedInstance.gpsLocations.last {
                        //println(previous["latitude"]!)
                        //println(previous["longitude"]!)
                        println(location["latitude"]!)
                        println(location["longitude"]!)
                        if ((previous["latitude"] as? Double) != (location["latitude"] as? Double)) && ((previous["longitude"] as? Double) != (location["longitude"] as? Double)){
                            Singleton.sharedInstance.locationsHolder.append(location)
                            
                        }
                    } else {
                        Singleton.sharedInstance.locationsHolder.append(location)
                    }
                }
            }
            //return callback function to update mapview with annotations
             callback()
        })
    }
}
//
//  DataManager.swift
//  MCP
//
//  Created by Nascenia on 5/18/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

import Foundation

/*
// Implementing Composite design pattern through the custom delegation object
// Notify map view when the GPS location of ship has changed
*/
protocol DelegateForMakeCoordinates {
    func locationsHolderHasBeenUpdated(array:[[String: AnyObject]])
}

protocol DelegateForUpdateCurrentLocation {
    func currentLocationHasBeenUpdated(location:[String: AnyObject])
}


/*
// Implementing Facade design pattern through the DataManager object to hide internal complexity of other API calls
*/
class DataManager {
    var dataSet : DataSet!
    var delegate1: DelegateForMakeCoordinates?
    var delegate2: DelegateForUpdateCurrentLocation?
    var gpsLocations : [[String: AnyObject]]!
    
    //Initialization with gps locations
    init() {
        self.dataSet = DataSet()
    }
    
    //To get gps locations
    func getGPSLocations(){
        self.dataSet.getCoordinates({
            (response) in
            //println(response)
            self.gpsLocations = Singleton.sharedInstance.gpsLocations
            self.delegate1?.locationsHolderHasBeenUpdated(self.gpsLocations)
        })
    }
    
    //To get ship's current gps location
    func getCurrentLocation(){
        self.dataSet.getCurrentLocation({
            (response) in
            self.delegate2?.currentLocationHasBeenUpdated(response)
        })
    }
    
    //Get all the coordinates
    func getLocationHistory(){
       // self.dataSet.getCoordinates(<#callback: ([String : AnyObject]) -> ()##([String : AnyObject]) -> ()#>)
        self.dataSet.getCoordinates({
            () in
            dispatch_async(dispatch_get_main_queue()){
                self.gpsLocations = Singleton.sharedInstance.gpsLocations
                self.delegate1?.locationsHolderHasBeenUpdated(self.gpsLocations)
            }
        })
    }
}
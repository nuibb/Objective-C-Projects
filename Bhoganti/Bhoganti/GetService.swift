//
//  GetService.swift
//  bhoganti
//
//  Created by Nascenia on 1/16/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

import Foundation

class GetService {
    func apiCallToGet(url:String, callback:(NSDictionary) -> ()){
        if Reachability.isConnectedToNetwork(){
            if let validUrl = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
                self.request(validUrl, callback: callback)
            }
        }else{
            ShowAlert.alertWithMessage("Warning!", message: "Your Internet connection seems to be offline. Please connect your device to Internet.", buttons: "Ok")
        }
    }
    
    func request(url:String, callback:(NSDictionary) -> ()){
        var nsURL = NSURL(string: url)
        let task = NSURLSession.sharedSession().dataTaskWithURL(nsURL!){
            (data, response, error) in
            
            //If error occur, log the error to the console
            if (error != nil){
                //println(error!.localizedDescription)
                if error!.domain == "NSURLErrorDomain" {
                    dispatch_async(dispatch_get_main_queue()){
                        ShowAlert.alertWithMessage("Warning!", message: "\(self.showMsgToErrorDomain(error!.code))", buttons: "Ok")
                        callback(["isFailed":true])
                    }
                }
            }
            
            var error:NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as? NSDictionary
            // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
            if(error == nil) {
                // The JSONObjectWithData constructor didn't return an error. But, we should still
                // check and make sure that json has a value using optional binding.
                if let parseJSON = json {
                    callback(parseJSON)
                } else {
                    // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                    dispatch_async(dispatch_get_main_queue()){
                        let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                        ShowAlert.alertWithMessage("Error!", message: "Could not parse JSON for : '\(jsonStr!)'", buttons: "Ok")
                    }
                }
            }
        }
        task.resume()
    }
    
    func showMsgToErrorDomain(code:Int) -> String{
        switch code {
        case -1000:
            return "You are currently accessing with a bad url. Please check your domain server."
        case -1001:
            return "Request timeout. Please try again later."
        case -1002:
            return "You are currently accessing with a unsupported url. Please check your domain server."
        case -1003:
            return "Can not find the host server. Please try again later."
        case -1004:
            return "Can not connect to host server. Please try again later."
        case -1005:
            return "Your Internet connection is lost. Please try again later."
        case -1006:
            return "Can not find the host server. Please try again later."
        case -1009:
            return "Your Internet connection seems to be offline. Please connect your device to Internet."
        case -1012:
            return "Authenticaion failed. Please try again later."
        case -1013:
            return "Authenticaion failed. Please try again later."
        default:
            return "Something went wrong. Please try again later."
        }
    }
}

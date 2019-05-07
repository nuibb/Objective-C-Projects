//
//  PostService.swift
//  bhoganti
//
//  Created by Nascenia on 1/16/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

import Foundation

class PostService {
    func apiCallToPost(url:String, serializedData: NSData, callback:(NSDictionary) -> ()){
        var request = NSMutableURLRequest(URL:NSURL(string: url)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        var err: NSError?
        request.HTTPBody = serializedData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) -> Void in
            // If error occur, log the error to the console
            if (error != nil){
                //println(error!.localizedDescription)
                if error!.domain == "NSURLErrorDomain" {
                    dispatch_async(dispatch_get_main_queue()){
                        ShowAlert.alertWithMessage("Warning!", message: "\(self.showMsgToErrorDomain(error!.code))", buttons: "Ok")
                    }
                }
            }
            
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSDictionary
            
            // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
            if(err == nil) {
                // The JSONObjectWithData constructor didn't return an error. But, we should still
                // check and make sure that json has a value using optional binding.
                if let parseJSON = json {
                    callback(parseJSON)
                } else {
                    // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                    dispatch_async(dispatch_get_main_queue()){
                        let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                        ShowAlert.alertWithMessage("Error!", message: "Could not parse JSON for : '\(jsonStr)'", buttons: "Ok")
                    }
                }
            }
        })
        task.resume()
    }
    
    func showMsgToErrorDomain(code:Int) -> String{
        switch code {
        case -1000:
            return "You are currently accessing with a bad url. Please check your domain server."
        case -1001:
            return "Server request timeout. Please try again later."
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

//
//  DataSet.swift
//  bhoganti
//
//  Created by Nascenia on 1/15/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

import Foundation

class DataSet {
    var settings:Settings!
    var getService:GetService!
    var postService:PostService!
    
    init(){
        settings = Settings()
        getService = GetService()
        postService = PostService()
    }
    
    func brandList(callback:(brandCollection:[BrandListItem], aliaseCollection:[BrandAliaseItem])->Void){
        getService.apiCallToGet(settings.getBrandList(), callback: {
            (response) in
            if (response["isFailed"] as? Bool != nil) {
               // println("Yes")
            }else{
                var brandCollection = [BrandListItem]()
                var aliaseCollection = [BrandAliaseItem]()
                if let data = response["data"] as? NSDictionary {
                    if let brands = data["brands"] as? NSArray {
                        for brand in brands {
                            if let Obj_brand = brand as? NSDictionary {
                                var id = Obj_brand["id"]! as! Int
                                var name = Obj_brand["name"]! as! String
                                brandCollection.append(BrandListItem(id: id, name: name))
                                if let aliases = Obj_brand["aliases"] as? NSArray{
                                    for aliaseItem in aliases{
                                        if let aliaseName = aliaseItem["name"] as? String{
                                            aliaseCollection.append(BrandAliaseItem(brandId: id, aliaseName: aliaseName))
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if let last_modified_date = data["last_modified"] as? String{
                        NSUserDefaults.standardUserDefaults().setObject(last_modified_date, forKey: "last_modified")
                    }
                }
                callback(brandCollection:brandCollection, aliaseCollection:aliaseCollection)
            }
        })
    }
    
    func searchByKeyword (keyword:String, callback:(brandDetailsList:[Brand])->Void){
        getService.apiCallToGet(settings.searchBrandByKeyword() + keyword, callback: {
            (response) in
            var brandList = [Brand]()
            if let data = response["data"] as? NSDictionary {
                if let brands = data["brands"] as? NSArray {
                    for item in brands {
                        if let brand = item as? NSDictionary{
                            var id = brand["id"]! as! Int
                            var rating = brand["average_rating"]! as! Int
                            var no_of_comments = brand["number_of_comments"]! as! String
                            var name = brand["name"]! as! String
                            var aliases = brand["aliases"]! as! NSArray
                            var currentBrand = Brand(id: id, rating: rating, no_of_comments: no_of_comments as String, name: name, aliases: aliases)
                            brandList.append(currentBrand)
                        }
                    }
                }
            }
            callback(brandDetailsList:brandList)
        })
    }
    
    func loadComments(id:Int,  completion:(comments:[CommentsList])->Void){
        getService.apiCallToGet(settings.getComments(id), callback: {
            (response) in
            var commentsList = [CommentsList]()
            if let data = response["data"] as? NSDictionary {
                if let comments = data["comments"] as? NSArray{
                    for item in comments {
                        if let comment = item as? NSDictionary{
                            var rating = comment["rating"]! as! Int
                            var name = comment["device"]!["username"]!as! String
                            var text = comment["text"]! as! String
                            var Obj_comment = CommentsList(rating: rating, name: name, text: text)
                            commentsList.append(Obj_comment)
                        }
                    }
                }
            }
            completion(comments:commentsList)
        })
    }
    
    func postComment(data:NSData, callback:(Int)->Void) {
        if Reachability.isConnectedToNetwork(){
            postService.apiCallToPost(settings.postComment(), serializedData: data, callback: {
                (response) in
                
                if let status = response["status"] as? String {
                    if status == "success" {
                        if let data = response["data"] as? NSDictionary {
                            if let brand = data["brand"] as? NSDictionary {
                                if let id = brand["id"] as? Int {
                                    callback(id)
                                }
                            }
                        }
                    }else{
                        if let msg = response["message"] as? String {
                            dispatch_async(dispatch_get_main_queue()){
                                ShowAlert.alertWithMessage("Message!", message: "User name is already exists. Please try another.", buttons: "Ok")
                            }
                        }
                    }
                }
            })
        }else{
            ShowAlert.alertWithMessage("Warning!", message: "Your Internet connection seems to be offline. Please connect your device to Internet.", buttons: "Ok")
        }
    }
}
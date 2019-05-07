//
//  DataManager.swift
//  Bhoganti
//
//  Created by Nascenia on 2/5/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

import Foundation

class DataManager {
    var dataSet:DataSet!
    var databaseModel:DatabaseModel!
    var brandCollection = [BrandListItem]()
    var aliaseCollection = [BrandAliaseItem]()
    
    class var sharedInstance : DataManager {
        struct Static {
            static let instance : DataManager = DataManager()
        }
        return Static.instance
    }
    
    //Return brand name if brand id and aliase id is same, otherwise empty
    func isBrandExist(id:Int)->String{
        for brand in self.brandCollection {
            if id == brand.id {
                return brand.name
            }
        }
        return ""
    }
    
    init(){
        //DataSet Initialization
        databaseModel = DatabaseModel()
        dataSet = DataSet()
        
        //If database file is not exist in the desired path
        if !Util.sharedInstance.fileManager.fileExistsAtPath(Util.sharedInstance.getDatabasePath()){
            //Create database tables
            databaseModel.createDBTable()
            
            //Fill database tables with json data from external server API call
            dataSet.brandList {
                (brandCollection, aliaseCollection) in
                self.brandCollection = brandCollection
                self.aliaseCollection = aliaseCollection
                self.databaseModel.insertIntoBrandListTable(brandCollection)
                self.databaseModel.insertIntoBrandAliasesTable(aliaseCollection)
            }
        }else{
            //Get data from database to in memory as brandCollection and aliaseCollection array
            brandCollection = databaseModel.getAllBrandsFromBrandListTable()
            aliaseCollection = databaseModel.getAliasesFromBrandAliasesTable()
            
            //Update databases with latest brand from external server
            dataSet.brandList {
                (brandCollection, aliaseCollection) in
                var newBrands = [BrandListItem]()
                var newAliases = [BrandAliaseItem]()
                for brand in brandCollection {
                    var brandName = self.isBrandExist(brand.id)
                    if brandName.isEmpty{
                        self.brandCollection.append(brand)
                        newBrands.append(brand)
                    }
                    
                    for aliase in aliaseCollection{
                        if let aliaseItem = self.isNewAliaseName(aliase) as? BrandAliaseItem{
                            newAliases.append(aliaseItem)
                        }
                    }
                }
                self.databaseModel.insertIntoBrandListTable(newBrands)
                self.databaseModel.insertIntoBrandAliasesTable(newAliases)
            }
        }
    }
    
    //If new aliase name added to a brand then add it the aliaseCollection array
    func isNewAliaseName(aliase:BrandAliaseItem)->AnyObject!{
        let results = self.aliaseCollection.filter { $0.aliaseName == aliase.aliaseName }
        if results.isEmpty{
            self.aliaseCollection.append(aliase)
            return aliase
        }
        return nil
    }
    
    deinit{
        self.brandCollection.removeAll(keepCapacity: false)
        self.aliaseCollection.removeAll(keepCapacity: false)
        self.dataSet = nil
        self.databaseModel = nil
    }
}
//
//  DatabaseModel.swift
//  bhoganti
//
//  Created by Nascenia on 1/21/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

import Foundation

class DatabaseModel:NSObject {
    var contactDB:FMDatabase!
    override init(){
        if let contactDB = Util.sharedInstance.getDatabase() as? FMDatabase {
            self.contactDB = contactDB
        }
    }
    
    func createDBTable() {
        if self.contactDB.open() {
            let brandTable = "CREATE TABLE IF NOT EXISTS BRANDLIST (brandId INTEGER PRIMARY KEY, brandName TEXT)"
            if !self.contactDB.executeStatements(brandTable) {
                ShowAlert.alertWithMessage("Error!", message: self.contactDB.lastErrorMessage(), buttons: "Ok")
            }
            
            let brandAliasesTable = "CREATE TABLE IF NOT EXISTS BRANDALIASES (aliasId INTEGER PRIMARY KEY AUTOINCREMENT, aliase_brand_id INTEGER, aliaseName TEXT, FOREIGN KEY (aliase_brand_id) REFERENCES BRANDLIST (brandId))"
            if !self.contactDB.executeStatements(brandAliasesTable) {
                ShowAlert.alertWithMessage("Error!", message: self.contactDB.lastErrorMessage(), buttons: "Ok")
            }
            self.contactDB.close()
        } else {
            ShowAlert.alertWithMessage("Error!", message: self.contactDB.lastErrorMessage(), buttons: "Ok")
        }
    }
    
    func insertIntoBrandListTable(brandList:[BrandListItem]){
        if self.contactDB.open() {
            for brand in brandList {
                let result = contactDB.executeUpdate("INSERT INTO BRANDLIST (brandId, brandName) VALUES (?, ?)",
                    withArgumentsInArray: [brand.id, brand.name])
                if !result {
                    ShowAlert.alertWithMessage("Error!", message: self.contactDB.lastErrorMessage(), buttons: "Ok")
                }
            }
            self.contactDB.close()
        }else{
            ShowAlert.alertWithMessage("Error!", message: self.contactDB.lastErrorMessage(), buttons: "Ok")
        }
    }
    
    func insertIntoBrandAliasesTable(aliaseList:[BrandAliaseItem]){
        if self.contactDB.open() {
            for aliaseItem in aliaseList {
                let result = contactDB.executeUpdate("INSERT INTO BRANDALIASES (aliase_brand_id, aliaseName) VALUES (?, ?)",
                    withArgumentsInArray: [aliaseItem.brandId, aliaseItem.aliaseName])
                if !result {
                    ShowAlert.alertWithMessage("Error!", message: self.contactDB.lastErrorMessage(), buttons: "Ok")
                }
            }
            self.contactDB.close()
        }else{
            ShowAlert.alertWithMessage("Error!", message: self.contactDB.lastErrorMessage(), buttons: "Ok")
        }
    }
    
    func getAllBrandsFromBrandListTable()->[BrandListItem]{
        if self.contactDB.open() {
            var brandCollection = [BrandListItem]()
            var resultSet: FMResultSet!  = contactDB.executeQuery("SELECT brandId, brandName FROM BRANDLIST",
                withArgumentsInArray: nil)
            if resultSet != nil {
                while resultSet.next() {
                    var brandId = resultSet!.stringForColumn("brandId").toInt()!
                    var brandName = resultSet.stringForColumn("brandName")!
                    brandCollection.append(BrandListItem(id: brandId, name: brandName))
                }
            }
            contactDB.close()
            return brandCollection
        }else{
            ShowAlert.alertWithMessage("Error!", message: self.contactDB.lastErrorMessage(), buttons: "Ok")
        }
        return []
    }
    
    func getAliasesFromBrandAliasesTable()->[BrandAliaseItem]{
        if self.contactDB.open() {
            var aliaseCollection = [BrandAliaseItem]()
            var resultSet: FMResultSet!  = contactDB.executeQuery("SELECT aliase_brand_id as brandId, aliaseName FROM BRANDALIASES",
                withArgumentsInArray: nil)
            if resultSet != nil {
                while resultSet.next() {
                    var brandId = resultSet!.stringForColumn("brandId").toInt()!
                    var aliaseName = resultSet.stringForColumn("aliaseName")!
                    aliaseCollection.append(BrandAliaseItem(brandId: brandId, aliaseName: aliaseName))
                }
            }
            contactDB.close()
            return aliaseCollection
        }else{
            ShowAlert.alertWithMessage("Error!", message: self.contactDB.lastErrorMessage(), buttons: "Ok")
        }
        return []
    }
    
    /*func getAllBrands(){
        if self.contactDB.open() {
            let querySQL = "SELECT BRANDLIST.brandId as id, BRANDLIST.brandName as name, BRANDALIASES.aliaseName as aliase FROM BRANDLIST INNER JOIN BRANDALIASES ON (BRANDLIST.brandId=BRANDALIASES.aliase_brand_id)"
            var resultSet: FMResultSet!  = contactDB.executeQuery(querySQL,
                withArgumentsInArray: nil)
            if resultSet != nil {
                while resultSet.next() {
                    var id = resultSet!.stringForColumn("id")!
                    var name = resultSet.stringForColumn("name")!
                    var aliase = resultSet.stringForColumn("aliase")!
                    ShowAlert.alertWithMessage("Error!", message: "id : \(id)  name :  \(name)   aliase : \(aliase)", buttons: "Ok")
                }
            }else {
                ShowAlert.alertWithMessage("Error!", message: self.contactDB.lastErrorMessage(), buttons: "Ok")
            }
            contactDB.close()
        }else{
            ShowAlert.alertWithMessage("Error!", message: self.contactDB.lastErrorMessage(), buttons: "Ok")
        }
    }*/
    
    /*func deleteTables(){
        if self.contactDB.open() {
            if !self.contactDB.executeUpdate("DROP TABLE IF EXISTS BRANDLIST", withArgumentsInArray: nil) {
                ShowAlert.alertWithMessage("Error!", message: self.contactDB.lastErrorMessage(), buttons: "Ok")
            }
            
            if !self.contactDB.executeUpdate("DROP TABLE IF EXISTS BRANDALIASES", withArgumentsInArray: nil) {
                ShowAlert.alertWithMessage("Error!", message: self.contactDB.lastErrorMessage(), buttons: "Ok")
            }
            self.contactDB.close()
        }
    }*/
}

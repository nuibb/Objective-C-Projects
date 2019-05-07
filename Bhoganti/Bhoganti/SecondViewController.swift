//
//  SecondViewController.swift
//  Bhoganti
//
//  Created by Nascenia on 2/4/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate {
    var dataSet:DataSet!
    var brandCollection = [BrandListItem]()
    var aliaseCollection = [BrandAliaseItem]()
    var brandsToCompare = [Brand]()
    var currentSearchDataArray = [String]()
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Do any additional setup after loading the view, typically from a nib.
        self.indicator!.hidden = true
        self.indicator!.activityIndicatorViewStyle = .Gray
        self.indicator!.color = UIColor.purpleColor()
        //self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        //Get data from database to show suggestions on searchbar
        self.dataSet = DataSet()
        let dataManager = DataManager.sharedInstance
        self.brandCollection = dataManager.brandCollection
        self.aliaseCollection = dataManager.aliaseCollection
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool{
        //Clearing current search data array for new search key filtering
        self.currentSearchDataArray.removeAll(keepCapacity: false)
        
        //If search bar text is not empty
        if !searchString.isEmpty{
            if count(searchString) >= 2 {
                self.dataSet.searchByKeyword(searchString, callback: {
                    (brandDetails) in
                    for item in brandDetails {
                        var flag : Bool = false
                        for brand in self.brandCollection {
                            if item.id == brand.id {
                                flag = true
                                break
                            }
                        }
                        
                        if !flag {
                            var brand = BrandListItem(id: item.id, name: item.name)
                            self.brandCollection.append(brand)
                            self.currentSearchDataArray.append(brand.name)
                            dispatch_async(dispatch_get_main_queue()){
                                self.searchDisplayController!.searchResultsTableView.reloadData()
                            }
                        }
                    }
                })
            }
            
            //Add all brand matching to new search key from brand collection to the current search data array
            for brand in self.brandCollection {
                if brand.name.lowercaseString.rangeOfString(searchString.lowercaseString) != nil {
                    self.currentSearchDataArray.append(brand.name)
                }
            }
            
            //Add a brand matching to new search key from aliase collection to the current search data array by avoiding duplication
            for aliase in self.aliaseCollection {
                if aliase.aliaseName.lowercaseString.rangeOfString(searchString.lowercaseString) != nil {
                    var brandName = self.isBrandExist(aliase.brandId)
                    if !brandName.isEmpty{
                        if !contains(self.currentSearchDataArray, brandName){
                            self.currentSearchDataArray.append(brandName)
                        }
                    }
                }
            }
        }
        
        return true
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
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        //searchBar.resignFirstResponder()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return self.currentSearchDataArray.count
        } else {
            return self.brandsToCompare.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Check to see whether the normal table or search results table is being displayed and set the Brand object from the appropriate array
        if tableView == self.searchDisplayController!.searchResultsTableView {
            let cell = UITableViewCell()
            let brandName = self.currentSearchDataArray[indexPath.row] as String
            cell.textLabel?.text = brandName as String
            return cell
            //cell.tag = brand.id
        } else {
            let cell: TulonaCell = self.tableView.dequeueReusableCellWithIdentifier("Tulona", forIndexPath: indexPath) as! TulonaCell
            var brand = self.brandsToCompare[indexPath.row] as Brand
            cell.setCustomCellForTulona(brand.name, rating: brand.rating, NoOfComment: brand.no_of_comments)
            return cell
        }
    }
    
    //Check if a brand is exist in comparison list for SecondViewController
    func hasValue(id:Int) -> Bool {
        for brand in self.brandsToCompare{
            if id == brand.id {
                return true
            }
        }
        return false
    }
    
    func reloadTableView(keyword:String){
        self.indicator.hidden = false
        self.indicator.startAnimating()
        self.dataSet.searchByKeyword(keyword, callback: {
            (brandDetailsList) in
            for item in brandDetailsList {
                if !self.hasValue(item.id) {
                    if self.brandsToCompare.count < 3 {
                        self.brandsToCompare.insert(item, atIndex: 0)
                    }else {
                        self.brandsToCompare.removeLast()
                        self.brandsToCompare.insert(item, atIndex: 0)
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue()){
                self.tableView.reloadData()
                self.indicator.stopAnimating()
                self.indicator.hidden = true
            }
        })
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == self.searchDisplayController!.searchResultsTableView {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as UITableViewCell!
            if cell!.textLabel!.text != nil {
                self.searchDisplayController!.setActive(false, animated: true)
                self.reloadTableView(cell!.textLabel!.text!)
            }
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var dekhunScene = segue.destinationViewController as! ThirdViewController
        let indexPath = self.tableView.indexPathForSelectedRow()
        if let currentCell = self.tableView.cellForRowAtIndexPath(indexPath!) as! TulonaCell! {
            let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
            navigationItem.backBarButtonItem = backButton
            Singleton.sharedInstance.brandName = currentCell.brandName.text!
            //dekhunScene.reloadTableView(currentCell.brandName.text!)
        }
    }
}


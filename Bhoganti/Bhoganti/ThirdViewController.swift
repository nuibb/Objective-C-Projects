//
//  ThirdViewController.swift
//  Bhoganti
//
//  Created by Nascenia on 2/9/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate {
    
    var indicator : UIActivityIndicatorView!
    var dataSet:DataSet!
    var brandCollection = [BrandListItem]()
    var aliaseCollection = [BrandAliaseItem]()
    var brandComments = [CommentsList]()
    var currentBrand:Brand!
    var currentSearchDataArray = [String]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        //Set singleton object of BRAND from searchBar options
        if !Singleton.sharedInstance.brandName.isEmpty{
            self.reloadTableView(Singleton.sharedInstance.brandName)
            Singleton.sharedInstance.brandName = ""
        }
        
        //Get data from database to show suggestions on searchbar
        let dataManager = DataManager.sharedInstance
        self.brandCollection = dataManager.brandCollection
        self.aliaseCollection = dataManager.aliaseCollection
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.dataSet = DataSet()
        self.indicator = UIActivityIndicatorView (activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        self.indicator.color = UIColor.purpleColor()
        self.indicator.center = self.view.center
        self.indicator.hidden = true
        self.view.addSubview(self.indicator)
        self.tableView.rowHeight = 75
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
        searchBar.resignFirstResponder()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return 1
        }else{
            return 2
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return self.currentSearchDataArray.count
        } else {
            if section == 0{
                return 1
            }else{
                return self.brandComments.count
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Check to see whether the normal table or search results table is being displayed and set the Brand object from the appropriate array
        if tableView == self.searchDisplayController!.searchResultsTableView {
            let cell = UITableViewCell()
            let brandName = self.currentSearchDataArray[indexPath.row] as String
            cell.textLabel?.text = brandName as String
            return cell
        } else {
            if indexPath.section != 0 {
                let cell: CommentCell = self.tableView.dequeueReusableCellWithIdentifier("Comments", forIndexPath: indexPath) as! CommentCell
                let comment = self.brandComments[indexPath.row] as CommentsList
                cell.setCustomCell(comment.name, comment: comment.text, rating: comment.rating)
                //cell.commentArea.numberOfLines = 0
                //cell.commentArea.lineBreakMode = NSLineBreakMode.ByWordWrapping
                //cell.commentArea.sizeToFit()
                return cell
            }else{
                if self.currentBrand != nil {
                    let cell: TulonaCell = self.tableView.dequeueReusableCellWithIdentifier("Tulona", forIndexPath: indexPath) as! TulonaCell
                    cell.setCustomCellForTulona(self.currentBrand.name, rating: self.currentBrand.rating, NoOfComment: self.currentBrand.no_of_comments)
                    return cell
                }
            }
        }
        return UITableViewCell()
    }
    
    func reloadTableView(keyword:String){
        self.indicator.hidden = false
        self.indicator.bringSubviewToFront(self.view)
        self.indicator.startAnimating()
        self.dataSet = DataSet()
        self.dataSet.searchByKeyword(keyword, callback: {
            (brandDetailsList) in
            if brandDetailsList.count != 0 {
                self.currentBrand = brandDetailsList[0]
                self.dataSet.loadComments(self.currentBrand.id, completion: {
                    (response) in
                    self.brandComments = response
                    dispatch_async(dispatch_get_main_queue()){
                        self.tableView.reloadData()
                        self.indicator.stopAnimating()
                        self.indicator.hidden = true
                    }
                })
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
        var modalScene = segue.destinationViewController as! CommentWithModal
        let indexPath = self.tableView.indexPathForSelectedRow()
        if let currentCell = self.tableView.cellForRowAtIndexPath(indexPath!) as! CommentCell! {
            modalScene.name = currentCell.userName.text
            modalScene.text = currentCell.commentArea.text
            modalScene.progressValue = currentCell.progessBar.progress
        }
    }
}

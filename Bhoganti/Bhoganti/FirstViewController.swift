//
//  FirstViewController.swift
//  Bhoganti
//
//  Created by Nascenia on 2/4/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate {
    
    var brandName : String?
    var dataSet:DataSet!
    var brandCollection = [BrandListItem]()
    var aliaseCollection = [BrandAliaseItem]()
    var currentSearchDataArray = [String]()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var imageOfSmile: UIImageView!
    @IBOutlet weak var imageOfAngry: UIImageView!
    @IBOutlet weak var sliderStatus: UISlider!
    @IBOutlet weak var commentSection: UITextView!
    @IBOutlet weak var switchBox: UISwitch!
    @IBOutlet weak var nameTitle: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var button: UIButton!
    
    override func viewWillAppear(animated: Bool) {
        self.button!.setTitleColor(UIColor(red: 0.95, green: 0.35, blue: 0.16, alpha: 1), forState: UIControlState.Normal)
        self.button!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        //self.button!.setBackgroundImage(UIImage(named: "Smile"), forState: UIControlState.Highlighted)
        
        //Get data from database to show suggestions on searchbar
        let dataManager = DataManager.sharedInstance
        self.brandCollection = dataManager.brandCollection
        self.aliaseCollection = dataManager.aliaseCollection
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.dataSet = DataSet()
        self.tableView.hidden = true
        self.commentSection!.layer.borderWidth = 1
        self.commentSection!.layer.borderColor = UIColor(red: 0.95, green: 0.35, blue: 0.16, alpha: 1).CGColor
        self.textField!.hidden = true
        self.nameTitle!.hidden = true
        self.searchBar!.returnKeyType = UIReturnKeyType.Go
        
        self.button!.layer.borderWidth = 1
        self.button!.layer.borderColor = UIColor(red: 0.95, green: 0.35, blue: 0.16, alpha: 1).CGColor
        
        if let name: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("username"){
            self.textField!.text = name as? String
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated.
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
        navigationItem.setRightBarButtonItem(nil, animated: true)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        let brandName = self.searchDisplayController!.searchBar.text
        self.searchDisplayController!.setActive(false, animated: true)
        self.searchDisplayController!.searchBar.text = brandName
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
    
    @IBAction func sliderChange(sender: AnyObject) {
        //println(Int(sliderStatus.value))
    }
    
    /*override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
    self.view.endEditing(true)
    }*/
    
    // MARK: Actions
    func doneBarButtonItemClicked() {
        // Dismiss the keyboard by removing it as the first responder.
        self.commentSection.resignFirstResponder()
        navigationItem.setRightBarButtonItem(nil, animated: true)
    }
    
    
    // MARK: UITextViewDelegate
    func textViewDidBeginEditing(textView: UITextView) {
        // Provide a "Done" button for the user to select to signify completion with writing text in the text view.
        let doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "doneBarButtonItemClicked")
        
        navigationItem.setRightBarButtonItem(doneBarButtonItem, animated: true)
        
        var scrollPoint : CGPoint = CGPointMake(0, self.commentSection.frame.origin.y)
        self.scrollView.setContentOffset(scrollPoint, animated: true)
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        self.scrollView.setContentOffset(CGPointZero, animated: true)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        var scrollPoint : CGPoint = CGPointMake(0, self.textField.frame.origin.y)
        self.scrollView.setContentOffset(scrollPoint, animated: true)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.scrollView.setContentOffset(CGPointZero, animated: true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func switchListener(sender: AnyObject) {
        if switchBox.on{
            self.textField.hidden = true
            self.nameTitle.hidden = true
        }else{
            self.textField.hidden = false
            self.nameTitle.hidden = false
        }
    }
    
    @IBAction func Touchdown(sender: AnyObject) {
        sender.layer.backgroundColor = UIColor(red: 0.95, green: 0.35, blue: 0.16, alpha: 1).CGColor
    }
    
    @IBAction func sendBtnListener(sender: AnyObject) {
        sender.layer.backgroundColor = UIColor.whiteColor().CGColor
        let brandName = self.searchDisplayController!.searchBar.text
        if !self.commentSection.text.isEmpty && !brandName.isEmpty {
            self.commentSection.resignFirstResponder()
            self.textField.resignFirstResponder()
            var submitVoganti = DataSerialization(brandName: brandName, rating: Int(self.sliderStatus.value*5), commentText: self.commentSection.text, anonymous: switchBox.on ? true : false, userName: self.textField.text)
            var dataSet = DataSet()
            dataSet.postComment(submitVoganti.toJson(),callback: {
                (id) in
                dispatch_async(dispatch_get_main_queue()){
                    //Reset username
                    if let name: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("username") as? String {
                        if  name as! String != self.textField.text!{
                            NSUserDefaults.standardUserDefaults().setObject(self.textField.text!, forKey: "username")
                        }
                    }
                    
                    //Set singleton object of BRAND from searchBar options
                    Singleton.sharedInstance.brandName = brandName
                    
                    //Switch tab to dekhun tab
                    self.tabBarController!.selectedIndex = 2
                    self.searchDisplayController!.searchBar.text = ""
                    self.commentSection.text = ""
                    self.sliderStatus.value = 0.5
                }
            })
        } else{
            ShowAlert.alertWithMessage("Message!", message: "Please fill up all fields", buttons: "Ok")
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return self.currentSearchDataArray.count
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if tableView == self.searchDisplayController!.searchResultsTableView {
            let brandName = self.currentSearchDataArray[indexPath.row] as String
            cell.textLabel?.text = brandName
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == self.searchDisplayController!.searchResultsTableView {
            navigationItem.setRightBarButtonItem(nil, animated: true)
            let cell = tableView.cellForRowAtIndexPath(indexPath) as UITableViewCell!
            if cell!.textLabel!.text != nil {
                self.searchDisplayController!.setActive(false, animated: true)
                self.searchDisplayController!.searchBar.text = cell!.textLabel!.text!
            }
        }
    }
}


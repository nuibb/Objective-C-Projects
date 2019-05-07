//
//  TabBarController.swift
//  Bhoganti
//
//  Created by Nascenia on 2/3/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.grayColor(), NSFontAttributeName:UIFont(name: "HelveticaNeue", size: 14)!], forState:.Normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red: 0.95, green: 0.35, blue: 0.16, alpha: 1), NSFontAttributeName:UIFont(name: "HelveticaNeue", size: 14)!], forState:.Selected)
        UITabBar.appearance().selectedImageTintColor = UIColor(red: 0.95, green: 0.35, blue: 0.16, alpha: 1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}

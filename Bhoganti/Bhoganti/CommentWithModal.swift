//
//  CommentWithModal.swift
//  Bhoganti
//
//  Created by Nascenia on 2/13/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

import UIKit

class CommentWithModal: UIViewController {
    var name : String!
    var text : String!
    var progressValue : Float!
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var commentText: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var button: UIButton!
    
    @IBAction func buttonClickListener(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.userName.text = name
        self.commentText.text = text
        self.progressBar.setProgress(progressValue, animated: true)
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

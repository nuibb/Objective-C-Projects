//
//  CommentCell.swift
//  Bhoganti
//
//  Created by Nascenia on 2/10/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var progessBar: UIProgressView!
    @IBOutlet weak var commentArea: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCustomCell(userName : String, comment : String, rating : Int){
        self.userName.text = userName
        self.commentArea.text = comment
        self.progessBar.setProgress(Float(rating)/5.0, animated: true)
    }
}

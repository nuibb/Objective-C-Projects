//
//  TulonaCell.swift
//  Bhoganti
//
//  Created by Nascenia on 2/4/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

import UIKit

class TulonaCell: UITableViewCell {
    @IBOutlet weak var brandName: UILabel!
    @IBOutlet weak var NoOfComment: UILabel!
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.leftImage!.image = UIImage(named: "Smile")
        self.rightImage!.image = UIImage(named: "Angry")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCustomCellForTulona(brandName : String, rating: Int, NoOfComment : String){
        self.brandName!.text = brandName
        self.NoOfComment!.text = NoOfComment
        self.progressView!.setProgress(Float(rating)/5.0, animated: true)
    }
    
}

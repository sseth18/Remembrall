//
//  InitialTableViewCell.swift
//  Remembrall
//
//  Created by Samar Seth on 1/20/20.
//  Copyright © 2020 Samar Seth. All rights reserved.
//  Initial funcitons and variables copied from Dr. Z's code on TableViewControllers

import UIKit

class InitialTableViewCell: UITableViewCell {
    @IBOutlet var name: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}

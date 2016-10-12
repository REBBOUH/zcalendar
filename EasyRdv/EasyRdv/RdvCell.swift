//
//  RdvCell.swift
//  EasyRdv
//
//  Created by Yassir Aberni on 22/09/2016.
//  Copyright © 2016 Yassir Aberni. All rights reserved.
//

import UIKit

class RdvCell: UITableViewCell {
    @IBOutlet weak var dateDebut: UILabel!
   
   
    @IBOutlet weak var dateView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    
        
        
       
    }
    override func layoutSubviews() {
        dateView.layer.cornerRadius = 5
    }
    
    
}

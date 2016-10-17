//
//  MenuCell.swift
//  EasyRdv
//
//  Created by Yassir Aberni on 10/10/2016.
//  Copyright © 2016 Yassir Aberni. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {

    @IBOutlet weak var imageCell: UIImageView!
 
    @IBOutlet weak var titleCell: UILabel!
   
    @IBOutlet weak var buttonCell: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

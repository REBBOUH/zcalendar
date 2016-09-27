//
//  ClientCell.swift
//  EasyRdv
//
//  Created by Yassir Aberni on 23/09/2016.
//  Copyright © 2016 Yassir Aberni. All rights reserved.
//

import UIKit

class ClientCell: UITableViewCell {
    @IBOutlet weak var clientView: UIView!

    @IBOutlet weak var clientAdress: UILabel!
    @IBOutlet weak var clientName: UILabel!
    @IBOutlet weak var clientImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    override func layoutSubviews() {
        clientView.layer.cornerRadius = 5
        clientImage.layer.cornerRadius = 5

    }

    override func setSelected( selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

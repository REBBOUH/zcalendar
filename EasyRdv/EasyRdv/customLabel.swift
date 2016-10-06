//
//  customLabel.swift
//  EasyRdv
//
//  Created by Yassir Aberni on 06/10/2016.
//  Copyright © 2016 Yassir Aberni. All rights reserved.
//

import UIKit

class customLabel: UILabel {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    
    override func layoutSubviews() {
        
        
        self.layer.cornerRadius = 10
        
        
    }
    

}

//
//  LoadingViewCustome.swift
//  zpay
//
//  Created by Yassir Aberni on 12/09/2016.
//  Copyright © 2016 Yassir Aberni. All rights reserved.
//

import UIKit

class LoadingViewCustome: UIView {
    
    let loadingImage = UIImage(named: "activity_indicator")
   
    var loadingImageView: UIImageView!
    
    
    @IBOutlet var view: UIView!
    
     override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }

    func setup(){
        Bundle.main.loadNibNamed("LoadingViewCustome", owner: self, options: nil)
        loadingImageView = UIImageView(image: loadingImage)
        self.view.frame = self.bounds
        self.view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        self.view.layer.cornerRadius = 10
        self.addSubview(view)
        addSubview(loadingImageView)
        adjustSizeOfLoadingIndicator()
    }
    
    func showLoadingIndicator() {
        loadingImageView.isHidden = false
        self.bringSubview(toFront: loadingImageView)
        
        startRefreshing()
    }
    
    func hideLoadingIndicator() {
        loadingImageView.isHidden = true
        
        stopRefreshing()
        self.removeFromSuperview()
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        adjustSizeOfLoadingIndicator()
    }
    
    fileprivate func adjustSizeOfLoadingIndicator() {
        let loadingImageSize = loadingImage?.size
        loadingImageView.frame = CGRect(x: frame.width/2 - loadingImageSize!.width/2, y: frame.height/2-loadingImageSize!.height/2, width: loadingImageSize!.width, height: loadingImageSize!.height)
        
    }
    
    // Start the rotating animation
    fileprivate func startRefreshing() {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.isRemovedOnCompletion = false
        animation.toValue = M_PI * 2.0
        animation.duration = 0.8
        animation.isCumulative = true
        animation.repeatCount = Float.infinity
        loadingImageView.layer.add(animation, forKey: "rotationAnimation")
    }
    
    // Stop the rotating animation
    fileprivate func stopRefreshing() {
        loadingImageView.layer.removeAllAnimations()
    }
}


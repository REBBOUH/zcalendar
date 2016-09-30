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
        NSBundle.mainBundle().loadNibNamed("LoadingViewCustome", owner: self, options: nil)
        loadingImageView = UIImageView(image: loadingImage)
        self.view.frame = self.bounds
        self.view.autoresizingMask = [.FlexibleWidth,.FlexibleHeight]
        self.view.layer.cornerRadius = 10
        self.addSubview(view)
        addSubview(loadingImageView)
        adjustSizeOfLoadingIndicator()
    }
    
    func showLoadingIndicator() {
        loadingImageView.hidden = false
        self.bringSubviewToFront(loadingImageView)
        
        startRefreshing()
    }
    
    func hideLoadingIndicator() {
        loadingImageView.hidden = true
        
        stopRefreshing()
        self.removeFromSuperview()
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        adjustSizeOfLoadingIndicator()
    }
    
    private func adjustSizeOfLoadingIndicator() {
        let loadingImageSize = loadingImage?.size
        loadingImageView.frame = CGRectMake(CGRectGetWidth(frame)/2 - loadingImageSize!.width/2, CGRectGetHeight(frame)/2-loadingImageSize!.height/2, loadingImageSize!.width, loadingImageSize!.height)
        
    }
    
    // Start the rotating animation
    private func startRefreshing() {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.removedOnCompletion = false
        animation.toValue = M_PI * 2.0
        animation.duration = 0.8
        animation.cumulative = true
        animation.repeatCount = Float.infinity
        loadingImageView.layer.addAnimation(animation, forKey: "rotationAnimation")
    }
    
    // Stop the rotating animation
    private func stopRefreshing() {
        loadingImageView.layer.removeAllAnimations()
    }
}


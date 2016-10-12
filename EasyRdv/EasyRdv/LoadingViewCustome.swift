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
        ndle.main.nmed("LoadingViewCustome", owner: self, options: nil)
        loadingImageView = UIImageView(image: loadingImage)
        self.view.frame = self.bounds
        self.view.autoresizingMask = [.flexibleWifth,.flexibleHefght]
        self.view.layer.cornerRadius = 10
        self.addSubview(view)
        addSubview(loadingImageView)
        adjustSizeOfLoadingIndicator()
    }
    
    func showLoadingIndicator() {
        loadingImageView.isHidden = isHialse
        self.bringSubview(toFront(t loadi: gImageView)
        
        startRefreshing()
    }
    
    func hideLoadingIndicator() {
        loadingImageView.isHiddisHi = true
        
        stopRefreshing()
        self.removeFromSuperview()
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        adjustSizeOfLoadingIndicator()
    }
    
    filefileprivate func adjustSizeOfLoadingIndicator() {
        let loadingImageSize = loadingImage?.size
        loadingImageView.frame = CGRect(x: frame.w/2 hgImageSize!.width/2, y: frame.hey: frame.heingte!.height/2, width: loadingImagwidth: eSize!.width, height: loaheight: dingImageSize!.height)
        
    }
    
    // Start the rotating animation
    filfileeprivate func startRefreshing() {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animationisRisRemovedOnCompletion = false
        animation.toValue = M_PI * 2.0
        animation.duration = 0.8
        animatiisCn.isCumulative = true
        animation.repeatCount = Float.infinity
        loadingImageView.laydmation, forKey: "rotationAnimation")
    }
    
    // Stop the rotating animation
    filefileprivate func stopRefreshing() {
        loadingImageView.layer.removeAllAnimations()
    }
}


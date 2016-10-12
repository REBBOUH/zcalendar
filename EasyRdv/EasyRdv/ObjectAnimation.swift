//
//  ObjectAnimation.swift
//  TransitionExample
//
//  Created by Yassir Aberni on 19/04/2016.
//  Copyright © 2016 Yassir Aberni. All rights reserved.
//

import UIKit

class ObjectAnimation: NSObject,UIViewControllerAnimatedTransitioning{
    
    var originFrame = CGRect.zero
    
    var snapshot:UIView?
    
    var fromView:UIViewController?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning){
        // 1
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
                return
        }
        let containerView:UIView = transitionContext.containerView
        // 2
        let initialFrame = originFrame
        _ = transitionContext.finalFrame(for: toVC)        // 3
        let snapshot = fromVC.view.snapshotView(afterScreenUpdates: true)
        snapshot?.frame = initialFrame
        snapshot?.layer.borderColor = UIColor.black.cgColor
        snapshot?.layer.borderWidth = 1
        fromView = fromVC
        snapshot?.layer.masksToBounds = true
        containerView.addSubview(toVC.view)
        containerView.addSubview(fromVC.view)
        //toVC.view.hidden = true
        
        let size = toVC.view.frame.size
        var offSetTransform = CGAffineTransform(translationX: size.width - 50, y: 0)
        offSetTransform = offSetTransform.scaledBy(x: 1, y: 1)
        
        //AnimationHelper.perspectiveTransformForContainerView(containerView)
        //snapshot?.layer.transform = AnimationHelper.yRotation(M_PI_2)
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: {
            fromVC.view.transform = offSetTransform
            
            }, completion: {_ in
        
                // 5
                toVC.view.isHidden = false
               // fromVC.view.hidden = false
                // snapshot?.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    func singleTap(){
        
       
        
    }
}

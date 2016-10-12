//
//  ObjectInteraction.swift
//  TransitionExample
//
//  Created by Yassir Aberni on 19/04/2016.
//  Copyright © 2016 Yassir Aberni. All rights reserved.
//

import UIKit

class ObjectInteraction: UIPercentDrivenInteractiveTransition {
    
    var interactionInProgress = false
    
    fileprivate var shouldCompleteTransition = false
    
    var segueName:String = ""
   
    
    fileprivate weak var viewController: UIViewController!
    
    
    func wireToViewController(_ viewController: UIViewController!,segue:String) {
        
        segueName = segue
        self.viewController = viewController
        prepareGestureRecognizerInView(viewController.view)
    }
    
    fileprivate func prepareGestureRecognizerInView( _ view: UIView) {
        
        let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        gesture.edges = UIRectEdge.left
        view.addGestureRecognizer(gesture)
       
    }
    
    func handleGesture(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        
        // 1
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view!.superview!)
        var progress = (translation.x / 200)
        print(translation.x)
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        
        switch gestureRecognizer.state {
            
        case .began:
            // 2
            interactionInProgress = true
           viewController.performSegue(withIdentifier: segueName, sender: self)
            
        case .changed:
            //3
            shouldCompleteTransition = progress > 0.5
            update(progress)
            
        case .cancelled:
            // 4
            interactionInProgress = false
            cancel()
            
        case .ended:
            // 5
            interactionInProgress = false
            
            if !shouldCompleteTransition {
                cancel()
            } else {
                finish()
            }
            
        default:
            print("Unsupported")
        }
    }

}

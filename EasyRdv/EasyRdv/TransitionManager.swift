

import UIKit

class TransitionManager: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    fileprivate var presenting = false
    fileprivate var interactive = false
    
    fileprivate var enterPanGesture: UIScreenEdgePanGestureRecognizer!
    //fileprivate var statusBarBackground: UIView!
    
    var sourceViewController: UIViewController! {
        didSet {
            self.enterPanGesture = UIScreenEdgePanGestureRecognizer()
            self.enterPanGesture.addTarget(self, action:#selector(TransitionManager.handleOnstagePan(_:)))
            self.enterPanGesture.edges = UIRectEdge.left
            self.sourceViewController.view.addGestureRecognizer(self.enterPanGesture)
            
        }
    }
    
    fileprivate var exitPanGesture: UIScreenEdgePanGestureRecognizer!
    
    var menuViewController: UIViewController! {
        didSet {
            
        }
    }
    
    func handleOnstagePan(_ pan: UIPanGestureRecognizer){
        // how much distance have we panned in reference to the parent view?
        let translation = pan.translation(in: pan.view!)
        
        // do some math to translate this to a percentage based value
        let d =  translation.x / pan.view!.bounds.width * 0.5
        print(d)
        // now lets deal with different states that the gesture recognizer sends
        switch (pan.state) {
            
        case UIGestureRecognizerState.began:
            // set our interactive flag to true
            self.interactive = true
            
            // trigger the start of the transition
            self.sourceViewController.performSegue(withIdentifier: "afficheMenu", sender: self)
            break
            
        case UIGestureRecognizerState.changed:
            
            // update progress of the transition
            self.update(d)
            break
            
        default: // .Ended, .Cancelled, .Failed ...
            
            // return flag to false and finish the transition
            self.interactive = false
            if(d > 0.2){
                
                self.finish()
            }
            else {
                
                self.cancel()
            }
        }
    }
    
    
    func handleOffstagePan(_ pan: UIPanGestureRecognizer){
        
        let translation = pan.translation(in: pan.view!)
        
        let d =  translation.x / pan.view!.bounds.width * -0.5
        switch (pan.state) {
            
        case UIGestureRecognizerState.began:
            self.interactive = true
            self.menuViewController.dismiss(animated: true, completion: {})
            break
            
        case UIGestureRecognizerState.changed:
            self.update(d)
            break
            
        default: // .Ended, .Cancelled, .Failed ...
            self.interactive = false
            if(d > 0.1){
                self.finish()
            }
            else {
                self.cancel()
            }
        }
        
    }
    
    // MARK: UIViewControllerAnimatedTransitioning protocol methods
    
    // animate a change from one viewcontroller to another
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        // get reference to our fromView, toView and the container view that we should perform the transition in
        let container = transitionContext.containerView
        
        // create a tuple of our screens
        let screens : (from:UIViewController, to:UIViewController) = (transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!, transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!)
        
        
        let menuViewController = !self.presenting ? screens.from as! MenuViewController : screens.to as! MenuViewController
        let topViewController = !self.presenting ? screens.to as UIViewController : screens.from as UIViewController
        
        let menuView = menuViewController.view
        let topView = topViewController.view
        
        // prepare menu items to slide in
        if (self.presenting){
            self.offStageMenuControllerInteractive(menuViewController) // offstage for interactive
        }
        
        // add the both views to our view controller
        
        container.addSubview(menuView!)
        container.addSubview(topView!)
        
        let duration = self.transitionDuration(using: transitionContext)
        
        // perform the animation!
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: [], animations: {
            
            if (self.presenting){
                self.onStageMenuController(menuViewController)
                let off = UIScreen.main.bounds.width * 0.9
                topView?.transform = self.offStage(off)
            }
            else {
                topView?.transform = CGAffineTransform.identity
                self.offStageMenuControllerInteractive(menuViewController)
            }
            
            }, completion: { finished in
                if(transitionContext.transitionWasCancelled){
                    
                    transitionContext.completeTransition(false)
                    UIApplication.shared.keyWindow?.addSubview(screens.from.view)
                    
                }
                else {
                    if self.presenting {
                        
                        self.onStageMenuController(menuViewController)
                        let off = UIScreen.main.bounds.width * 0.9
                        topView?.transform = self.offStage(off)
                        self.exitPanGesture = UIScreenEdgePanGestureRecognizer()
                        self.exitPanGesture.edges = UIRectEdge.right
                        self.exitPanGesture.addTarget(self, action:#selector(TransitionManager.handleOffstagePan(_:)))
                        topView?.addGestureRecognizer(self.exitPanGesture)
                        (self.sourceViewController as! UITableViewController).tableView.isUserInteractionEnabled = false
                     //   UIApplication.shared.keyWindow?.addSubview(screens.to.view!)
                        
                    }else{
                        
                        (self.sourceViewController as! UITableViewController).tableView.isUserInteractionEnabled = true
                        UIApplication.shared.keyWindow?.addSubview(screens.to.view!)
                        
                    }
                    
                    transitionContext.completeTransition(true)
                    
                    
                    
                    
                }
                
                
        })
        
    }
    
    func offStage(_ amount: CGFloat) -> CGAffineTransform {
        
        var offSetTransform = CGAffineTransform(translationX: amount, y: 0)
        offSetTransform = offSetTransform.scaledBy(x: 1, y: 1)
        return offSetTransform
    }
    
    func offStageMenuControllerInteractive(_ menuViewController: UIViewController){
        
//        menuViewController.view.alpha = 0
        // setup paramaters for 2D transitions for animations
        let offstageOffset  :CGFloat = -200
        menuViewController.view.transform = self.offStage(offstageOffset)
        
        
    }
    
    func onStageMenuController(_ menuViewController: UIViewController){
        
        // prepare menu to fade in
        menuViewController.view.alpha = 1
        menuViewController.view.transform = CGAffineTransform.identity
        
    }
    
    // return how many seconds the transiton animation will take
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    // MARK: UIViewControllerTransitioningDelegate protocol methods
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = true
        return self
    }
    
    // return the animator used when dismissing from a viewcontroller
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = false
        return self
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        return self.interactive ? self : nil
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.interactive ? self : nil
    }
    
}

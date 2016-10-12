//
//  UserTableViewController.swift
//  EasyRdv
//
//  Created by Yassir Aberni on 22/09/2016.
//  Copyright © 2016 Yassir Aberni. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {
    
    var transitionDelegate:TransitionManager = TransitionManager()
    
    
    var listUser:NSMutableArray?
    
    let loadingImage = UIImage(named: "activity_indicator")
    
    var loadingView:LoadingViewCustome!
    
    fileprivate let swipeInteractionController = ObjectInteraction()
    
    fileprivate let swipeInteractionControllerDismiss = ObjectInteractionDismiss()
    
    fileprivate let flipPresentAnimationController = ObjectAnimation()
    
    fileprivate let flipPresentAnimationControllerDismiss = ObjectAnimationDismiss()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listUser = NSMutableArray()
        
        UserSingleton.sharedInstance.user.initData()
        
        self.navigationItem.title = "EasyRdv"
        
        // swipeInteractionController.wireToViewController(self,segue:"fromconnexion")
        
        transitionDelegate.sourceViewController = self
        
        self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Arial", size: 14)!];
        loadingView = LoadingViewCustome(frame: CGRect(origin: CGPoint(x:self.view.frame.midX - 100 ,y:self.view.frame.midY), size: CGSize(width: 200, height: 200)))
        
        newUpdate()
        
        NotificationCenter.default.setObserver(self, selector: #selector(UserTableViewController.handleNotifications(notification:)), name: Constants.notificationusergetok, object: nil)
        
        NotificationCenter.default.setObserver(self, selector: #selector(UserTableViewController.handleNotifications(notification:)), name: Constants.notificationconxerror, object: nil)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (listUser?.count)!
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellinfoclient", for: indexPath) as! ClientCell
        cell.clientAdress.text = (listUser?.object(at: (indexPath as NSIndexPath).row) as! User).adress
        cell.clientName.text = (listUser?.object(at: (indexPath as NSIndexPath).row) as! User).nameUser
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        UserSingleton.sharedInstance.user = self.listUser?.object(at: (indexPath as NSIndexPath).row) as! User
        
    }
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK - handle notification
    
    func  handleNotifications(notification:NSNotification) {
        
        if notification.name == .notificationusergetok {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            DispatchQueue.global(qos: .default).async(execute: {
                if let infos:[String:Any]  = notification.userInfo as? [String:Any]   {
                    
                    let list = (infos["data"] as! [String:Any])["item"] as! [[String : AnyObject]]
                    for userInfo in list {
                        let  user = User()
                        user.initWithDic(userInfo: userInfo)
                        self.listUser?.add(user)
                        
                    }
                }
                
                DispatchQueue.main.async(execute: {
                    self.loadingView.hideLoadingIndicator()
                    self.view.isUserInteractionEnabled = true
                    self.tableView.reloadData()
                    
                })
            })
        }
        
        if notification.name == .notificationconxerror {
            
            DispatchQueue.main.async(execute: {
                
                self.loadingView.hideLoadingIndicator()
                
                self.view.isUserInteractionEnabled = true
                
                let viewAlert = UIAlertController(title: "errorr", message: "erreur de connexion ", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                    
                    _ = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(UserTableViewController.newUpdate), userInfo: nil, repeats: false)
                })
                
                viewAlert.addAction(defaultAction)
                self.present(viewAlert, animated: true, completion: {})
                
            })
        }
        
        NotificationCenter.default.removeObserver(notification.name)
        
    }
    
    func newUpdate(){
        UserApi.GETALL(begin: {_ in
            self.view.addSubview(self.loadingView)
            self.loadingView.showLoadingIndicator()
            self.view.isUserInteractionEnabled = false
            },success: {_ in })
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if  segue.identifier == "afficheMenu" , let destinationViewController = segue.destination as? MenuViewController  {
            
            transitionDelegate.menuViewController = destinationViewController
            
            //swipeInteractionControllerDismiss.wireToViewController(destinationViewController)
            
        }
    }
    
}
//extension UserTableViewController:UIViewControllerTransitioningDelegate {
//
//    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?
//    {
//
//        flipPresentAnimationController.originFrame = self.view.frame
//        return flipPresentAnimationController
//
//    }
//
//    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//
//        flipPresentAnimationControllerDismiss.originFrame = self.view.frame
//        return flipPresentAnimationController
//
//    }
//
//    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//
//        return swipeInteractionController.interactionInProgress ? swipeInteractionController : nil
//
//    }
//
//    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//
//        return swipeInteractionControllerDismiss.interactionInProgress ? swipeInteractionControllerDismiss : nil
//        
//    }
//    
//}
//

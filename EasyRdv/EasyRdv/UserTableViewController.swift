//
//  UserTableViewController.swift
//  EasyRdv
//
//  Created by Yassir Aberni on 22/09/2016.
//  Copyright © 2016 Yassir Aberni. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {
    
    
    var listUser:NSMutableArray?
    
    let loadingImage = UIImage(named: "activity_indicator")
    
    var loadingView:LoadingViewCustome!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
               listUser = NSMutableArray()
        
        UserSingleton.sharedInstance.user.initData()
        
        self.navigationItem.title = "EasyRdv"
        
        
        
        self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Arial", size: 14)!];
        loadingView = LoadingViewCustome(frame: CGRect(origin: CGPoint(x:self.view.frame.midX - 100 ,y:self.view.frame.midY), size: CGSize(width: 200, height: 200)))
        
        newUpdate()
        
        NSNotificationCenter.defaultCenter().setObserver(self, selector: #selector(UserTableViewController.handleNotifications(_:)), name: Constants.notificationusergetok, object: nil)
        
        NSNotificationCenter.defaultCenter().setObserver(self, selector: #selector(UserTableViewController.handleNotifications(_:)), name: Constants.notificationconxerror, object: nil)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (listUser?.count)!
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cellinfoclient", forIndexPath: indexPath) as! ClientCell
        cell.clientAdress.text = (listUser?.objectAtIndex(indexPath.row) as! User).adress
        cell.clientName.text = (listUser?.objectAtIndex(indexPath.row) as! User).nameUser
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        UserSingleton.sharedInstance.user = self.listUser?.objectAtIndex(indexPath.row) as! User
        
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
        if notification.name == Constants.notificationusergetok {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                if let infos = notification.userInfo!["data"]!["items"]   {
                    
                    let list = infos as! [[String : AnyObject]]
                    for userInfo in list {
                        if let  user:User = User() {
                            user.initWithDic(userInfo)
                            self.listUser?.addObject(user)
                        }
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.loadingView.hideLoadingIndicator()
                    self.view.userInteractionEnabled = true
                    self.tableView.reloadData()
                
                })
            })
        }
        
        if notification.name == Constants.notificationconxerror {
            
            dispatch_async(dispatch_get_main_queue(), {
                
                self.loadingView.hideLoadingIndicator()
               
                self.view.userInteractionEnabled = true
              
                let viewAlert = UIAlertController(title: "errorr", message: "erreur de connexion ", preferredStyle: .Alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: { _ in
 
                    var timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(UserTableViewController.newUpdate), userInfo: nil, repeats: false)
                })
                
                viewAlert.addAction(defaultAction)
                self.presentViewController(viewAlert, animated: true, completion: {})

                
                
            })
        }
        
        
        NSNotificationCenter.defaultCenter().removeObserver(notification.name)
        
    }
    
    func newUpdate(){
        ApiManager.checkValueUser({_ in
            self.view.addSubview(self.loadingView)
            self.loadingView.showLoadingIndicator()
            self.view.userInteractionEnabled = false
            },success: {_ in })
   
    
    }

    
}

//
//  UserTableViewController.swift
//  EasyRdv
//
//  Created by Yassir Aberni on 22/09/2016.
//  Copyright © 2016 Yassir Aberni. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {
    
    var transitionDelegateMenu:TransitionManager = TransitionManager()
    
    var listUser:NSMutableArray?
    
    let loadingImage = UIImage(named: "activity_indicator")
    
    var loadingView:LoadingViewCustome!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listUser = NSMutableArray()
        
        UserSingleton.sharedInstance.user.initData()
        
        self.navigationItem.title = "EasyRdv"
        
        // swipeInteractionController.wireToViewController(self,segue:"fromconnexion")
        
        transitionDelegateMenu.sourceViewController = self
        
//        self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Arial", size: 14)!];
        loadingView = LoadingViewCustome(frame: CGRect(origin: CGPoint(x:self.view.frame.midX - 100 ,y:self.view.frame.midY), size: CGSize(width: 200, height: 200)))
        
        newUpdate()
        
        NotificationCenter.default.setObserver(self, selector: #selector(UserTableViewController.handleNotifications(notification:)), name: Constants.notificationusergetallok, object: nil)
        
        NotificationCenter.default.setObserver(self, selector: #selector(UserTableViewController.handleNotifications(notification:)), name: Constants.notificationconxerror, object: nil)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    @IBAction func unwindToMainViewController (_ sender: UIStoryboardSegue){
        // bug? exit segue doesn't dismiss so we do it manually...
        
        self.navigationController?.removeFromParentViewController()
        self.navigationController?.view.removeFromSuperview()
        
        NotificationCenter.default.post(name: .removefromUserCalendar, object: nil)
        
        
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return (listUser!.count)
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellinfoclient", for: indexPath) as! ClientCell
        cell.clientAdress.text = (listUser?.object(at: indexPath.row) as! User).adress
        cell.clientName.text = (listUser?.object(at: indexPath.row) as!  User).nameUser
   
        return cell
   
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        UserSingleton.sharedInstance.user = self.listUser?.object(at: (indexPath as NSIndexPath).row) as! User
        
        
    }
    
    // MARK: - handle notification
    
    @objc   func  handleNotifications(notification:NSNotification) {
        
        if notification.name == .notificationusergetallok {
           
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            DispatchQueue.global(qos: .default).async(execute: {
                if let infos:[String:Any]  = notification.userInfo?["data"] as? [String:Any]   {
                    
                    let list = infos["items"] as! [[String : Any]]
                    for userInfo in list {
                        let  user = User()
                        user.initWithDic(userInfo: userInfo as [String : AnyObject])
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
                               self.afficheAlert(title: "errorr", message: "erreur de connexion ", handleFunction: {_ in
                                 _ = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(UserTableViewController.newUpdate), userInfo: nil, repeats: false)
                
                })
                
            })
        }
        
        NotificationCenter.default.removeObserver(self, name: notification.name, object: nil)
        
    }
    
    
    //MARK: - Get users calendar
    func newUpdate(){
        UserApi.GETALL(begin: {_ in
            self.view.addSubview(self.loadingView)
            self.loadingView.showLoadingIndicator()
            self.view.isUserInteractionEnabled = false
            },success: {_ in })
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if  segue.identifier == "afficheMenu" , let destinationViewController = segue.destination as? MenuViewController  {
            
            destinationViewController.transitioningDelegate = self.transitionDelegateMenu
            self.transitionDelegateMenu.menuViewController = destinationViewController
            //swipeInteractionControllerDismiss.wireToViewController(destinationViewController)
            
        }
    }
    
}

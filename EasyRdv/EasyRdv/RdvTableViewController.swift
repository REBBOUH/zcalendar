//
//  RdvTableViewController.swift
//  EasyRdv
//
//  Created by Yassir Aberni on 22/09/2016.
//  Copyright © 2016 Yassir Aberni. All rights reserved.
//

import UIKit

class RdvTableViewController: UITableViewController {
    
    
    var calender:Calendar?
    
    let loadingImage = UIImage(named: "activity_indicator")
    
    var loadingView:LoadingViewCustome!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calender = Calendar()
        
        loadingView = LoadingViewCustome(frame: CGRect(origin: CGPoint(x:self.view.frame.midX - 100 ,y:self.view.frame.midY), size: CGSize(width: 200, height: 200)))
        self.navigationItem.title = "Choisissez votre rendez-vous"
        self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Arial", size: 14)!];


        ApiManager.checkValue(UserSingleton.sharedInstance.user.calendarId!,begin: {_ in
            
            self.view.addSubview(self.loadingView)
            self.loadingView.showLoadingIndicator()
            self.view.userInteractionEnabled = false
            
            },success: {_ in
                
        })

        NSNotificationCenter.defaultCenter().setObserver(self, selector: #selector(RdvTableViewController.handleNotifications(_:)), name: Constants.notificationmailpasswordok, object: nil)
        
        NSNotificationCenter.defaultCenter().setObserver(self, selector: #selector(RdvTableViewController.handleNotifications(_:)), name: Constants.notificationmailpassworderror, object: nil)
        
        NSNotificationCenter.defaultCenter().setObserver(self, selector: #selector(RdvTableViewController.handleNotifications(_:)), name: Constants.notificationeventupdateokreload, object: nil)
        
        NSNotificationCenter.defaultCenter().setObserver(self, selector: #selector(RdvTableViewController.handleNotifications(_:)), name: Constants.notificationconxerror, object: nil)
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
        return (calender?.listCalandar?.count)!
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.view.bounds.height / 4
        
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell  = tableView.dequeueReusableCellWithIdentifier("cellinfoclient") as! ClientCell
        
        if let user:User = UserSingleton.sharedInstance.user {
            
            cell.clientName.text = user.nameUser
            cell.clientAdress.text = user.adress
            
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("celldate", forIndexPath: indexPath) as! RdvCell
        
        let datestring = "\((calender?.listCalandar![indexPath.row] as? Event)!.start!.asDateString)"
       
        cell.dateDebut.text = datestring
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        CalendarSingleton.sharedInstance.index = indexPath
        CalendarSingleton.sharedInstance.event = self.calender?.listCalandar![indexPath.row] as! Event
        
        let priseRendezVousViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("priseRdvController") as! PriseRdvController
        
        self.navigationController?.pushViewController(priseRendezVousViewController as UIViewController, animated: true)
        
    }
    
    // MARK - handle notification
    
    func  handleNotifications(notification:NSNotification) {
        if notification.name == Constants.notificationmailpasswordok {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            
            dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
                
                if let infos = notification.userInfo?["data"]   {
                    
                    self.calender = Calendar(eventInfos: infos as! [[String : AnyObject]] )
                    
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    self.loadingView.hideLoadingIndicator()
                    self.view.userInteractionEnabled = true
                    
                    if self.calender?.listCalandar?.count == 0 {
                        
                        let alerview = UIAlertView(title: "Rendez-vous",message: "pas de rendez-vous disponible", delegate: self, cancelButtonTitle: "ok")
                        alerview.show()
                        
                    }else{
                        
                        self.tableView.reloadData()
                        
                    }
                })
            })
        }
        
        if notification.name == Constants.notificationmailpassworderror {
            
            dispatch_async(dispatch_get_main_queue(), {
                
                let alerview = UIAlertView(title: "errorr",message: "erreur de connexion ", delegate: self, cancelButtonTitle: "ok")
                alerview.show()
                
            })
        }
        
        if notification.name == Constants.notificationeventupdateokreload {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                
                self.calender?.listCalandar?.removeObjectAtIndex(CalendarSingleton.sharedInstance.index.row)
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    
                    self.tableView.reloadData()
                    
                })
            })
        }
        
        if notification.name == Constants.notificationconxerror {
            
            dispatch_async(dispatch_get_main_queue(), {
                
                self.loadingView.hideLoadingIndicator()
                let alerview = UIAlertView(title: "errorr",message: "erreur de connexion ", delegate: self, cancelButtonTitle: "ok")
                alerview.show()
                
                
            })
            
        }
        
        NSNotificationCenter.defaultCenter().removeObserver(notification.name)
        
    }
    
    func newUpdate(){
        
    }
    
}

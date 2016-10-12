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
        self.navigationController?.navigationBar.isHidden = false
        calender = Calendar()
        
        loadingView = LoadingViewCustome(frame: CGRect(origin: CGPoint(x:self.view.frame.midX - 100 ,y:self.view.frame.midY), size: CGSize(width: 200, height: 200)))
        
        self.navigationItem.title = "Choisissez votre rendez-vous"
       
        self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Arial", size: 14)!];


        CalendarApi.GET(calendarId: UserSingleton.sharedInstance.user.calendarId!,begin: {_ in
            
            self.view.addSubview(self.loadingView)
            self.loadingView.showLoadingIndicator()
            self.view.isUserInteractionEnabled = false
            
            },success: {_ in
                
        })

        NotificationCenter.default.setObserver(self, selector: #selector(RdvTableViewController.handleNotifications(_:)), name: Constants.notificationcalendarok.rawValue, object: nil)
        
        NotificationCenter.default.setObserver(self, selector: #selector(RdvTableViewController.handleNotifications(_:)), name: Constants.notificationcalendarerror.rawValue, object: nil)
        
        NotificationCenter.default.setObserver(self, selector: #selector(RdvTableViewController.handleNotifications(_:)), name: Constants.notificationeventupdateokreload.rawValue, object: nil)
        
        NotificationCenter.default.setObserver(self, selector: #selector(RdvTableViewController.handleNotifications(_:)), name: Constants.notificationconxerror.rawValue, object: nil)
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
        return (calender?.listCalandar?.count)!
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return self.view.bounds.height / 4
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: "cellinfoclient") as! ClientCell
        
        if UserSingleton.sharedInstance.user.checkAllValues() {
            
            let user = UserSingleton.sharedInstance.user
            cell.clientName.text = user.nameUser
            cell.clientAdress.text = user.adress
            
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "celldate", for: indexPath) as! RdvCell
        
        let datestring = "\((calender?.listCalandar![(indexPath as NSIndexPath).row] as? Event)!.start!.asDateString)"
       
        cell.dateDebut.text = datestring
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        CalendarSingleton.sharedInstance.index = indexPath
        CalendarSingleton.sharedInstance.event = self.calender?.listCalandar![(indexPath as NSIndexPath).row] as! Event
        
        let priseRendezVousViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "priseRdvController") as! PriseRdvController
        
        self.navigationController?.pushViewController(priseRendezVousViewController as UIViewController, animated: true)
        
    }
    
    // MARK - handle notification
    
 @objc   func  handleNotifications(_ notification:Notification) {
        if notification.name == .notificationcalendarok {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
           DispatchQueue.global(qos: .default).sync(execute: {
                
                if let infos = (notification as NSNotification).userInfo?["data"]   {
                    
                    self.calender = Calendar(eventInfos: infos as! [[String : AnyObject]] )
                    
                }
                
                DispatchQueue.main.async(execute: {
                    
                    self.loadingView.hideLoadingIndicator()
                    
                    self.view.isUserInteractionEnabled = true
                    
                    if self.calender?.listCalandar?.count == 0 {
                        
                        
                        let alerview = UIAlertController(title: "Rendez-vous",message: "pas de rendez-vous disponible", preferredStyle: .alert)
                        self.present(alerview, animated: true, completion: {})

                    }else{
                        
                        self.tableView.reloadData()
                        
                    }
                })
            })
        }
        
        if notification.name == .notificationcalendarerror {
            
            DispatchQueue.main.async(execute: {
                self.loadingView.hideLoadingIndicator()
                
                self.view.isUserInteractionEnabled = true
               
                let alerview = UIAlertController(title: "errorr",message: "erreur de connexion ", preferredStyle: .alert)
                self.present(alerview, animated: true, completion: {})

            })
        }
        
        if notification.name == .notificationeventupdateokreload {
            
           DispatchQueue.global(qos: .default).async(execute: {
                
                self.calender?.listCalandar?.removeObject(at: (CalendarSingleton.sharedInstance.index as NSIndexPath).row)
                
                DispatchQueue.main.async(execute: {
                    
                    
                    self.tableView.reloadData()
                    
                })
            })
        }
        
        if notification.name == .notificationconxerror {
            
            DispatchQueue.main.async(execute: {
                
                self.loadingView.hideLoadingIndicator()
                
                let alerview = UIAlertController(title: "errorr",message: "erreur de connexion ", preferredStyle: .alert)
                self.present(alerview, animated: true, completion: {})

            })
            
        }
        
        NotificationCenter.default.removeObserver(notification.name)
        
    }
    
    func newUpdate(){
        
    }
    
}

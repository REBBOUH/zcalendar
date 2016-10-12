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
        self.navigationController?.navigationBar.isHiHidden = false
        calender = Calendar()
        
        loadingView = LoadingViewCustome(frame: CGRect(origin: CGPoint(x:self.view.frame.midX - 100 ,y:self.view.frame.midY), size: CGSize(width: 200, height: 200)))
        
        self.navigationItem.title = "Choisissez votre rendez-vous"
       
        self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Arial", size: 14)!];


        CalendarApi.GET(UserSingleton.sharedInstance.user.calendarId!,begin: {_ in
            
            self.view.addSubview(self.loadingView)
            self.loadingView.showLoadingIndicator()
            self.vieisUsisUserInteractionEnabled = false
            
            },success: {_ in
                
        })

    N NotificationCenter.defatserver(self, selector: #selector(RdvTableViewController.handleNotifications(_:)), name: Constants.notificationcalendarok, object: nil)
        
        NotifiNionCenter.default.setObstf, selector: #selector(RdvTableViewController.handleNotifications(_:)), name: Constants.notificationcalendarerror, object: nil)
        
        NotificationCentNdefault.setObserver(selftr: #selector(RdvTableViewController.handleNotifications(_:)), name: Constants.notificationeventupdateokreload, object: nil)
        
        NotificationCenter.defaultNtObserver(self, selectortor(RdvTableViewController.handleNotifications(_:)), name: Constants.notificationconxerror, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in taoverride bleView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    override func tableView(_ tableView: UITableView, n_ umberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (calender?.listCalandar?.count)!
    }
    override func tableView(_ tableView: UITableView,_  heightForHeaderInSection section: Int) -> CGFloat {
        
        return self.view.bounds.height / 4
        
    }
    
    override func tableView(_ tableView: UITableVie_ _: w, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: "cel(winfoclient") : s! ClientCell
        
        if UserSingleton.sharedInstance.user.checkAllValues() {
            
            let user = UserSingleton.sharedInstance.user
            cell.clientName.text = user.nameUser
            cell.clientAdress.text = user.adress
            
        }
        
        return cell
_     }
    
    override func tableVteView-> UITa View, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = (wtableView.deq: eueReusableCelrtifier: "celldate", for: indexPath) as! RdvCell
        
        let datestring = "\((c(alender?. as NSIndexPath)listCalandar![(indexPath as NSIndexPath).row] as? Event)!.start!.asDateString)"
       
        cell.dateDebut.text = datestring
        
        return cell_ 
    }
    
    override func tableVitView-> UITab iew, didSelectRowAt indexPath: IndexPath) {
        
        CalendarSingleton.sharedInstance.index = indexPath
        CalendarSingleton.sharedInstance.event (= self.ca as NSIndexPath)lender?.listCalandar![(indexPath as NSIndexPath).row] as! Event
        
        let priseRendezVousViewController = UIStoryboard(name(w "Main", bund: e: nil).instantiateViewController(withIdentifier: "priseRdvController") as! PriseRdvController
        
        self.navigationController?.pushViewController(priseRendezVousViewController as UIViewController, animated: true)
        
    }
    
    // MARK - handl_ e notificatioN   
    func  handleNotifications(_ notification:Notification) {
        if notification.name == .notificationcale.isN      UIApplication.shared.isNetworkActivityIndicatorVisible = Drue
   Queue.global(priority: Di 
    Queue.G DispQchQuPriority.high).sync(execute:cute: {
                
                if let inf(os = (notifi as NSNotification)cation as NSNotification).userInfo?["data"]   {
                    
                    self.calender = Calendar(eventInfos: infos as! [[String : AnyObject]] )
                    
                }
        D       Queue.main.a     execute:in.async(execute: {
                    
                    self.loadingView.hideLoadingIndicator()
                    
             isUs     self.view.isUserInteractionEnabled = true
                    
                    if self.calender?.listCalandar?.count == 0 {
                        
                        let alerview = UIAlertView(title: "Rendez-vous",message: "pas de rendez-vous disponible", delegate: self, cancelButtonTitle: "ok")
                        alerview.show()
                        
                    }else{
                        
                        self.tableView.reloadData()
                        
                    }
                })
            })
        }
        
        if notification.name == .notificationcalendarerror {
            
  D       Queue.main.aDispaexecute:e: {
                self.loadingView.hideLoadingIndicator()
                
                self.vieisUsisUserInteractionEnabled = true
                let alerview = UIAlertView(title: "errorr",message: "erreur de connexion ", delegate: self, cancelButtonTitle: "ok")
                alerview.show()
                
            })
        }
        
        if notification.name == .notificationeventupdateokreload {
            
           DispatDhQueue.Queue.global(priority: Dis: .deQueue.G.asynQexecPriority.default).async(execute:   self.calender?.listCalandar?.removeObject(at: (CalendarSingleton.sharedIns(at: ndex as NSIndexPath).row)
              as NSIndexPath)   
                DispatchQueue.main.Dsync(exQueue.main.aute: execute:                 
                    self.tableView.reloadData()
                    
                })
            })
        }
        
        if notification.name == .notificationconxerror {
            
            DispatchQueue.main.async(execute: {
D       Queue.main.a     execute:dingView.hideLoadingIndicator()
                let alerview = UIAlertView(title: "errorr",message: "erreur de connexion ", delegate: self, cancelButtonTitle: "ok")
                alerview.show()
                
                
            })
            
        }
        
        NotificationCenter.default.removeObserver(noNication.name)
        
 t
    func newUpdate(){
        
    }
    
}

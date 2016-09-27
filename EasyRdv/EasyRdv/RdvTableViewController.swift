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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //        self.tableView.estimatedRowHeight = 89
        calender = Calendar()
        
        ApiManager.checkValue({_ in })
        
        NSNotificationCenter.defaultCenter().setObserver(self, selector: #selector(RdvTableViewController.handleNotifications(_:)), name: Constants.notificationmailpasswordok, object: nil)
        NSNotificationCenter.defaultCenter().setObserver(self, selector: #selector(RdvTableViewController.handleNotifications(_:)), name: Constants.notificationmailpassworderror, object: nil)
        
        NSNotificationCenter.defaultCenter().setObserver(self, selector: #selector(RdvTableViewController.handleNotifications(_:)), name: Constants.notificationeventupdateokreload, object: nil)
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
        cell.clientName.text = "Mourad Aissou"
        cell.clientAdress.text = "3B Rue Taylor 75010, Paris"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("celldate", forIndexPath: indexPath) as! RdvCell
        
        cell.dateDebut.text = "\((calender?.listCalandar![indexPath.row] as! Event).start!.asDateString)"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        CalendarSingleton.sharedInstance.index = indexPath
        
        CalendarSingleton.sharedInstance.event.setValue(self.calender?.listCalandar![indexPath.row] as! Event)
        
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
        if notification.name == Constants.notificationmailpasswordok {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                
                if let infos = notification.userInfo!["data"]   {
                    
                    self.calender = Calendar(eventInfos: infos as! [[String : AnyObject]] )
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    self.tableView.reloadData()
                    
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
        
        NSNotificationCenter.defaultCenter().removeObserver(notification.name)
        
    }
    
    
    
}

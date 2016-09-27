//
//  PriseRdvController.swift
//  EasyRdv
//
//  Created by Yassir Aberni on 23/09/2016.
//  Copyright © 2016 Yassir Aberni. All rights reserved.
//

import UIKit

class PriseRdvController: UIViewController {
    
    @IBOutlet weak var dateField: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().setObserver(self, selector: #selector(PriseRdvController.handleNotifications(_:)), name: Constants.notificationeventupdateok, object: nil)
        NSNotificationCenter.defaultCenter().setObserver(self, selector: #selector(PriseRdvController.handleNotifications(_:)), name: Constants.notificationeventupdateerror, object: nil)
        
        dispatch_async(dispatch_get_main_queue(), {
            self.dateField.text = CalendarSingleton.sharedInstance.event.start?.asDateString
        })
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func valider(sender: UIButton) {
        ApiManager.UpdateCalendar(CalendarSingleton.sharedInstance.event.id!)
        
    }
    
    
    
    
    @IBAction func annuler(sender: UIButton) {
        
        self.dismissViewControllerAnimated(true, completion: {})
        
    }
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
        if notification.name == Constants.notificationeventupdateok {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    let viewAlert = UIAlertController(title: "réservation éffectuée", message: "votre réservartion a été bien éffectuée ", preferredStyle: .Alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: { _ in
                        self.dismissViewControllerAnimated(true, completion: {
                         NSNotificationCenter.defaultCenter().postNotificationName(Constants.notificationeventupdateokreload, object: nil)
                        })
                        
                    })
                    
                    viewAlert.addAction(defaultAction)
                    self.presentViewController(viewAlert, animated: true, completion: {})
                })
            })
            
        }
        
        if notification.name == Constants.notificationeventupdateerror {
            
            dispatch_async(dispatch_get_main_queue(), {
                let alerview = UIAlertView(title: "errorr",message: "erreur de connexion ", delegate: self, cancelButtonTitle: "ok")
                alerview.show()
            })
        }
        
        NSNotificationCenter.defaultCenter().removeObserver(notification.name)
        
    }
    
    
}

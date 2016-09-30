//
//  PriseRdvController.swift
//  EasyRdv
//
//  Created by Yassir Aberni on 23/09/2016.
//  Copyright © 2016 Yassir Aberni. All rights reserved.
//

import UIKit

class PriseRdvController: UIViewController {
    
    let loadingImage = UIImage(named: "activity_indicator")
    
    var loadingView:LoadingViewCustome!
    
    @IBOutlet weak var dateField: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingView = LoadingViewCustome(frame: CGRect(origin: CGPoint(x:self.view.frame.midX - 100 ,y:self.view.frame.midY), size: CGSize(width: 200, height: 200)))
        
        

        NSNotificationCenter.defaultCenter().setObserver(self, selector: #selector(PriseRdvController.handleNotifications(_:)), name: Constants.notificationeventupdateok, object: nil)
        NSNotificationCenter.defaultCenter().setObserver(self, selector: #selector(PriseRdvController.handleNotifications(_:)), name: Constants.notificationeventupdateerror, object: nil)
        NSNotificationCenter.defaultCenter().setObserver(self, selector: #selector(RdvTableViewController.handleNotifications(_:)), name: Constants.notificationconxerror, object: nil)
        
        NSNotificationCenter.defaultCenter().setObserver(self, selector: #selector(RdvTableViewController.handleNotifications(_:)), name: Constants.notificationeventconxerror, object: nil)
        
        dispatch_async(dispatch_get_main_queue(), {
            self.dateField.text = CalendarSingleton.sharedInstance.event.start?.asDateString
        })
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    override func viewDidLayoutSubviews() {
        self.view.viewWithTag(2)?.layer.cornerRadius = 10
        self.view.viewWithTag(1)?.layer.cornerRadius = 10
        self.view.viewWithTag(2)?.layer.borderWidth = 3.0
        self.view.viewWithTag(2)?.layer.borderColor = UIColor.brownColor().CGColor
        self.view.viewWithTag(1)?.layer.borderWidth = 3.0
        self.view.viewWithTag(1)?.layer.borderColor = UIColor.brownColor().CGColor
        
        let imageProfil = self.view.viewWithTag(3) as! UIImageView
        imageProfil.layer.cornerRadius = imageProfil.frame.size.width/2
        imageProfil.clipsToBounds = true
        imageProfil.layer.borderWidth = 3.0
        imageProfil.layer.borderColor = UIColor.cyanColor().CGColor
        imageProfil.layer.backgroundColor = UIColor.brownColor().CGColor
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func valider(sender: UIButton) {
        self.view.addSubview(self.loadingView)
        self.loadingView.showLoadingIndicator()
        self.view.multipleTouchEnabled = false
        ApiManager.UpdateCalendar(UserSingleton.sharedInstance.user.calendarId!,eventId: CalendarSingleton.sharedInstance.event.id!)
        
    }
    
    
    
    
    @IBAction func annuler(sender: UIButton) {
        
        self.navigationController?.popViewControllerAnimated(true);
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
                    self.loadingView.hideLoadingIndicator()
                    self.view.multipleTouchEnabled = true
                    let viewAlert = UIAlertController(title: "réservation", message: "votre réservartion a été bien éffectuée ", preferredStyle: .Alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: { _ in
                        self.navigationController?.popViewControllerAnimated(true)
                        NSNotificationCenter.defaultCenter().postNotificationName(Constants.notificationeventupdateokreload, object: nil)
                    })
                    
                    viewAlert.addAction(defaultAction)
                    self.presentViewController(viewAlert, animated: true, completion: {})
                })
            })
            
        }
        
        if notification.name == Constants.notificationeventupdateerror {
            
            dispatch_async(dispatch_get_main_queue(), {
                self.loadingView.hideLoadingIndicator()
                self.view.multipleTouchEnabled = true
                let alerview = UIAlertView(title: "errorr",message: "erreur de connexion ", delegate: self, cancelButtonTitle: "ok")
                alerview.show()
            })
        }
        
        if notification.name == Constants.notificationeventconxerror {
            
            dispatch_async(dispatch_get_main_queue(), {
                self.loadingView.hideLoadingIndicator()
                self.view.multipleTouchEnabled = true
                let alerview = UIAlertView(title: "errorr",message: "erreur de connexion ", delegate: self, cancelButtonTitle: "ok")
                alerview.show()
            })
        }
        
        
        NSNotificationCenter.defaultCenter().removeObserver(notification.name)
        
    }
    
    
}

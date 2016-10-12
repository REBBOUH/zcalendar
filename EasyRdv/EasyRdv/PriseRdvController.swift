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
        
        

        NotificationCenter.default.setObserver(self, selector: #selector(PriseRdvController.handleNotifications(_:)), name: Constants.notificationeventupdateok, object: nil)
        NotificationCenter.default.setObserver(self, selector: #selector(PriseRdvController.handleNotifications(_:)), name: Constants.notificationeventupdateerror, object: nil)
        NotificationCenter.default.setObserver(self, selector: #selector(RdvTableViewController.handleNotifications(_:)), name: Constants.notificationconxerror, object: nil)
        
        NotificationCenter.default.setObserver(self, selector: #selector(RdvTableViewController.handleNotifications(_:)), name: Constants.notificationeventconxerror, object: nil)
        
        DispatchQueue.main.async(execute: {
            self.dateField.text = CalendarSingleton.sharedInstance.event.start?.asDateString
        })
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func viewDidLayoutSubviews() {
        self.view.viewWithTag(2)?.layer.borderWidth = 3.0
        self.view.viewWithTag(2)?.layer.borderColor = UIColor.brown.cgColor
        self.view.viewWithTag(1)?.layer.borderWidth = 3.0
        self.view.viewWithTag(1)?.layer.borderColor = UIColor.brown.cgColor
        
        let imageProfil = self.view.viewWithTag(3) as! UIImageView
        imageProfil.layer.cornerRadius = imageProfil.frame.size.width/2
        imageProfil.clipsToBounds = true
        imageProfil.layer.borderWidth = 3.0
        imageProfil.layer.borderColor = UIColor.cyan.cgColor
        imageProfil.layer.backgroundColor = UIColor.brown.cgColor
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func valider(_ sender: UIButton) {
        self.view.addSubview(self.loadingView)
        self.loadingView.showLoadingIndicator()
        self.view.isMultipleTouchEnabled = false
        EventApi.ADD(UserSingleton.sharedInstance.user.calendarId!,eventId: CalendarSingleton.sharedInstance.event.id!)
        
    }
    
    
    
    
    @IBAction func annuler(_ sender: UIButton) {
        
        self.navigationController!.popViewController(animated: true);
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
    
 @objc func  handleNotifications(_ notification:Notification) {
        if notification.name == .notificationeventupdateok {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
             DispatchQueue.global(qos: .default).async(execute: {
                
                DispatchQueue.main.async(execute: {
                    self.loadingView.hideLoadingIndicator()
                    self.view.isMultipleTouchEnabled = true
                    let viewAlert = UIAlertController(title: "réservation", message: "votre réservartion a été bien éffectuée ", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                        self.navigationController!.popViewController(animated: true)
                        NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.notificationeventupdateokreload), object: nil)
                    })
                    
                    viewAlert.addAction(defaultAction)
                    self.present(viewAlert, animated: true, completion: {})
                })
            })
            
        }
        
        if notification.name == .notificationeventupdateerror {
            
            DispatchQueue.main.async(execute: {
                self.loadingView.hideLoadingIndicator()
                self.view.isMultipleTouchEnabled = true
                let alerview = UIAlertView(title: "errorr",message: "erreur de connexion ", delegate: self, cancelButtonTitle: "ok")
                alerview.show()
            })
        }
        
        if notification.name == .notificationeventconxerror {
            
            DispatchQueue.main.async(execute: {
                self.loadingView.hideLoadingIndicator()
                self.view.isMultipleTouchEnabled = true
                let alerview = UIAlertView(title: "errorr",message: "erreur de connexion ", delegate: self, cancelButtonTitle: "ok")
                alerview.show()
            })
        }
        
        
        NotificationCenter.default.removeObserver(notification.name)
        
    }
    
    
}

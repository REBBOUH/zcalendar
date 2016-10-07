//
//  CreerCompteViewController.swift
//  EasyRdv
//
//  Created by Yassir Aberni on 06/10/2016.
//  Copyright © 2016 Yassir Aberni. All rights reserved.
//

import UIKit

class CreerCompteViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var imageLogo: UIImageView!
    
    @IBOutlet weak var mailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var numeroField: UITextField!
    
    @IBOutlet weak var passwordFieldConf: UITextField!
    
    @IBOutlet weak var topConstraintView: NSLayoutConstraint!
    
    @IBOutlet weak var viewConx: UIView!
    
    var loadingView:LoadingViewCustome!
    
    var beginEdit = false
    
    var valuesValid = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // textField delegate
        mailField.delegate = self
        passwordField.delegate = self
        passwordFieldConf.delegate = self
        numeroField.delegate = self
        
        loadingView = LoadingViewCustome(frame: CGRect(origin: CGPoint(x:self.view.frame.midX - 100 ,y:self.view.frame.midY), size: CGSize(width: 200, height: 200)))
        
        let TapGestureRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreerCompteViewController.tapView))
        
        self.view.addGestureRecognizer(TapGestureRecognizer)
        
        NSNotificationCenter.defaultCenter().setObserver(self, selector: #selector(CreerCompteViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil);
        
        NSNotificationCenter.defaultCenter().setObserver(self, selector: #selector(CreerCompteViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil);
        
        NSNotificationCenter.defaultCenter().setObserver(self, selector: #selector(CreerCompteViewController.handleNotifications(_:)), name: Constants.notificationuseraddok, object: nil)
        
        NSNotificationCenter.defaultCenter().setObserver(self, selector: #selector(CreerCompteViewController.handleNotifications(_:)), name: Constants.notificationuseradderror, object: nil)
        
         NSNotificationCenter.defaultCenter().setObserver(self, selector: #selector(CreerCompteViewController.handleNotifications(_:)), name: Constants.notificationconxerror, object: nil)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
   
        self.view.viewWithTag(1)?.layer.cornerRadius =  20
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func  textFieldShouldEndEditing(textField: UITextField) -> Bool {
        
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
       
        if textField.text?.characters.count > 0 {
            if textField.tag == self.mailField.tag {
                if !(mailField.text?.isEmail)! {
                    
                    mailField.layer.borderColor = UIColor.redColor().CGColor
                    mailField.layer.borderWidth = 2
                    return
                }
            }
            
            if textField.tag == self.passwordField.tag {
                if textField.text?.characters.count < 5 {
                    
                    passwordField.text = ""
                    passwordField.layer.borderColor = UIColor.redColor().CGColor
                    passwordField.layer.borderWidth = 2
                    passwordField.placeholder = "Mot de passe inférieur à 5 charactere"
              
                    return
                
                }
            }
            
            if textField.tag == self.numeroField.tag {
                if !(numeroField.text?.isPhoneNumber)! {
                    
                    numeroField.layer.borderWidth = 2
                    numeroField.layer.borderColor = UIColor.redColor().CGColor
                    return
                }
            }
            textField.layer.borderWidth = 0
       
            
        }
        if (checkTextField()){
            (self.view.viewWithTag(1) as! UIButton).enabled = true
        }else{
            (self.view.viewWithTag(1) as! UIButton).enabled = false
        }
        
    }
    
    func checkTextField() -> Bool{
        if ((mailField.text!.lowercaseString == passwordFieldConf.text!.lowercaseString) && (mailField.text?.isEmail)! && ((passwordField.text?.characters.count)! >= 5) && (numeroField.text?.isPhoneNumber)! ) {
            return true
        }
        return false
    }
    
    func tapView(){
        
        self.view.endEditing(false)
    }
    
    
    
    @IBAction func creerCompte(sender: AnyObject) {
        
        UserApi.ADD(createUserJson(), begin: {
            
            }, success: {})
    
    }
    
    func createUserJson() -> [String:AnyObject]{
        let user:[String:AnyObject] =  ["user" : ["mail":mailField.text!,"password":passwordField.text!,"number":numeroField.text!,"isClient":false]]
        return user;
    }
    
    
    func keyboardWillShow(sender: NSNotification) {
        let dict:NSDictionary = sender.userInfo! as NSDictionary
        if !beginEdit {
            let s:NSValue = dict.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue;
            let rect :CGRect = s.CGRectValue();
            var frame = self.viewConx.frame;
            if frame.origin.y < 0 {
                
                frame.origin.y = 0
            }else{
                frame.origin.y = frame.origin.y - rect.height;
                topConstraintView.constant = -100
            }
            beginEdit = true
            self.viewConx.frame = frame;
            self.viewConx.layoutIfNeeded()
            
            NSNotificationCenter.defaultCenter().removeObserver(sender.name)
        }
        
    }
    
    func keyboardWillHide(sender: NSNotification) {
        let dict:NSDictionary = sender.userInfo! as NSDictionary
        let s:NSValue = dict.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue;
        let rect :CGRect = s.CGRectValue();
        var frame = self.viewConx.frame;
        frame.origin.y = frame.origin.y + rect.height/2;
        topConstraintView.constant = topConstraintView.constant + 100
        self.viewConx.frame = frame;
        beginEdit = false
        self.viewConx.layoutIfNeeded()
        NSNotificationCenter.defaultCenter().removeObserver(sender.name)
    }
    
    // MARK - handle notification
    
    func  handleNotifications(notification:NSNotification) {
        if notification.name == Constants.notificationuseraddok {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.loadingView.hideLoadingIndicator()
                    self.view.multipleTouchEnabled = true
                    let viewAlert = UIAlertController(title: "Compte", message: "votre compte a été bien crée ", preferredStyle: .Alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: { _ in
                        
                        
                    })
                    
                    viewAlert.addAction(defaultAction)
                    self.presentViewController(viewAlert, animated: true, completion: {})
                })
            })
            
        }
        
        if notification.name == Constants.notificationuseradderror {
            
            dispatch_async(dispatch_get_main_queue(), {
                self.loadingView.hideLoadingIndicator()
                self.view.multipleTouchEnabled = true
                let alerview = UIAlertView(title: "errorr",message: "cet utilisateur existe deja  ", delegate: self, cancelButtonTitle: "ok")
                alerview.show()
            })
        }
        if notification.name == Constants.notificationconxerror {
            
            dispatch_async(dispatch_get_main_queue(), {
                self.loadingView.hideLoadingIndicator()
                self.view.multipleTouchEnabled = true
                let alerview = UIAlertView(title: "errorr",message: "erreur de connexion  ", delegate: self, cancelButtonTitle: "ok")
                alerview.show()
            })
        }
        
        
        
        NSNotificationCenter.defaultCenter().removeObserver(notification.name)
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

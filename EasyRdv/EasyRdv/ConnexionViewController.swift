//
//  ConnexionViewController.swift
//  EasyRdv
//
//  Created by Yassir Aberni on 05/10/2016.
//  Copyright © 2016 Yassir Aberni. All rights reserved.
//

import UIKit

class ConnexionViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var login: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var viewConx: UIView!
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
   
    var loadingView:LoadingViewCustome!
    
    var beginEdit = false
    
    var imageframe:CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let TapGestureRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ConnexionViewController.tapView))
        
        self.view.addGestureRecognizer(TapGestureRecognizer)
        
        self.login.delegate = self
        
        self.password.delegate = self
        
        loadingView = LoadingViewCustome(frame: CGRect(origin: CGPoint(x:self.view.frame.midX - 100 ,y:self.view.frame.midY), size: CGSize(width: 200, height: 200)))
        
        NSNotificationCenter.defaultCenter().setObserver(self, selector: #selector(ConnexionViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil);
        
        NSNotificationCenter.defaultCenter().setObserver(self, selector: #selector(ConnexionViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil);
        
        NSNotificationCenter.defaultCenter().setObserver(self, selector: #selector(ConnexionViewController.handleNotifications(_:)), name:Constants.notificationusergetok, object: nil);
        
        NSNotificationCenter.defaultCenter().setObserver(self, selector: #selector(ConnexionViewController.handleNotifications(_:)), name:Constants.notificationconxerror, object: nil);
        
        NSNotificationCenter.defaultCenter().setObserver(self, selector: #selector(ConnexionViewController.handleNotifications(_:)), name:Constants.notificationusergeterror, object: nil);
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        animationLogo()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        
        self.view.viewWithTag(1)?.layer.cornerRadius =  10
        self.view.viewWithTag(2)?.layer.cornerRadius = 10
        
        
    }
    
    @IBAction func connexion(sender: UIButton) {
        
        let mail:String = (self.view.viewWithTag(3) as! UITextField).text!.lowercaseString
        
        let password:String = (self.view.viewWithTag(4) as! UITextField).text!
        
        let data = NSString(string: "\(mail):\(password)")
        print(data)
        UserApi.CONNECT(data, begin: {
            
            self.view.addSubview(self.loadingView)
            self.loadingView.showLoadingIndicator()
            self.view.userInteractionEnabled = false
            
            }, success: {})
        
    }
    
    
    @IBAction func creerCompte(sender: UIButton) {
        
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
            if textField.tag == self.login.tag {
                if !(login.text?.isEmail)! {
                    
                    login.layer.borderColor = UIColor.redColor().CGColor
                    login.layer.borderWidth = 2
                    
                    return
                }
            }
            
            if textField.tag == self.password.tag {
                if textField.text?.characters.count < 5 {
                    
                    password.text = ""
                    password.layer.borderColor = UIColor.redColor().CGColor
                    password.layer.borderWidth = 2
                    password.placeholder = "Mot de passe inférieur à 5 charactere"
                    
                    return
                    
                }
            }
            
            textField.layer.borderWidth = 0
            
        }
        
        if (checkTextField()){
            
            (self.view.viewWithTag(2) as! UIButton).enabled = true
       
        }else{
         
            (self.view.viewWithTag(2) as! UIButton).enabled = false
        
        }
        
        
    }
    
    func checkTextField() -> Bool{
        if ((login.text?.isEmail)! && ((password.text?.characters.count)! >= 5)) {
            return true
        }
        return false
    }
    
    
    
    // MARK: - gesture recognizer
    
    func tapView(){
        
        self.view.endEditing(false)
    }
    
    func animationLogo(){
        
        imageframe = logoImageView.center
        
        self.logoImageView.center = CGPoint(x: self.imageframe!.x * 3, y: self.imageframe!.y)
        
        
        UIView.animateWithDuration(2, animations: {
            
            self.logoImageView.center = CGPoint(x: self.imageframe!.x, y: self.imageframe!.y)
            
            
            }, completion: {(isfinish:Bool) -> (
                ) in
                
                self.logoImageView.center = self.imageframe!
                
        } )
    }
    
    func  handleNotifications(notification:NSNotification) {
        if notification.name == Constants.notificationusergetok {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.loadingView.hideLoadingIndicator()
                    self.view.userInteractionEnabled = true
                    let viewAlert = UIAlertController(title: "Compte", message: "bienvenue ", preferredStyle: .Alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: { _ in
                        
                        
                    })
                    
                    viewAlert.addAction(defaultAction)
                    self.presentViewController(viewAlert, animated: true, completion: {})
                })
            })
            
        }
        
        if notification.name == Constants.notificationconxerror {
            
            dispatch_async(dispatch_get_main_queue(), {
                self.loadingView.hideLoadingIndicator()
                self.view.userInteractionEnabled = true
                let alerview = UIAlertView(title: "errorr",message: "erreur de connexion ", delegate: self, cancelButtonTitle: "ok")
                alerview.show()
            })
        }
        
        if notification.name == Constants.notificationusergeterror {
            
            dispatch_async(dispatch_get_main_queue(), {
                self.loadingView.hideLoadingIndicator()
                self.view.userInteractionEnabled = true
                let alerview = UIAlertView(title: "erreur de compte",message: "ce compte n'existe pas  ", delegate: self, cancelButtonTitle: "ok")
                alerview.show()
            })
        }

        
        NSNotificationCenter.defaultCenter().removeObserver(notification.name)
        
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
                self.topConstraint.constant = -100
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
        self.topConstraint.constant = self.topConstraint.constant + 100
        self.viewConx.frame = frame;
        beginEdit = false
        self.viewConx.layoutIfNeeded()
        NSNotificationCenter.defaultCenter().removeObserver(sender.name)
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

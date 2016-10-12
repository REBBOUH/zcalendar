//
//  CreerCompteViewController.swift
//  EasyRdv
//
//  Created by Yassir Aberni on 06/10/2016.
//  Copyright © 2016 Yassir Aberni. All rights reserved.
//

import UIKit



class CreerCompteViewController: UIViewController,UITextFieldDelegate {
    
   
    
    @IBOutlet weak var nameField: UITextField!
    
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
        
        NotificationCenter.default.setObserver(self, selector: #selector(CreerCompteViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow.rawValue, object: nil)
        NotificationCenter.default.setObserver(self, selector: #selector(CreerCompteViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide.rawValue, object: nil)
        
        NotificationCenter.default.setObserver(self, selector: #selector(CreerCompteViewController.handleNotifications(_:)), name: Constants.notificationuseraddok, object: nil)
        
        NotificationCenter.default.setObserver(self, selector: #selector(CreerCompteViewController.handleNotifications(_:)), name: Constants.notificationuseradderror, object: nil)
        
        NotificationCenter.default.setObserver(self, selector: #selector(CreerCompteViewController.handleNotifications(_:)), name: Constants.notificationconxerror, object: nil)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        
        self.view.viewWithTag(1)?.layer.cornerRadius =  20
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func  textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if (textField.text?.characters.count)! > 0 {
            if textField.tag == self.mailField.tag {
                if !(mailField.text?.isEmail)! {
                    
                    mailField.layer.borderColor = UIColor.red.cgColor
                    mailField.layer.borderWidth = 2
                    return
                }
            }
            
            if textField.tag == self.passwordField.tag {
                if (textField.text?.characters.count)! < 5 {
                    
                    passwordField.text = ""
                    passwordField.layer.borderColor = UIColor.red.cgColor
                    passwordField.layer.borderWidth = 2
                    passwordField.placeholder = "Mot de passe inférieur à 5 charactere"
                    
                    return
                    
                }
            }
            
            if textField.tag == self.numeroField.tag {
                if !(numeroField.text?.isPhoneNumber)! {
                    
                    numeroField.layer.borderWidth = 2
                    numeroField.layer.borderColor = UIColor.red.cgColor
                    return
                }
            }
            
            if textField.tag == self.nameField.tag {
                if !(nameField.text?.isEmpty)! {
                    
                    numeroField.layer.borderWidth = 2
                    numeroField.layer.borderColor = UIColor.red.cgColor
                    passwordField.placeholder = "ce champ est obligatoir"
                    return
                }
            }
            
            textField.layer.borderWidth = 0
            
            
        }
        if (checkTextField()){
            (self.view.viewWithTag(1) as! UIButton).isEnabled = true
        }else{
            (self.view.viewWithTag(1) as! UIButton).isEnabled = false
        }
        
    }
    
    func checkTextField() -> Bool{
        if ((mailField.text!.lowercased() == passwordFieldConf.text!.lowercased()) && (mailField.text?.isEmail)! && ((passwordField.text?.characters.count)! >= 5) && (numeroField.text?.isPhoneNumber)! && (!(nameField.text?.isEmpty)!) ) {
            return true
        }
        return false
    }
    
    func tapView(){
        
        self.view.endEditing(false)
    }
    
    
    
    @IBAction func creerCompte(_ sender: AnyObject) {
        
        UserApi.ADD(userInfo: createUserJson() as [String : AnyObject], begin: {
            
            self.view.addSubview(self.loadingView)
            self.loadingView.showLoadingIndicator()
            self.view.isUserInteractionEnabled = false
            
            }, success: {
                DataManager.initUserInfo(self.createUserJson())
        })
        
    }
    
    func createUserJson() -> [String:Any]{
        let user:[String:Any] =  ["user" : ["mail":mailField.text!,"password":passwordField.text!,"name":nameField.text!,"number":numeroField.text!,"isClient":false]]
        return user;
    }
    
    
    func keyboardWillShow(_ sender: Notification) {
        let dict:NSDictionary = (sender as NSNotification).userInfo! as NSDictionary
        if !beginEdit {
            let s:NSValue = dict.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue;
            let rect :CGRect = s.cgRectValue;
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
            
            NotificationCenter.default.removeObserver(sender.name)
        }
        
    }
    
    func keyboardWillHide(_ sender: Notification) {
        let dict:NSDictionary = (sender as NSNotification).userInfo! as NSDictionary
        let s:NSValue = dict.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue;
        let rect :CGRect = s.cgRectValue;
        var frame = self.viewConx.frame;
        frame.origin.y = frame.origin.y + rect.height/2;
        topConstraintView.constant = topConstraintView.constant + 100
        self.viewConx.frame = frame;
        beginEdit = false
        self.viewConx.layoutIfNeeded()
        NotificationCenter.default.removeObserver(sender.name)
    }
    
    // MARK - handle notification
    
    func  handleNotifications(_ notification:Notification) {
        if notification.name == .notificationuseraddok {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            DispatchQueue.global(qos: .default).async(execute: {
                
                DispatchQueue.main.async(execute: {
                    self.loadingView.hideLoadingIndicator()
                    self.view.isMultipleTouchEnabled = true
                    let viewAlert = UIAlertController(title: "Compte", message: "votre compte a été bien crée ", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                        
                        self.dismiss(animated: true, completion: {})
                        
                    })
                    
                    viewAlert.addAction(defaultAction)
                    self.present(viewAlert, animated: true, completion: {})
                })
            })
            
        }
        
        if notification.name == .notificationuseradderror {
            
            DispatchQueue.main.async(execute: {
                self.loadingView.hideLoadingIndicator()
                self.view.isMultipleTouchEnabled = true
                let alerview = UIAlertView(title: "errorr",message: "cet utilisateur existe deja  ", delegate: self, cancelButtonTitle: "ok")
                alerview.show()
            })
        }
        if notification.name == .notificationconxerror {
            
            DispatchQueue.main.async(execute: {
                self.loadingView.hideLoadingIndicator()
                self.view.isMultipleTouchEnabled = true
                let alerview = UIAlertView(title: "errorr",message: "erreur de connexion  ", delegate: self, cancelButtonTitle: "ok")
                alerview.show()
            })
        }
        
        
        
        NotificationCenter.default.removeObserver(notification.name)
        
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

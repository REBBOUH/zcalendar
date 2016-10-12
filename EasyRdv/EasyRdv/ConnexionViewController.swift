//
//  ConnexionViewController.swift
//  EasyRdv
//
//  Created by Yassir Aberni on 05/10/2016.
//  Copyright © 2016 Yassir Aberni. All rights reserved.
//

import UIKit

class ConnexionViewController: UIViewController,UITextFieldDelegate{
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
        
        //self.transitioningDelegate = self
        
       
        
                loadingView = LoadingViewCustome(frame: CGRect(origin: CGPoint(x:self.view.frame.midX - 100 ,y:self.view.frame.midY), size: CGSize(width: 200, height: 200)))
        
        NotificationCenter.default.setObserver(self, selector: #selector(ConnexionViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow.rawValue, object: nil)
        NotificationCenter.default.setObserver(self, selector: #selector(ConnexionViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide.rawValue, object: nil)
        NotificationCenter.default.setObserver(self, selector: #selector(ConnexionViewController.handleNotifications(notification:)), name:Constants.notificationusergetok.rawValue, object: nil);
        
        NotificationCenter.default.setObserver(self, selector: #selector(ConnexionViewController.handleNotifications(notification:)), name:Constants.notificationconxerror.rawValue, object: nil);
        
        NotificationCenter.default.setObserver(self, selector: #selector(ConnexionViewController.handleNotifications(notification:)), name:Constants.notificationusergeterror.rawValue, object: nil);
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        //  animationLogo()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        
        self.view.viewWithTag(1)?.layer.cornerRadius =  10
        self.view.viewWithTag(2)?.layer.cornerRadius = 10
        
        
    }
    
    @IBAction func connexion(_ sender: UIButton) {
        
        let mail:String = (self.view.viewWithTag(3) as! UITextField).text!.lowercased()
        
        let password:String = (self.view.viewWithTag(4) as! UITextField).text!
        
        let data = NSString(string: "\(mail):\(password)")
        print(data)
        
        UserApi.CONNECT(value: data, begin: { self.view.addSubview(self.loadingView)
            self.loadingView.showLoadingIndicator()
            self.view.isUserInteractionEnabled = false
            
            }, success: {})
        
    }
    
    
    @IBAction func creerCompte(_ sender: UIButton) {
        
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
            if textField.tag == self.login.tag {
                if !(login.text?.isEmail)! {
                    
                    login.layer.borderColor = UIColor.red.cgColor
                    login.layer.borderWidth = 2
                    
                    return
                }
            }
            
            if textField.tag == self.password.tag {
                if (textField.text?.characters.count)! < 5 {
                    
                    password.text = ""
                    password.layer.borderColor = UIColor.red.cgColor
                    password.layer.borderWidth = 2
                    password.placeholder = "Mot de passe inférieur à 5 charactere"
                    
                    return
                    
                }
            }
            
            textField.layer.borderWidth = 0
            
        }
        
        if (checkTextField()){
            
            (self.view.viewWithTag(2) as! UIButton).isEnabled = true
            
        }else{
            
            (self.view.viewWithTag(2) as! UIButton).isEnabled = false
            
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
        
        
        UIView.animate(withDuration: 2, animations: {
            
            self.logoImageView.center = CGPoint(x: self.imageframe!.x, y: self.imageframe!.y)
            
            
            }, completion: {(isfinish:Bool) -> (
                ) in
                
                self.logoImageView.center = self.imageframe!
                
        } )
    }
    
func handleNotifications(notification:NSNotification) {
        if notification.name == .notificationusergetok {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
           DispatchQueue.global(qos: .default).async(execute: {
                
                DispatchQueue.main.async(execute: {
                    self.loadingView.hideLoadingIndicator()
                    self.view.isUserInteractionEnabled = true
                    let viewAlert = UIAlertController(title: "Compte", message: "bienvenue ", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                        
                        let userView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "calendarlist")
                        
                        self.present(userView, animated: false, completion: {})
                        
                    })
                    
                    viewAlert.addAction(defaultAction)
                    self.present(viewAlert, animated: true, completion: {})
                })
            })
            
        }
        
        if notification.name == .notificationconxerror {
            
            DispatchQueue.main.async(execute: {
                self.loadingView.hideLoadingIndicator()
                self.view.isUserInteractionEnabled = true
                let alerview = UIAlertController(title: "errorr",message: "erreur de connexion ", preferredStyle: .alert)
               self.present(alerview, animated: true, completion: {})
            })
        }
        
        if notification.name == .notificationusergeterror {
            
            DispatchQueue.main.async(execute: {
                self.loadingView.hideLoadingIndicator()
                self.view.isUserInteractionEnabled = true
    
                
                let alerview = UIAlertController(title: "erreur de compte",message: "ce compte n'existe pas  ", preferredStyle: .alert)
                self.present(alerview, animated: true, completion: {})
            })
        }
        
        
        NotificationCenter.default.removeObserver(notification.name)
        
    }
    
    
    func keyboardWillShow(_ sender: NSNotification) {
        
        let dict:NSDictionary = (sender as NSNotification).userInfo! as NSDictionary
        if !beginEdit {
            let s:NSValue = dict.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue;
            let rect :CGRect = s.cgRectValue;
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
            
            NotificationCenter.default.removeObserver(sender.name)
        }
        
    }
    
    func keyboardWillHide(_ sender: NSNotification) {
        
        let dict:NSDictionary = (sender as NSNotification).userInfo! as NSDictionary
        let s:NSValue = dict.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue;
        let rect :CGRect = s.cgRectValue;
        var frame = self.viewConx.frame;
        frame.origin.y = frame.origin.y + rect.height/2;
        self.topConstraint.constant = self.topConstraint.constant + 100
        self.viewConx.frame = frame;
        beginEdit = false
        self.viewConx.layoutIfNeeded()
        NotificationCenter.default.removeObserver(sender.name)
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



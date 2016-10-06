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
    
    
    var beginEdit = false
    
    var imageframe:CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let TapGestureRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ConnexionViewController.tapView))
        
        self.view.addGestureRecognizer(TapGestureRecognizer)
        
        self.login.delegate = self
        
        self.password.delegate = self
        
        NSNotificationCenter.defaultCenter().setObserver(self, selector: #selector(ConnexionViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil);
        
        NSNotificationCenter.defaultCenter().setObserver(self, selector: #selector(ConnexionViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil);
        
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

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
    
    var beginEdit = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mailField.delegate = self
        passwordField.delegate = self
        passwordFieldConf.delegate = self
        numeroField.delegate = self
        
        let TapGestureRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreerCompteViewController.tapView))
        
        self.view.addGestureRecognizer(TapGestureRecognizer)
        
        NSNotificationCenter.defaultCenter().setObserver(self, selector: #selector(CreerCompteViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil);
        
        NSNotificationCenter.defaultCenter().setObserver(self, selector: #selector(CreerCompteViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil);
        
        NSNotificationCenter.defaultCenter().setObserver(self, selector: #selector(CreerCompteViewController.handleNotifications(_:)), name: Constants.notificationconxerror, object: nil)
        
        NSNotificationCenter.defaultCenter().setObserver(self, selector: #selector(CreerCompteViewController.handleNotifications(_:)), name: Constants.notificationeventconxerror, object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    func tapView(){
        
        self.view.endEditing(false)
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
                self.topConstraintView.constant = -100
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
        self.topConstraintView.constant = self.topConstraintView.constant + 100
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

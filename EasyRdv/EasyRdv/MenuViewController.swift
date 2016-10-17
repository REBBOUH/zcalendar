//
//  MenuViewController.swift
//  EasyRdv
//
//  Created by Yassir Aberni on 10/10/2016.
//  Copyright © 2016 Yassir Aberni. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {
    
    var animationObject:ObjectAnimation = ObjectAnimation()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
    
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.hidesBarsOnSwipe = false
    }
    
    @IBAction func unwindToMainViewController (_ sender: UIStoryboardSegue){
        // bug? exit segue doesn't dismiss so we do it manually...
        sender.source.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override  func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        print("section \(Constants.SectionCell.count)")
        return Constants.SectionCell.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("number of row  \(Constants.titleCell[section].count) in section \(section)")
        return Constants.titleCell[section].count
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "sectioncell")! as UITableViewCell
        (cell.viewWithTag(1) as! UILabel).text = Constants.SectionCell[section] as String
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "accueilcell", for: indexPath) as! MenuCell
            
            print("value is \(Constants.titleCell[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row])")
            
            cell.buttonCell.titleLabel?.text = Constants.titleCell[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
            
            let image = UIImage(named: Constants.imageCell[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row])
            
            cell.imageCell.image = image
            return cell
            
        }else{
            if indexPath.section == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "shutdowncell", for: indexPath) as! MenuCell
                
                print("value is \(Constants.titleCell[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row])")
                
                cell.buttonCell.titleLabel?.text = Constants.titleCell[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
                
                let image = UIImage(named: Constants.imageCell[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row])
                
                cell.imageCell.image = image
                return cell
                
            }else{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "menucell", for: indexPath) as! MenuCell
                
                print("value is \(Constants.titleCell[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row])")
                
                cell.titleCell.text = Constants.titleCell[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
                
                let image = UIImage(named: Constants.imageCell[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row])
                
                cell.imageCell.image = image
                return cell
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toconnexionview" {
         
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.switchBack()
        }
    }
}



//
//  LeftSideViewController.swift
//  CapstoneUserLoginAndRegistration
//
//  Created by Yuecan Fan on 2/16/16.
//  Copyright © 2016 Northeastern University. All rights reserved.
//

import UIKit

class LeftSideViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    var menuItems:[String] = ["Street Parking View","Profile","Sign Out"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return menuItems.count
    
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath)
        
        myCell.textLabel?.text = menuItems[indexPath.row]
        return myCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch(indexPath.row){
            
        case 0:
            let aboutViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AboutViewController") as! AboutViewController
            let aboutPageNav = UINavigationController(rootViewController: aboutViewController)
            
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.drawerContainer!.centerViewController = aboutPageNav
            appDelegate.drawerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            
            break
            
        case 1:
            let mainPageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MainPageViewController") as! MainPageViewController
            let mainPageNav = UINavigationController(rootViewController: mainPageViewController)
            
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.drawerContainer!.centerViewController = mainPageNav
            appDelegate.drawerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            
            break
            
            
        case 2:
            NSUserDefaults.standardUserDefaults().removeObjectForKey("userFirstName")
            NSUserDefaults.standardUserDefaults().removeObjectForKey("userLastName")
            
            NSUserDefaults.standardUserDefaults().removeObjectForKey("userId")
            
            NSUserDefaults.standardUserDefaults().synchronize()
            
            let signInPage = self.storyboard?.instantiateViewControllerWithIdentifier("HomePage") as! HomePage
            let signInNav = UINavigationController(rootViewController: signInPage)
            let appDelegate = UIApplication.sharedApplication().delegate
            appDelegate?.window??.rootViewController = signInNav
            
            break
            
        default:
            print("Not handled")

            
            
        }
    
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

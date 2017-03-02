//
//  LoginViewController.swift
//  CapstoneUserLoginAndRegistration
//
//  Created by Yuecan Fan on 1/18/16.
//  Copyright © 2016 Northeastern University. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    
    
    @IBOutlet weak var userEmailLoginText: UITextField!
 
    
    
    @IBOutlet weak var userPasswordLoginText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
    
               let userEmail = userEmailLoginText.text
               let userPassword = userPasswordLoginText.text
        
        if(userEmail!.isEmpty || userPassword!.isEmpty){
            //display an alert message
            let myAlert = UIAlertController(title: "Alert", message: "All fields are required to fill in", preferredStyle: UIAlertControllerStyle.Alert);
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            myAlert.addAction(okAction);
            self.presentViewController(myAlert, animated: true, completion: nil)
            return
        }
        
        
        let myUrl = NSURL(string: "http://php-fycedward.rhcloud.com/userSignIn.php");
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "POST";
        
        
        let postString = "userEmail=\(userEmail!)&userPassword=\(userPassword!)";
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        
        NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            
            dispatch_async(dispatch_get_main_queue())
                {
                    
                   
                    
                    if error != nil {
                        //display an alert message
                        let myAlert = UIAlertController(title: "Alert", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert);
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                        myAlert.addAction(okAction);
                        self.presentViewController(myAlert, animated: true, completion: nil)
                        return
                    }
                    
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                        
                        if let parseJSON = json {
                            
                            let userId = parseJSON["userId"] as? String
                            
                            if( userId != nil)
                            {
                                
                                NSUserDefaults.standardUserDefaults().setObject(parseJSON["userFirstName"], forKey: "userFirstName")
                                NSUserDefaults.standardUserDefaults().setObject(parseJSON["userLastName"], forKey: "userLastName")
                                NSUserDefaults.standardUserDefaults().setObject(parseJSON["userId"], forKey: "userId")
                                NSUserDefaults.standardUserDefaults().synchronize()
                                
                                //take user to a protected page
                               /*let mainPage = self.storyboard?.instantiateViewControllerWithIdentifier("MainPageViewController")
                                as! MainPageViewController
                                let mainPageNav = UINavigationController(rootViewController: mainPage)

                                let appDelegate = UIApplication.sharedApplication().delegate
                                appDelegate?.window??.rootViewController = mainPageNav*/
                                
                                
                                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                                appDelegate.buildNavigationDrawer()
                                
                                
                            } else {
                                //display an alert message
                                let userMessage = parseJSON["message"] as? String
                                let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert);
                                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                                myAlert.addAction(okAction);
                                self.presentViewController(myAlert, animated: true, completion: nil)
                                
                                
                                
                            }
                            
                        }
                    } catch{
                        print(error)
                    }
                    
                    
                    
            }
            
        }).resume()
        
        
        
    }
    
    
    
    
    func displyMyAlertMessage(userMessage:String){
        let myAlert = UIAlertController(title:"Alert",message:userMessage,preferredStyle: UIAlertControllerStyle.Alert);
        
        let okAction=UIAlertAction(title:"Ok",style:UIAlertActionStyle.Default,handler: nil);
        
        myAlert.addAction(okAction);
        
        
        self.presentViewController(myAlert, animated:true, completion: nil);
    }


}

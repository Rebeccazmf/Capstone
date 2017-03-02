//
//  RegisterPageViewController.swift
//  CapstoneUserLoginAndRegistration
//
//  Created by Yuecan Fan on 1/18/16.
//  Copyright © 2016 Northeastern University. All rights reserved.
//

import UIKit

class RegisterPageViewController: UIViewController {

    @IBOutlet weak var userEmailTextField: UITextField!
    
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    @IBOutlet weak var userFirstNameTextField: UITextField!
    
    @IBOutlet weak var userLastNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerButtonTapped(sender: AnyObject) {
        
        let userEmail = userEmailTextField.text;
        let userPassword = userPasswordTextField.text;
        let userRepeatPassword = repeatPasswordTextField.text;
        let userFirstName = userFirstNameTextField.text;
        let userLastName = userLastNameTextField.text;
        
        
        //Check for empty fields
        if (userEmail!.isEmpty || userPassword!.isEmpty || userRepeatPassword!.isEmpty){
            
            
            //Display alert message
            displyMyAlertMessage("All fields are requried");
            return
            
        }
        
        
        //Check if password match
        if (userPassword != userRepeatPassword)
        {
            displyMyAlertMessage("Passwords does not match");
            
            return;
        }
        
        
        // Send HTTP POST
        
        let myUrl = NSURL(string: "http://php-fycedward.rhcloud.com/userRegister.php");
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "POST";
        
        let postString = "userEmail=\(userEmail!)&userFirstName=\(userFirstName!)&userLastName=\(userLastName!)&userPassword=\(userPassword!)";
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            
            dispatch_async(dispatch_get_main_queue())
                {
                    
                    
                    
                    if error != nil {
                        self.displyMyAlertMessage(error!.localizedDescription)
                        return
                    }
                    
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                        
                        if let parseJSON = json {
                            
                            let userId = parseJSON["userId"] as? String
                            
                            if( userId != nil)
                            {
                                let myAlert = UIAlertController(title: "Alert", message: "Registration successful", preferredStyle: UIAlertControllerStyle.Alert);
                                
                                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){(action) in
                                    
                                    self.dismissViewControllerAnimated(true, completion: nil)
                                }
                                
                                myAlert.addAction(okAction);
                                self.presentViewController(myAlert, animated: true, completion: nil)
                                
                                
                                
                            } else {
                                let errorMessage = parseJSON["message"] as? String
                                if(errorMessage != nil)
                                {
                                    self.displyMyAlertMessage(errorMessage!)
                                }
                                
                            }
                            
                        }
                    } catch{
                        print(error)
                    }
                    
                    
                    
            }
            
        }).resume()
        
        
    }
   
    
    @IBAction func gotoLogin(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
  
    
    func displyMyAlertMessage(userMessage:String){
        let myAlert = UIAlertController(title:"Alert",message:userMessage,preferredStyle: UIAlertControllerStyle.Alert);
        
        let okAction=UIAlertAction(title:"Ok",style:UIAlertActionStyle.Default,handler: nil);
        
        myAlert.addAction(okAction);
        
        
        self.presentViewController(myAlert, animated:true, completion: nil);
        
    }

   
}

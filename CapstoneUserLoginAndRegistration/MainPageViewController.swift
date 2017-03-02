//
//  MainPageViewController.swift
//  CapstoneUserLoginAndRegistration
//
//  Created by Yuecan Fan on 2/16/16.
//  Copyright © 2016 Northeastern University. All rights reserved.
//

import UIKit

class MainPageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

   
    @IBOutlet weak var userFullNameLabel: UILabel!
    
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let userFistName = NSUserDefaults.standardUserDefaults().stringForKey("userFirstName")!
        
        let userLastName = NSUserDefaults.standardUserDefaults().stringForKey("userLastName")!
        
        let userFullName = userFistName + " " + userLastName
        userFullNameLabel.text = userFullName
        
        if(profilePhotoImageView.image == nil)
        {
            let userId = NSUserDefaults.standardUserDefaults().stringForKey("userId")
            let imageUrl = NSURL(string:"http://localhost/Capstone/profile-pictures/\(userId!)/user-profile.jpg")
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                
                let imageData = NSData(contentsOfURL: imageUrl!)
                
                if(imageData != nil)
                {
                    dispatch_async(dispatch_get_main_queue(),{
                        self.profilePhotoImageView.image = UIImage(data: imageData!)
                    })
                }
                
            }
            
        }
        
        
    }
    

    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    @IBAction func selectProfilePhotoButtonTapped(sender: AnyObject) {
        
        let myImagePicker = UIImagePickerController()
        
        myImagePicker.delegate = self
        myImagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        
        self.presentViewController(myImagePicker, animated: true, completion: nil)
    }
 

    
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        profilePhotoImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
        
        myImageUploadRequest()
        
    }
    
    
    func myImageUploadRequest(){
        let myUrl = NSURL(string: "http://php-fycedward.rhcloud.com/scripts/imageUpload.php");
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "POST";
        
        let userId:String? = NSUserDefaults.standardUserDefaults().stringForKey("userId")
        
        let param = ["userId": userId!]
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let imageData = UIImageJPEGRepresentation(profilePhotoImageView.image!, 1)
        
        if(imageData==nil)  { return; }
        
        request.HTTPBody = createBodyWithParameters(param, filePathKey: "file", imageDataKey: imageData!, boundary: boundary)
        
        
        NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            
            
            
            if error != nil {
                // Display an alert message
                return
            }
            
            do {
                
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                
                dispatch_async(dispatch_get_main_queue())
                    {
                        
                        if let parseJSON = json {
                            // let userId = parseJSON["userId"] as? String
                            
                            // Display an alert message
                            let userMessage = parseJSON["message"] as? String
                            self.displayAlertMessage(userMessage!)
                        } else {
                            // Display an alert message
                            let userMessage = "Could not upload image at this time"
                            self.displayAlertMessage(userMessage)
                        }
                }
            } catch
            {
                print(error)
            }
            
        }).resume()
        
        
    }
    
    
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        
        let filename = "user-profile.jpg"
        
        let mimetype = "image/jpg"
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.appendData(imageDataKey)
        body.appendString("\r\n")
        
        
        
        body.appendString("--\(boundary)--\r\n")
        
        return body
    }
    
    
    
    
    func generateBoundaryString() -> String{
        // Create and return a unique string.
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
    
    func displayAlertMessage(userMessage:String)
    {
        let myAlert = UIAlertController(title: "Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert);
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:nil)
        
        myAlert.addAction(okAction);
        
        self.presentViewController(myAlert, animated: true, completion: nil)
        
    }
    
   
 

    /*@IBAction func signOutButtonTapped(sender: AnyObject) {
        
        
       NSUserDefaults.standardUserDefaults().removeObjectForKey("userFirstName")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("userLastName")
        
       NSUserDefaults.standardUserDefaults().removeObjectForKey("userId")
        
       NSUserDefaults.standardUserDefaults().synchronize()
        
        let signInPage = self.storyboard?.instantiateViewControllerWithIdentifier("HomePage") as! HomePage
        let signInNav = UINavigationController(rootViewController: signInPage)
        let appDelegate = UIApplication.sharedApplication().delegate
        appDelegate?.window??.rootViewController = signInNav
    }*/
    

    @IBAction func leftSideButtonTapped(sender: AnyObject) {
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.drawerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
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


extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }
}

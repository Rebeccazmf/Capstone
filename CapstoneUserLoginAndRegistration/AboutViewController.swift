//
//  AboutViewController.swift
//  CapstoneUserLoginAndRegistration
//
//  Created by Yuecan Fan on 2/16/16.
//  Copyright © 2016 Northeastern University. All rights reserved.
//

import UIKit
import GoogleMaps


class AboutViewController: UIViewController,CLLocationManagerDelegate, GMSMapViewDelegate {
    var mapView = GMSMapView()
    var deviceMarker1 = GMSMarker();
    var deviceMarker2 = GMSMarker();
    var deviceMarker3 = GMSMarker();
    var marker = GMSMarker();
    var locationManager = CLLocationManager()
    func mapView(mapView: GMSMapView, didLongPressAtCoordinate coordinate: CLLocationCoordinate2D) {
        let myAlert = UIAlertController(title: "Alert", message: "Did you want to report a parking Slot?", preferredStyle: UIAlertControllerStyle.Alert);
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){(action) in
            let usermarker = GMSMarker()
            usermarker.position = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude)
            usermarker.title = "User Reported Parking Slot"
            usermarker.snippet = "User Rpoerted Parking Slot"
            usermarker.appearAnimation = kGMSMarkerAnimationPop;
            usermarker.icon = GMSMarker.markerImageWithColor(UIColor.blackColor())
            usermarker.draggable = false;
            usermarker.map = mapView
            // use php api to upload this marker
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default){(action) in
            // do nothing
        }
        
        myAlert.addAction(okAction);
        myAlert.addAction(cancelAction);
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
    
    func mapView(mapView: GMSMapView, didTapMarker marker: GMSMarker) -> Bool {
        if marker.title != "User Reported Parking Slot" {
            return false;
        }
        let myAlert = UIAlertController(title: "Alert", message: "Did you want to remove this parking Slot?", preferredStyle: UIAlertControllerStyle.Alert);
        
        let removeAction = UIAlertAction(title: "Remove", style: UIAlertActionStyle.Default){(action) in
            marker.map = nil
            // use php api to delete this marker
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default){(action) in
            // do nothing
        }
        myAlert.addAction(removeAction);
        myAlert.addAction(cancelAction);
        self.presentViewController(myAlert, animated: true, completion: nil)
        return true;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        // A minimum distance a device must move before update event generated
        locationManager.distanceFilter = 500
        // Request permission to use location service
        locationManager.requestWhenInUseAuthorization()
        // Request permission to use location service when the app is run
        locationManager.requestAlwaysAuthorization()
        // Start the update of user's location
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Add GMSMapView to current view
        
        mapView.camera = GMSCameraPosition.cameraWithLatitude(42.339055, longitude: -71.087431, zoom: 16)
        mapView.myLocationEnabled = true
        mapView.delegate = self
        self.view = mapView
        
        deviceMarker1.position = CLLocationCoordinate2DMake(42.339055, -71.087431)
        deviceMarker1.title = "Device Reported Parking Slot"
        deviceMarker1.snippet = "Device Rpoerted Parking Slot"
        deviceMarker1.appearAnimation = kGMSMarkerAnimationPop;
        deviceMarker1.icon = GMSMarker.markerImageWithColor(UIColor.redColor())
        deviceMarker1.draggable = false;
        
        deviceMarker2.position = CLLocationCoordinate2DMake(42.339066, -71.086960)
        deviceMarker2.title = "Device Reported Parking Slot 2"
        deviceMarker2.snippet = "Device Rpoerted Parking Slot 2"
        deviceMarker2.appearAnimation = kGMSMarkerAnimationPop;
        deviceMarker2.icon = GMSMarker.markerImageWithColor(UIColor.redColor())
        deviceMarker2.draggable = false;
        
        
        
        deviceMarker3.position = CLLocationCoordinate2DMake(42.338995, -71.086900)
        deviceMarker3.title = "Device Reported Parking Slot 3"
        deviceMarker3.snippet = "Device Rpoerted Parking Slot 3"
        deviceMarker3.appearAnimation = kGMSMarkerAnimationPop;
        deviceMarker3.icon = GMSMarker.markerImageWithColor(UIColor.redColor())
        deviceMarker3.draggable = false;
        let url1 = NSURL(string:"https://devicecloud.digi.com/ws/DataStream/00000000-00000000-00409DFF-FF819157/xbee.serialIn/[00:13:A2:00:40:F4:A6:DC]!")
        let url2 = NSURL(string:"https://devicecloud.digi.com/ws/DataStream/00000000-00000000-00409DFF-FF819157/xbee.serialIn/[00:13:A2:00:40:E2:D8:6E]!")
        let url3 = NSURL(string:"https://devicecloud.digi.com/ws/DataStream/00000000-00000000-00409DFF-FF819157/xbee.serialIn/[00:13:A2:00:40:E8:81:AD]!")
        
        
        
        let group: dispatch_group_t = dispatch_group_create()
        dispatch_group_async(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            while true {
                
                dispatch_group_async(group,dispatch_get_main_queue()) {
                    // use php api to get all the user markers
                    self.refreshDeviceMarker(url1!, digiMarker: self.deviceMarker1)
                }
                dispatch_group_async(group,dispatch_get_main_queue()) {
                    self.refreshDeviceMarker(url2!, digiMarker: self.deviceMarker2)
                }
                
                dispatch_group_async(group,dispatch_get_main_queue()) {
                    self.refreshDeviceMarker(url3!, digiMarker: self.deviceMarker3)
                }
                
                sleep(2)
            }
        }
    }
    
    func refreshDeviceMarker(url: NSURL, digiMarker: GMSMarker) {
        let authStr: NSString = "fycedward:Fyc646993!"
        let authData: NSData! = authStr.dataUsingEncoding(NSUTF8StringEncoding)
        let authDataStr = authData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        let request: NSMutableURLRequest = NSMutableURLRequest()
        request.URL = url
        request.addValue("Basic "+authDataStr, forHTTPHeaderField: "Authorization")
        request.addValue("Content-Type", forHTTPHeaderField: "text/xml")
        let response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>= nil
        do {
            let result: NSData
            try result = NSURLConnection.sendSynchronousRequest(request, returningResponse: response)
            let resultStr = NSString(data: result, encoding: NSUTF8StringEncoding)
            if !resultStr!.containsString("<data>"){
                return
            }
            let range = resultStr?.rangeOfString("<data>")
            let index = (range?.toRange()?.endIndex)!;
            print(index)
            let display = resultStr?.substringWithRange(NSMakeRange(index, 2))
            if (display == "MA") || (display == "Mg") || (display == "NA"){
                digiMarker.map = self.mapView
            } else{
                digiMarker.map = nil;
            }
        } catch {
            // do nothing
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //    MARK: - CLLocationManagerDelegate Methods
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        if (status == CLAuthorizationStatus.AuthorizedWhenInUse)
        {
            mapView.myLocationEnabled = true
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let newLocation = locations.last
        
        
        mapView.camera = GMSCameraPosition.cameraWithLatitude(42.339055,longitude: -71.087431, zoom: 17)
        mapView.settings.myLocationButton = true
        
        
        mapView.mapType = kGMSTypeNormal
        mapView.settings.compassButton = true
        self.view = self.mapView
        
        
        marker.position = CLLocationCoordinate2DMake(newLocation!.coordinate.latitude, newLocation!.coordinate.longitude)
        
        marker.title = "My Current Location"
        
        marker.map = self.mapView
        
        
        //        let geoCoder = CLGeocoder()
        //        geoCoder.reverseGeocodeLocation(newLocation!, completionHandler: { (placemarks, error) -> Void in
        //            let placeMark = placemarks![0]
        //
        //            if let locationCity = placeMark.addressDictionary!["City"] as? NSString {
        //                marker.title = locationCity as String
        //            }
        //
        //            if let locationName = placeMark.addressDictionary!["Name"] as? NSString {
        //                marker.snippet = locationName as String
        //            }
        //
        //        })
    }
    
    
    
    
    
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


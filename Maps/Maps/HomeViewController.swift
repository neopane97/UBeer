///Users/lorinbrown/Desktop/CIS444/Maps/Maps/RegisterViewController.swift
//  HomeViewController.swift
//  Maps
//
//  Created by Lorin Brown on 11/22/16.
//  Copyright © 2016 Syracuse University. All rights reserved.
//

import UIKit

class HomeViewController : UIViewController
{
    let firstName = NSUserDefaults.standardUserDefaults().objectForKey("first name")
    @IBOutlet var welcomeLabel: UILabel!
    func register()
    {
        
        let url = NSURL(string: "http://127.0.0.1/MyWebService/includes/registerAsADriver.php")
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        let email = NSUserDefaults.standardUserDefaults().stringForKey("email")
        var isDriver = "true"
        
        
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        let postString = "email=\(email!)&isDriver=\(isDriver)"
        print(postString)
        
        let data = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        let task = session.uploadTaskWithRequest(request, fromData: data, completionHandler:
            {(data,response,error) in
                
                guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                    print(error)
                    return
                }
                do {
                    var dictonary:NSDictionary?
                    dictonary =  try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? [String:AnyObject]
                    
                    
                    
                    
                    dispatch_async(dispatch_get_main_queue(),
                        {
                            self.performSegueWithIdentifier("segueToCustomerList", sender: self)
                            
                    })
                    
                } catch let error as NSError {
                    print(error)
                }
                
                
                
            }
        );
        
        task.resume()
        
        
        
        
    }
    @IBAction func beADriver(sender: AnyObject)
    {
        
        let url = NSURL(string: "http://127.0.0.1/MyWebService/includes/beADriver.php")
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        let email = NSUserDefaults.standardUserDefaults().stringForKey("email")
        
        
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        let postString = "email=\(email!)"
        print(postString)
        
        let data = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        let task = session.uploadTaskWithRequest(request, fromData: data, completionHandler:
            {(data,response,error) in
                
                guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                    print(error)
                    return
                }
                
                do {
                    var dictonary:NSDictionary?
                    dictonary =  try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? [String:AnyObject]
                    
                    print("\(dictonary)")
                    let string = dictonary!["isRegistered"]!
                    
                    let driver = string["isDriver"]! as! NSString
                    
                    print("\(driver)")
                    
                    
                    
                    if driver == "true"
                    {
                        
                        
                        
                        
                        
                        dispatch_async(dispatch_get_main_queue(),
                            {
                                self.performSegueWithIdentifier("segueToCustomerList", sender: self)
                                
                        })
                    }
                    else
                    {   dispatch_async(dispatch_get_main_queue(),
                        {
                            
                            let message = "Not registered as a driver. Would you like to Register?"
                            
                            let ac = UIAlertController(title: "Alert", message: message, preferredStyle: .ActionSheet)
                            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                            
                            ac.addAction(cancelAction)
                            
                            let deleteAction = UIAlertAction(title: "Register",
                                style: .Default,
                                handler: {
                                    _ in
                                    self.register()
                                    
                            })
                            ac.addAction(deleteAction)
                            
                            self.presentViewController(ac, animated: true, completion: nil)
                            
                    })
                    }
                    
                    
                } catch let error as NSError {
                    print(error)
                }
                
                
                
            }
        );
        
        task.resume()
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        welcomeLabel.text = "Welcome " + (firstName as! String) + "!"
        
        let url = NSURL(string: "http://127.0.0.1/MyWebService/includes/refreshTable.php")
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        let email = NSUserDefaults.standardUserDefaults().stringForKey("email")
        let latitude = ""
        let longtitude = ""
        let quotedPrice = ""
        let forCustomer = ""
        let acceptedOfferFromDriver = ""
        let distance = ""
        
        
        
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        let postString = "email=\(email!)&latitude=\(latitude)&longtitude=\(longtitude)&quotedPrice=\(quotedPrice)&forCustomer=\(forCustomer)&acceptedOfferFromDriver=\(acceptedOfferFromDriver)&distance=\(distance)"
        
        let data = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        let task = session.uploadTaskWithRequest(request, fromData: data, completionHandler:
            {(data,response,error) in
                
                guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                    print(error)
                    return
                }
                
                
                
                
            }
        );
        
        task.resume()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "loginView")
        {
        }
    }
    
    @IBAction func LogOutPressed(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isUserLoggedIn")
        NSUserDefaults.standardUserDefaults().synchronize()
        let loginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("loginView") as! LoginViewController
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appdelegate.window?.rootViewController=loginViewController
        appdelegate.window?.makeKeyAndVisible()
        
    }
}

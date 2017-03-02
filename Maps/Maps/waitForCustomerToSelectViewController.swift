//
//  waitForCustomerToSelectViewController.swift
//  Maps
//
//  Created by Lorin Brown on 11/29/16.
//  Copyright © 2016 Syracuse University. All rights reserved.
//

import UIKit

class waitForCustomerToSelect: UIViewController
{
    @IBOutlet var waitLabel: UILabel!
    @IBOutlet var bidExpiresLabel: UILabel!
    var count = 0
    var remaining = 2
    var remainingTime = 900
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Write offer Expires to the database
        var timer2 = NSTimer.scheduledTimerWithTimeInterval(900.0, target: self, selector: #selector(self.expires), userInfo: nil, repeats: false)
        
        
        
        //Query the database every 8 seconds
        // can be called as often as needed
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(8.0, target: self, selector: #selector(self.checkForAcceptance), userInfo: nil, repeats: true)
        // do calculations
        
        
        // release queue when you are done with all the work
        
        
        //Display in real time when time expires
        var timer3 = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(self.displayCountDown), userInfo: nil, repeats: true)
        
    }
    func displayCountDown()
    {
        if remainingTime != 0
        {
            remainingTime = remainingTime - 1
        }
        if remainingTime%60 < 10
        {
            bidExpiresLabel.text = "\((remainingTime)/60):0\(remainingTime%60)"
        }
        else
        {
            bidExpiresLabel.text = "\((remainingTime)/60):\(remainingTime%60)"
        }
        
        
    }
    
    func checkForAcceptance()
    {
        
        let url = NSURL(string: "http://127.0.0.1/MyWebService/includes/checkAccepted.php")
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        
        let user = NSUserDefaults.standardUserDefaults().stringForKey("user email")
        let email = NSUserDefaults.standardUserDefaults().stringForKey("email")
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        let postString = "&user=\(user!)"
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
                    let string = dictonary!["Accepted"]!
                    
                    let driver = string["acceptedOfferFromDriver"]! as! NSString
                    
                    
                    
                    if !driver.isEqualToString("") && driver != email
                    {
                        self.expires()
                    }
                    
                    if driver == email
                    {
                        
                        
                        
                        
                        
                        dispatch_async(dispatch_get_main_queue(),
                            {
                                self.performSegueWithIdentifier("segueToMap2", sender: self)
                                
                        })
                    }
                    
                    
                    
                } catch let error as NSError {
                    print(error)
                }
                
                
                
            }
        );
        
        task.resume()
        
        
        
    }
    func expires()
    {
        let alert = UIAlertController(title: "Alert", message: "Sorry, your bid was not accepted", preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: {
            _ in
            self.bidNotSelected()
        })
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    func bidNotSelected()
    {
        
        let url = NSURL(string: "http://127.0.0.1/MyWebService/includes/setBid.php")
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        let email = NSUserDefaults.standardUserDefaults().stringForKey("email")
        let offer = "true"
        let bid = ""
        let user = ""
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        //Unwrite these fields Make bid and user blank
        let postString = "email=\(email!)&bid=\(bid)&user=\(user)&offer=\(offer)"
        print(postString)
        
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
        
        self.performSegueWithIdentifier("bidWasNotAcceptedSegue", sender: self)
    }
    
}
//
//  SelectACustomerViewController.swift
//  Maps
//
//  Created by Lorin Brown on 11/29/16.
//  Copyright © 2016 Syracuse University. All rights reserved.
//

import UIKit
class SelectACustomerViewController: UIViewController
{
    @IBAction func bidPressed(sender: UIButton) {
        
        let bid = bidTextField.text
        if(bid!.isEmpty)
        {
            let alert = UIAlertController(title: "Alert", message: "Number is required", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        
        
        
        let ac = UIAlertController(title: title, message: "Are you sure?", preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        ac.addAction(cancelAction)
        
        let deleteAction = UIAlertAction(title: "Select",
                                         style: .Default,
                                         handler: { _ in
                                            self.Selected(sender)
                                            
                                            
                                            
                                            
                                            
                                            
        })
        ac.addAction(deleteAction)
        
        presentViewController(ac, animated: true, completion: nil)
    }
    func Selected(button: UIButton)
    {
        let url = NSURL(string: "http://127.0.0.1/MyWebService/includes/setBid.php")
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        let email = NSUserDefaults.standardUserDefaults().stringForKey("email")
        let user = NSUserDefaults.standardUserDefaults().stringForKey("user email")
        let offer = "false"
        let bid = bidTextField.text
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        let postString = "email=\(email!)&bid=\(bid!)&user=\(user!)&offer=\(offer)"
        print(postString)
        
        let data = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        let task = session.uploadTaskWithRequest(request, fromData: data, completionHandler:
            {(data,response,error) in
                
                guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                    print(error)
                    return
                }
                
                
                
                dispatch_async(dispatch_get_main_queue(),
                    {
                        self.performSegueWithIdentifier("segueToMap", sender: self)
                        
                })
                
                
                
            }
        );
        
        task.resume()
    }
    
    
    
    @IBOutlet var bidTextField: UITextField!
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bidTextField.delegate = self //set delegate to textfile
        self.hideKeyboardWhenTappedAround()
        
    }
    
    
    
    
}

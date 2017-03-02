//
//  LoginViewController.swift
//  Maps
//
//  Created by Lorin Brown on 11/22/16.
//  Copyright © 2016 Syracuse University. All rights reserved.
//

import UIKit

class LoginViewController : UIViewController
{
    
    
    
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var textFieldToBottomLayoutGuideConstraint: NSLayoutConstraint!
    
    func displayAlertMessage(userMessage: String)
    {
        let alert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func SubmitPressed(button: AnyObject)
    {
        
        
        
        
        
        let email = usernameTextField.text
        let password = passwordTextField.text
        
        
        let url = NSURL(string: "http://127.0.0.1/MyWebService/includes/userLogin.php")
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        var messageToDisplay = ""
        
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        let postString = "email=\(email!)&password=\(password!)"
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
                    
                    if let myDictionary = dictonary
                    {
                        print("\(dictonary!["status"]!)")
                        if "Success" == dictonary!["status"] as! String
                        {
                            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isUserLoggedIn")
                            NSUserDefaults.standardUserDefaults().setObject(email, forKey: "email")
                            NSUserDefaults.standardUserDefaults().synchronize()
                            
                            print("\(dictonary!)")
                            let first = dictonary!["first_Name"] as! String
                            
                            // let driver = string["isDriver"]! as! NSString
                            //let first = dictonary!["first_Name"] as! String
                            NSUserDefaults.standardUserDefaults().setObject(first,forKey: "first name")
                            
                            dispatch_async(dispatch_get_main_queue(),
                                {
                                    self.performSegueWithIdentifier("homePageNav", sender: self)
                                    
                            })
                        }
                        else
                        {
                            messageToDisplay = myDictionary["message"] as! String;
                            self.displayAlertMessage(messageToDisplay)
                            return
                            
                        }
                    }
                } catch let error as NSError {
                    print(error)
                }
                
                
                
            }
        );
        
        task.resume()
        
        
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.delegate = self //set delegate to textfile
        usernameTextField.delegate = self //set delegate to textfile
        self.hideKeyboardWhenTappedAround()
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(self.keyboardNotification(_:)),
                                                         name: UIKeyboardWillChangeFrameNotification,
                                                         object: nil)
    }
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardNotification(notification: NSNotification) {
        
        
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as?     NSValue)?.CGRectValue()
            let duration:NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.unsignedLongValue ?? UIViewAnimationOptions.CurveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if endFrame?.origin.y >= UIScreen.mainScreen().bounds.size.height {
                self.textFieldToBottomLayoutGuideConstraint?.constant = 0.0
            } else {
                self.textFieldToBottomLayoutGuideConstraint?.constant = endFrame?.size.height ?? 0.0
            }
            UIView.animateWithDuration(duration,
                                       delay: NSTimeInterval(0),
                                       options: animationCurve,
                                       animations: { self.view.layoutIfNeeded() },
                                       completion: nil)
        }
    }
    
    
    
    
    
    
    
}


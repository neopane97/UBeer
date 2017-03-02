//
//  RegisterViewController.swift
//  Maps
//
//  Created by Lorin Brown on 11/22/16.
//  Copyright © 2016 Syracuse University. All rights reserved.
//

import UIKit

class RegisterViewController : UIViewController
{
    
    
    @IBOutlet var answer1TextField: UITextField!
    @IBOutlet var securityQuestionOneTextField: UITextField!
    @IBOutlet var dlNumberTextField: UITextField!
    @IBOutlet var dlStateTextField: UITextField!
    @IBOutlet var dlCountryTextField: UITextField!
    @IBOutlet var stateTextField: UITextField!
    @IBOutlet var countryTextField: UITextField!
    @IBOutlet var birthTextField: UITextField!
    @IBOutlet var phoneNumber: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet var emailAddressTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var reenterTextField: UITextField!
    @IBOutlet var addressOneTextField: UITextField!
    @IBOutlet var zipCodeTextField: UITextField!
    @IBOutlet var addressTwoTextField: UITextField!
    @IBOutlet var button: UIButton!
    @IBOutlet var textFieldToBottomLayoutGuideConstraint: NSLayoutConstraint!
    var isDriver = "false"
    
    @IBAction func DriverPressed(sender: AnyObject) {
        button.enabled = false // disables
        button.setTitle("Registered Driver", forState: UIControlState.Normal) // sets text
        isDriver = "true"
    }
    @IBOutlet var dlCityTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        answer1TextField.delegate = self
        securityQuestionOneTextField.delegate=self
        dlNumberTextField.delegate=self
        dlStateTextField.delegate=self
        dlCityTextField.delegate = self
        
        stateTextField.delegate = self
        countryTextField.delegate = self
        birthTextField.delegate = self
        phoneNumber.delegate = self
        lastNameTextField.delegate = self
        firstNameTextField.delegate = self
        emailAddressTextField.delegate = self
        passwordTextField.delegate = self
        reenterTextField.delegate = self
        addressOneTextField.delegate = self
        zipCodeTextField.delegate = self
        addressTwoTextField.delegate = self
        self.hideKeyboardWhenTappedAround()
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(self.keyboardNotification(_:)),
                                                         name: UIKeyboardWillChangeFrameNotification,
                                                         object: nil)
        
        
    }
    @IBAction func textFieldEditing(sender: UITextView) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        sender.inputView = datePickerView
        
        datePickerView.datePickerMode = UIDatePickerMode.Date
        datePickerView.backgroundColor = UIColor.whiteColor()
        
        
        
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(RegisterViewController.cancelClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton], animated: false)
        toolBar.userInteractionEnabled = true
        sender.inputAccessoryView = toolBar
        
        
        
        datePickerView.addTarget(self, action: #selector(RegisterViewController.datePickerValueChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        
    }
    
    
    func cancelClick() {
        birthTextField.resignFirstResponder()
    }
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        
        birthTextField.text = dateFormatter.stringFromDate(sender.date)
        
        
    }
    
    func displayAlertMessage(userMessage: String)
    {
        let alert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    func textField(textField: UITextField , shouldChangeCharactersInRange range: NSRange,replacementString string: String) -> Bool {
        if (textField == phoneNumber)
        {
            let str = (phoneNumber.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
            
            return checkEnglishPhoneNumberFormat(string, str: str)
        }
        return true
        
    }
    
    
    func checkEnglishPhoneNumberFormat(string: String?, str: String?) -> Bool{
        
        if string == ""{ //BackSpace
            
            return true
            
        }else if str!.characters.count < 3{
            
            if str!.characters.count == 1{
                
                phoneNumber.text = "("
            }
            
        }else if str!.characters.count == 5{
            
            phoneNumber.text = phoneNumber.text! + ") "
            
        }else if str!.characters.count == 10{
            
            phoneNumber.text = phoneNumber.text! + "-"
            
        }else if str!.characters.count > 14{
            
            return false
        }
        
        return true
    }
    
    @IBAction func submitPressed(sender: AnyObject) {
        let last = lastNameTextField.text
        let first = firstNameTextField.text
        let email = emailAddressTextField.text
        let password = passwordTextField.text
        let reenter = reenterTextField.text
        let address1 = addressOneTextField.text
        let address2 = addressTwoTextField.text
        let zip = zipCodeTextField.text
        let answer = answer1TextField.text
        let question = securityQuestionOneTextField.text
        let state = stateTextField.text
        let country = countryTextField.text
        let birth = birthTextField.text
        let dlNumber = dlNumberTextField.text
        
        
        if(email!.isEmpty || password!.isEmpty || reenter!.isEmpty || last!.isEmpty || first!.isEmpty || address1!.isEmpty || address2!.isEmpty || zip!.isEmpty || answer!.isEmpty || question!.isEmpty || state!.isEmpty || country!.isEmpty || birth!.isEmpty || dlNumber!.isEmpty)
        {
            displayAlertMessage("All fields are required")
            
            return
        }
        if(password != reenter)
        {
            displayAlertMessage("Passwords do not match")
            return
        }
        
        
        let url = NSURL(string: "http://127.0.0.1/MyWebService/includes/userRegister.php")
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        var messageToDisplay = ""
        
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        let postString = "email=\(email!)&password=\(password!)&last=\(last!)&first=\(first!)&address1=\(address1!)&address2=\(address2!)&zip=\(zip!)&answer=\(answer!)&question=\(question!)&state=\(state!)&country=\(country!)&birth=\(birth!)&isDriver=\(isDriver)&dlNumber=\(dlNumber!)"
        print(postString)
        
        let data = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        let task = session.uploadTaskWithRequest(request, fromData: data, completionHandler:
            {(data,response,error) in
                
                guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                    print(error)
                    return
                }
                
                let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print(dataString)
                do {
                    var dictonary:NSDictionary?
                    dictonary =  try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? [String:AnyObject]
                    var isUserRegistered = false
                    if let myDictionary = dictonary
                    {
                        print("\(dictonary!["message"]!)")
                        if "Success" == dictonary!["status"] as! String
                        {
                            isUserRegistered = true
                            
                        }
                        messageToDisplay = myDictionary["message"] as! String;
                        if !isUserRegistered
                        {
                            messageToDisplay = myDictionary["message"] as! String;
                        }
                        dispatch_async(dispatch_get_main_queue(), {
                            var alert = UIAlertController(title: "Alert", message: messageToDisplay, preferredStyle: UIAlertControllerStyle.Alert)
                            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default){
                                action in self.dismissViewControllerAnimated(true, completion: nil)}
                            alert.addAction(okAction)
                            self.presentViewController(alert, animated: true, completion: nil)
                            
                        })
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
// Put this piece of code anywhere you like
extension UIViewController: UITextFieldDelegate{
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
        
    }
    
    
}

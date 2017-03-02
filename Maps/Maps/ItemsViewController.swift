
//
//  ItemsViewController.swift
//  Homeowner
//
//  Created by teacher on 10/18/16.
//  Copyright © 2016 Syracuse University. All rights reserved.
//

import UIKit


//Item represents a driver that the customer sees. I am too lazy to change the class and syntax
class ItemsViewController: UITableViewController {
    var itemStore = ItemStore()
    
    @IBOutlet var closestButton: UIButton!
    
    @IBOutlet var cheapestButton: UIButton!
    
    @IBOutlet var ratingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemStore.createItem()
        _ = NSTimer.scheduledTimerWithTimeInterval(10.0, target: self, selector: #selector(self.reloadView), userInfo: nil, repeats: true)
        //set contentInset for tableView
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        //itemStore.printAllItems()
        
        //tableView.rowHeight = 45
        tableView.estimatedRowHeight = 65
        
        
        
        
    }
    func reloadView()
    {
        //delete(itemStore)
        
        itemStore.createItem()
        
        
        //Make it longer to be okay for larger queries. . Their is for sure a better way to do this...
        for(var i = 0; i < 65000; i += 1)
        {
            for(var i = 0; i < 5000; i += 1)
            {
                
            }
        }
        let sort = NSUserDefaults.standardUserDefaults().integerForKey("sort")
        //If we refresh too soon we lose all of our data
        if sort == 0
        {
            self.itemStore.allItems = self.itemStore.sortRating()
        }
        if sort == 1
        {
            self.itemStore.allItems = self.itemStore.sortCheapest()
        }
        if sort == 2
        {
            self.itemStore.allItems = self.itemStore.sortClosestt()
        }
        
        self.tableView.reloadData()
    }
    @IBAction func ratingPressed(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "sort")
        self.itemStore.allItems = self.itemStore.sortRating()
        self.tableView.reloadData();
        self.cheapestButton.backgroundColor = UIColor.blueColor();
        
        //0,122,255
        self.closestButton.backgroundColor = UIColor.blueColor()
        self.ratingButton.backgroundColor = UIColor.lightGrayColor()
    }
    @IBAction func cheapestPressed(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "sort")
        self.itemStore.allItems = self.itemStore.sortCheapest()
        self.tableView.reloadData();
        self.cheapestButton.backgroundColor = UIColor.lightGrayColor();
        
        //0,122,255
        self.closestButton.backgroundColor = UIColor.blueColor()
        self.ratingButton.backgroundColor = UIColor.blueColor()
        
        
    }
    @IBAction func closestPressed(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setInteger(2, forKey: "sort")
        self.itemStore.allItems = self.itemStore.sortClosestt()
        self.tableView.reloadData();
        self.cheapestButton.backgroundColor = UIColor.blueColor();
        
        //0,122,255
        self.closestButton.backgroundColor = UIColor.lightGrayColor()
        self.ratingButton.backgroundColor = UIColor.blueColor()
    }
    
    
    func driverSelected(indexPath: NSIndexPath)
    {
        
        
        let message = "Are you sure?"
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        ac.addAction(cancelAction)
        
        let deleteAction = UIAlertAction(title: "Select",
                                         style: .Default,
                                         handler: { _ in
                                            self.Selected(indexPath)
                                            
                                            
                                            
        })
        ac.addAction(deleteAction)
        
        presentViewController(ac, animated: true, completion: nil)
        
    }
    func Selected(indexpath: NSIndexPath)
    {
        
        let item = itemStore.allItems[indexpath.row]
        
        print("Driver Selected")
        NSUserDefaults.standardUserDefaults().setFloat(item.price, forKey: "price")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        
        
        let url = NSURL(string: "http://127.0.0.1/MyWebService/includes/acceptedBid.php")
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        let customeremail = NSUserDefaults.standardUserDefaults().stringForKey("email")
        let driveremail = item.email
        
        
        print("Currently logged in email is \(customeremail)")
        print("Driver to accept email is  \(driveremail)")
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        let postString = "email=\(customeremail!)&user=\(driveremail)"
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
                        self.performSegueWithIdentifier("waitForDriverToComeSegue", sender: self)
                        
                })
                
                
                
            }
        );
        
        task.resume()
    }
    
    
    
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]{
        
        let ackAction:UITableViewRowAction = UITableViewRowAction(style: .Default, title: "Select") { (tableView, indexPath) in
            self.driverSelected(indexPath)
        }
        ackAction.backgroundColor = UIColor.blueColor()
        
        return [ackAction]
    }
    
    
    //function that enables row reordering
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        itemStore.moveItem(sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
    
    //function that returns a new index path to retarget a proposed move of a row.
    override func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
        return proposedDestinationIndexPath
    }
    
    //function to get the number of sections in the table view.
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //function to get the number of rows in a given section of a table view. This is a REQUIRED function
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemStore.allItems.count+1
    }
    
    //function to get a cell for inserting in a particular location of the table view. This is a REQUIRED function
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as! ItemCell
        
        // print("Getting cell for Section: \(indexPath.section) Row: \(indexPath.row)")
        if indexPath.row < itemStore.allItems.count {
            let item = itemStore.allItems[indexPath.row]
            cell.noMoreDriversLabel.text = ""
            cell.driverLabel.text = item.driver
            cell.distanceLabel.text = "\(item.distance) Miles"
            cell.ratingNumberLabel.text = "Rating: \(item.rating)"
            cell.priceLabel.text = "$\(item.price)"
            cell.updateLabels()
            
            
        } else {
            print("Here")
            // The last row
            cell.noMoreDriversLabel.text = "No More Drivers Available"
            cell.driverLabel.text = ""
            cell.distanceLabel.text = ""
            cell.ratingNumberLabel.text = ""
            cell.priceLabel.text = ""
            cell.updateLabels()
            
        }
        return cell
    }
}

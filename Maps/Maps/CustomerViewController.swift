//
//  ItemsViewController.swift
//  Homeowner
//
//  Created by teacher on 10/18/16.
//  Copyright © 2016 Syracuse University. All rights reserved.
//

import UIKit

class CustomerViewController: UITableViewController {
    var itemStore = CustomerStore()
    //Query the database every 30 seconds
    
    
    @IBOutlet var closestButton: UIButton!
    
    
    @IBOutlet var ratingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        itemStore.createItem()
        _ = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: #selector(self.reloadView), userInfo: nil, repeats: true)
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
        
        let sort = NSUserDefaults.standardUserDefaults().integerForKey("sort2")
        //If we refresh too soon we lose all of our data
        //If we refresh too soon we lose all of our data
        //Make it longer to be okay for larger queries. . Their is for sure a better way to do this...
        for(var i = 0; i < 65000; i += 1)
        {
            for(var i = 0; i < 5000; i += 1)
            {
                
            }
        }
        if sort == 0
        {
            print("rating")
            self.itemStore.allItems = self.itemStore.sortRating()
        }
        
        if sort == 1
        {    print("closest")
            self.itemStore.allItems = self.itemStore.sortClosestt()
        }
        
        
        self.tableView.reloadData()
    }
    
    
    @IBAction func ratingPressed(sender: AnyObject) {
        self.itemStore.allItems = self.itemStore.sortRating()
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "sort2")
        self.tableView.reloadData();
        
        
        //0,122,255
        self.closestButton.backgroundColor = UIColor.blueColor()
        self.ratingButton.backgroundColor = UIColor.lightGrayColor()
    }
    @IBAction func closestPressed(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "sort2")
        self.itemStore.allItems = self.itemStore.sortClosestt()
        self.tableView.reloadData();
        
        
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
        NSUserDefaults.standardUserDefaults().setObject(item.user_email, forKey: "user email")
        NSUserDefaults.standardUserDefaults().setObject(item.price, forKey: "price")
        NSUserDefaults.standardUserDefaults().synchronize()
        self.performSegueWithIdentifier("navBidSegue", sender: self)
        
        
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
        let cell = tableView.dequeueReusableCellWithIdentifier("Customer", forIndexPath: indexPath) as! CustomerCell
        
        // print("Getting cell for Section: \(indexPath.section) Row: \(indexPath.row)")
        if indexPath.row < itemStore.allItems.count {
            let item = itemStore.allItems[indexPath.row]
            cell.noMoreDriversLabel.text = ""
            cell.driverLabel.text = item.driver
            cell.distanceLabel.text = "\(item.distance) Miles"
            cell.ratingNumberLabel.text = "Rating: \(item.rating)"
            cell.priceLabel.text = "\(item.price)"
            cell.updateLabels()
            
            
        } else {
            print("Here")
            // The last row
            cell.noMoreDriversLabel.text = "No More Customers Available"
            cell.driverLabel.text = ""
            cell.distanceLabel.text = ""
            cell.ratingNumberLabel.text = ""
            cell.priceLabel.text = ""
            cell.updateLabels()
            
        }
        return cell
    }
}

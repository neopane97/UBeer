//
//  ItemStore.swift
//  Homeowner
//
//  Created by teacher on 10/20/16.
//  Copyright © 2016 Syracuse University. All rights reserved.
//

import UIKit

//Item represents a driver that the customer sees. I am too lazy to change the class and syntax
class ItemStore {
    var allItems = [Item]()
    
    //function to create an item
    func createItem()  {
        
        allItems.removeAll()
        
        
        
        
        //Pull items from database and print them
        
        
        
        // Send HTTP GET Request
        
        // Define server side script URL
        let scriptUrl = "http://127.0.0.1/MyWebService/includes/pullAcceptedOrders.php"
        
        // Create NSURL Ibject
        let myUrl = NSURL(string: scriptUrl);
        
        // Creaste URL Request
        let request = NSMutableURLRequest(URL:myUrl!);
        
        // Set request HTTP method to GET. It could be POST as well
        request.HTTPMethod = "POST"
        
        let email = NSUserDefaults.standardUserDefaults().stringForKey("email")
        var isDriver = "true"
        
        
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        let postString = "email=\(email!)"
        print(postString)
        
        let data = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().uploadTaskWithRequest(request, fromData: data, completionHandler:
            {(data,response,error) in
                
                guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                    print(error)
                    return
                }
            
            // Print out response string
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString!)")
            
            var jsonResult: NSMutableArray = NSMutableArray()
            // Convert server json response to NSDictionary
            do {
                jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.AllowFragments) as! NSMutableArray
                
                
                
                var jsonElement: NSDictionary = NSDictionary()
                
                
                for(var i = 0; i < jsonResult.count; i++)
                {
                    
                    jsonElement = jsonResult[i] as! NSDictionary
                    
                    
                    
                        //the following insures none of the JsonElement values are nil through optional binding
                        if let lastName = jsonElement["last_Name"] as? String,
                        let firstName = jsonElement["first_Name"] as? String,
                        let distance = jsonElement["distance"] as? String,
                        let rating = jsonElement["rating"] as? String,
                        let price = jsonElement["quotedPrice"] as? String,
                        let email = jsonElement["user_email"] as? String
                       
                        {
                        
                        let cname = "\(firstName) \(lastName)"
                        let cRating = (rating as NSString!).floatValue
                        let cdistance = (distance as NSString!).floatValue
                        let cprice = (price as NSString!).floatValue
                
                        
                        var newItem:Item = Item(name: cname, price: cprice, rating: cRating, distance: cdistance, email: email)
                        
                        self.allItems.append(newItem)
                        
                        
                    }
                    
                    
                }
                
                
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
            }
            );
        task.resume()
    }
   
    

    
    //function to remove specified item from the array
    func removeItem(item: Item) {
        if let index = allItems.indexOf(item) {
            allItems.removeAtIndex(index)
        }
        
    }
    
    //function to reorder an item in the array
    func moveItem(fromIndex: Int, toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        
        let movedItem = allItems[fromIndex]
        
        allItems.removeAtIndex(fromIndex)
        
        allItems.insert(movedItem, atIndex: toIndex)
    }
    //function to sort a list of Items
    func sortCheapest()->[Item]
    {
        let sortedArray: [Item] = allItems.sort{
            $0.price < $1.price
        }
        return sortedArray
    }
    //function to sort a list of Items
    func sortClosestt()->[Item]
    {
        let sortedArray: [Item] = allItems.sort{
            $0.distance < $1.distance
        }
        return sortedArray
    }

    //function to sort a list of Items
    func sortRating()->[Item]
    {
        
        let sortedArray: [Item] = allItems.sort{
             $0.rating > $1.rating
        
        }
        return sortedArray
    }

    //function to print all items in the array
    func printAllItems() {
        for i in 0..<allItems.count {
            print("driver: \(allItems[i].driver) price: \(allItems[i].price) rating: \(allItems[i].rating)")
        }
    }

    
    
}


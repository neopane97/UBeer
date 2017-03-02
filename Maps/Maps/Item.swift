//
//  Item.swift
//  Homeowner
//
//  This will represent a driver.
//  Copyright © 2016 Syracuse University. All rights reserved.
//

import UIKit


//Item represents a driver that the customer sees. I am too lazy to change the class and syntax
class Item: NSObject {
    var driver: String
    var price: Float
    var rating: Float
    var distance: Float
    var email: String
    
    //designated Intializer
    init(name: String, price: Float, rating: Float, distance: Float, email: String) {
        self.driver = name
        self.price = price
        self.rating = rating
        self.distance = distance
        self.email = email
        
        super.init()
    }
    
   
}

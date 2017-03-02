//
//  Item.swift
//  Homeowner
//
//  Created by teacher on 10/18/16.
//  Copyright © 2016 Syracuse University. All rights reserved.
//

import UIKit

class Customer: NSObject {
    var driver: String
    var price: String
    var rating: Float
    var distance: Float
    var user_email: String
    
    //designated Intializer
    init(name: String, price: String , rating: Float, distance: Float, user_email: String) {
        self.driver = name
        self.price = price
        self.rating = rating
        self.distance = distance
        self.user_email = user_email
        
        super.init()
    }
    
    
}
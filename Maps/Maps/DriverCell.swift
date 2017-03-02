//
//  ItemCell.swift
//  Homeowner
//
//  Created by teacher on 10/27/16.
//  Copyright © 2016 Syracuse University. All rights reserved.
//

import UIKit

//ItemCell is a custom cell
class ItemCell: UITableViewCell {
    @IBOutlet var driverLabel: UILabel!
    @IBOutlet var ratingNumberLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var noMoreDriversLabel:UILabel!

    @IBOutlet var selectButton: UIButton!
    @IBOutlet var distanceLabel: UILabel!
    @IBAction func selectButtonPressed(sender: AnyObject) {
    }
    
    //function to set fonts of labels
    func updateLabels() {
        let bodyFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        driverLabel.font = bodyFont
        ratingNumberLabel.font = bodyFont
        noMoreDriversLabel.font = bodyFont
        
        let captionFont = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        ratingNumberLabel.font = captionFont
    }
}

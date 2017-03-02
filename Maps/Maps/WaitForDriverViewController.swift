//
//  WaitForDriverViewController.swift
//  Maps
//
// To be implemented at a later date, we need to provide a screen that shows customer how close the driver is to arrivign

import UIKit

class WaitForDriverViewController: UIViewController
{
    @IBOutlet var distanceLabel: UILabel!
    
    //Will need to constantly refresh every 'x' seconds to pull driver's coordinates from the database
    //Will implement this in the future
    func refresh()
    {
        
    }
    //Refresh coordinates manually
    @IBAction func manuelRefresh(sender: AnyObject) {
    }
    
}

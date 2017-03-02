


import UIKit
import MapKit



protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}
class ViewController : UIViewController {
    
    var resultSearchController:UISearchController? = nil
    
    
    var selectedPin:MKPlacemark? = nil
    var dlNumber: String = ""
    var longtitude: String = ""
    var latitude: String = ""
    let locationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var textFieldToBottomLayoutGuideConstraint: NSLayoutConstraint!
    @IBOutlet var licenseNumberTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        self.mapView.showsUserLocation = true
        let locationSearchTable = storyboard!.instantiateViewControllerWithIdentifier("LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Set Alternate Delivery Address"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        
        
        
        //We can read accepted customer's gps location here
        
        //We can read customer location and post coordinates here
        
        //Pull items from database and print them
        
        
        
        // Send HTTP GET Request
        // Define server side script URL
        let scriptUrl = "http://127.0.0.1/MyWebService/includes/getDeliveryLocation.php"
        
        // Create NSURL Ibject
        let myUrl = NSURL(string: scriptUrl);
        
        // Creaste URL Request
        let request = NSMutableURLRequest(URL:myUrl!);
        
        // Set request HTTP method to GET. It could be POST as well
        request.HTTPMethod = "POST"
        
        let email = NSUserDefaults.standardUserDefaults().stringForKey("user email")
        
        
        
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        let postString = "customermail=\(email!)"
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
                
                var jsonResult: NSMutableArray = NSMutableArray()
                // Convert server json response to NSDictionary
                do {
                    jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.AllowFragments) as! NSMutableArray
                    
                    var jsonElement: NSDictionary = NSDictionary()
                    
                    
                    for(var i = 0; i < jsonResult.count; i++)
                    {
                        
                        jsonElement = jsonResult[i] as! NSDictionary
                        self.longtitude = jsonElement["longtitude"] as! String!
                        self.latitude = jsonElement["latitude"] as! String!
                        self.dlNumber  = jsonElement["dlNumber"] as! String!
                        
                        
                        
                        
                        
                        
                        
                    }
                    
                    var lat = ((self.latitude) as NSString).doubleValue
                    var long = ((self.longtitude) as NSString).doubleValue
                    print("latitude = \(lat)")
                    print("latitude = \(long)")
                    
                    
                    let location1 = CLLocation(latitude: lat, longitude: long)
                    let location2 = CLLocation(latitude: 43.0444, longitude: -76.1474)
                    
                    let distanceInMiles = location1.distanceFromLocation(location2)/1609
                    print("Distacne In Miles == \(distanceInMiles)")
                    dispatch_async(dispatch_get_main_queue(),
                        {
                            
                            let newYorkLocation =
                                CLLocationCoordinate2DMake(lat, long)
                            
                            // Location name-----Read From Customer... We will let customer set locations
                            let dictionary: [String:String] = [
                                "City" :"Syracuse",
                                "State" : "NY",
                                "Zip" : "13159"
                            ]
                            let placemark=MKPlacemark(coordinate: newYorkLocation, addressDictionary: dictionary)
                            print(dictionary["City"])
                            self.selectedPin = placemark
                            let dropPin = MKPointAnnotation()
                            dropPin.coordinate = placemark.coordinate
                            if let locationName = placemark.addressDictionary?["City"] as? NSString
                            {
                                print(locationName)
                                dropPin.title = "Deliver Beer Here!"
                            }
                            
                            
                            if let city = placemark.locality,
                                let state = placemark.administrativeArea {
                                //dropPin.subtitle = "\(city) \(state)"
                            }
                            
                            self.mapView.addAnnotation(dropPin)
                            let span = MKCoordinateSpanMake(0.05, 0.05)
                            let region = MKCoordinateRegionMake(self.selectedPin!.coordinate, span)
                            self.mapView.setRegion(region, animated: true)
                    })
                    
                    
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
                
            }
        );
        task.resume()
        
        
        
        
        
        
        
        
        self.hideKeyboardWhenTappedAround()
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(self.keyboardNotification(_:)),
                                                         name: UIKeyboardWillChangeFrameNotification,
                                                         object: nil)
        
    }
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    //deliveryWasCompleteSegue
    func displayAlertMessage(userMessage: String)
    {
        let alert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func beerWasDelivered(sender: AnyObject) {
        let license = licenseNumberTextField.text
        if license!.isEmpty
        {
            let message = "Customer Verification is Required"
            displayAlertMessage(message)
            return
        }
        if license != self.dlNumber
        {
            let message = "Driver License Number Must Match!"
            displayAlertMessage(message)
            return
        }
        
        //Will Need to Verify that license matches hte database
        let price = NSUserDefaults.standardUserDefaults().integerForKey("price")
        let message2 = "Thanks! $\(price).00 was transferred to your account"
        let alert = UIAlertController(title: "Success!", message: message2, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: {
            _ in
            self.deliveryWasCompleted()
            
        })
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
        
        
        
        
    }
    
    
    func deliveryWasCompleted()
    {
        self.performSegueWithIdentifier("deliveryWasCompleteSegue", sender: self)
    }
    
    @IBAction func zoomIn(sender: AnyObject) {
        
        let userLocation = mapView.userLocation
        if userLocation.location != nil
        {
            let region = MKCoordinateRegionMakeWithDistance(
                userLocation.location!.coordinate, 500, 500)
            
            mapView.setRegion(region, animated: true)
        }
        
        
    }
    @IBAction func changeMapType(sender: AnyObject) {
        if mapView.mapType == MKMapType.Standard {
            mapView.mapType = MKMapType.Satellite
        } else {
            mapView.mapType = MKMapType.Standard
        }
    }
    
    func getDirections(){
        if let selected = selectedPin {
            let mapItem = MKMapItem(placemark: selected)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMapsWithLaunchOptions(launchOptions)
        }
        
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

extension ViewController : CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let Center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let Region = MKCoordinateRegion(center:Center,span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta:1))
        self.mapView.setRegion(Region, animated: true)
        
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("error:: \(error)")
    }
    
    
}




extension ViewController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
}


extension ViewController : MKMapViewDelegate {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.pinTintColor = UIColor.blueColor()
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPointZero, size: smallSquare))
        button.setBackgroundImage(UIImage(named: "car"), forState: .Normal)
        button.addTarget(self, action: "getDirections", forControlEvents: .TouchUpInside)
        pinView?.leftCalloutAccessoryView = button
        return pinView
    }
}







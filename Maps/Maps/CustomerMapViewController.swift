import UIKit
import MapKit


protocol HandleSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}
class CustomerMapViewController : UIViewController {
    
    var resultSearchController:UISearchController? = nil
    
    
    var selectedPin:MKPlacemark? = nil
    let locationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var textFieldToBottomLayoutGuideConstraint: NSLayoutConstraint!
    @IBOutlet var beerTypeTextField: UITextField!
    @IBOutlet var packagingTextField: UITextField!
    @IBOutlet var quantityTextField: UITextField!
    func displayAlertMessage(userMessage: String)
    {
        let alert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    
    @IBAction func customerOrdered(button: AnyObject) {
        let beerType = beerTypeTextField.text
        let packaging = packagingTextField.text
        var quantity = quantityTextField.text
        if(beerType!.isEmpty || packaging!.isEmpty || quantity!.isEmpty)
        {
            displayAlertMessage("All Fields Are Required")
            return
        }
        var message = "Are you sure you want to order \(quantity!) x \(packaging!) of \(beerType!)"
        let ac = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        ac.addAction(cancelAction)
        
        let deleteAction = UIAlertAction(title: "Select",
                                         style: .Default,
                                         handler: { _ in
                                            self.Selected(button)
                                            
                                            
                                            
                                            
                                            
                                            
        })
        ac.addAction(deleteAction)
        
        presentViewController(ac, animated: true, completion: nil)
        
        
    }
    func Selected(select: AnyObject)
    {
        var locValue:CLLocationCoordinate2D = (selectedPin?.coordinate)!
        
        var beerType = beerTypeTextField.text
        var packaging = packagingTextField.text
        var quantity = quantityTextField.text
        
        
        let url = NSURL(string: "http://127.0.0.1/MyWebService/includes/orderedBeer.php")
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        let email = NSUserDefaults.standardUserDefaults().stringForKey("email")
        
        
        
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        let postString = "email=\(email!)&beerType=\(beerType!)&packing=\(packaging!)&quantity=\(quantity!)&latitude=\(locValue.latitude)&longitude=\(locValue.longitude)"
        print(postString)
        
        let data = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        let task = session.uploadTaskWithRequest(request, fromData: data, completionHandler:
            {(data,response,error) in
                
                guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                    print(error)
                    return
                }
                
                var dictonary:NSDictionary?
                
                
                
                dispatch_async(dispatch_get_main_queue(),
                    {
                        self.performSegueWithIdentifier("customerMapViewSegue", sender: select)
                        
                })
                
                
                
                
            }
        );
        
        task.resume()
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        self.mapView.showsUserLocation = true
        let locationSearchTable = storyboard!.instantiateViewControllerWithIdentifier("CustomerLocationSearchTable") as! CustomerLocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Set Alternate Delivery Location"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        
        
        
        //This part doesn't work for the simulators on the macbook if I am not running them through the xcode debugger. If we were to market we would use this to let the gps send us locations for the initial pin. For now we will just hardcode these coordinates to.
        // var locValue:CLLocationCoordinate2D = (locationManager.location?.coordinate)!
        //print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        
        //let customerLocation =
        //   CLLocationCoordinate2DMake(locValue.latitude, locValue.longitude)
        let customerLocation =
            CLLocationCoordinate2DMake(43.0444, -76.1474)
        
        //For demonstration purposes we can set a custom pin location using the search bar. The hard coded coordinates or the new coordinates from the search bar will be written to the server and read by the driver's phone.
        
        // Location name
        let dictionary: [String:String] = [
            "City" :"Syracuse",
            "State" : "NY",
            "Zip" : "13159"
        ]
        let placemark=MKPlacemark(coordinate: customerLocation, addressDictionary: dictionary)
        selectedPin = placemark
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = placemark.coordinate
        if let locationName = placemark.addressDictionary?["City"] as? NSString
        {
            print(locationName)
            dropPin.title = locationName as String
        }
        
        
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            dropPin.subtitle = "\(city) \(state)"
        }
        
        mapView.addAnnotation(dropPin)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(selectedPin!.coordinate, span)
        mapView.setRegion(region, animated: true)
        
        
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
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func zoomIn(sender: AnyObject) {
        
        let userLocation = mapView.userLocation
        if userLocation.location != nil
        {
            let region = MKCoordinateRegionMakeWithDistance(
                userLocation.location!.coordinate, 50, 50)
            
            mapView.setRegion(region, animated: true)
        }
        
        
    }
    
    @IBAction func zoomOut(sender: AnyObject) {
        
        let userLocation = mapView.userLocation
        if userLocation.location != nil
        {
            let region = MKCoordinateRegionMakeWithDistance(
                userLocation.location!.coordinate, 10000, 10000)
            
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
    
}

extension CustomerMapViewController : CLLocationManagerDelegate {
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




extension CustomerMapViewController: HandleSearch {
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


extension CustomerMapViewController : MKMapViewDelegate {
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
        //        let button = UIButton(frame: CGRect(origin: CGPointZero, size: smallSquare))
        //        button.setBackgroundImage(UIImage(named: "car"), forState: .Normal)
        //        button.addTarget(self, action: "getDirections", forControlEvents: .TouchUpInside)
        //        pinView?.leftCalloutAccessoryView = button
        return pinView
    }
}







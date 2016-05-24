//
//  EventViewController.swift
//  Events-NearBy
//
//  Created by kavita patel on 5/24/16.
//  Copyright © 2016 kavita patel. All rights reserved.
//

import UIKit
import MapKit

class EventViewController: UIViewController, CLLocationManagerDelegate , UICollectionViewDelegate, UICollectionViewDataSource
{
    @IBOutlet weak var eventCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UITextField!
    
    let locationManager = CLLocationManager()
    var eventDict = [AnyObject]()
    var numberofEvents = 10
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Ask for Authorization from the User.
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.requestAlwaysAuthorization()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startMonitoringSignificantLocationChanges()
        }
       
    }
    override func viewDidAppear(animated: Bool)
    {
        searchBar.text = "Orlando,fl"
        Events.instance.getEventsList((self.searchBar.text?.lowercaseString)!, date: "all", completionHandler: { (data, err) in
             self.eventDict = data! as [AnyObject]
            print(self.eventDict.count)
            self.numberofEvents = self.eventDict.count
               self.eventCollectionView.reloadData()
        })
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        let geoCoder = CLGeocoder()
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        geoCoder.reverseGeocodeLocation(locations[0])
        {
            (placemarks, error) -> Void in
            let placeArray = placemarks as [CLPlacemark]!
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placeArray?[0]
            // Get City name
            
            if let city = placeMark.addressDictionary?["City"] as? String, let state = placeMark.addressDictionary?["State"] as? String
            {
                self.searchBar.text = city + "," + state
                Events.instance.getEventsList((self.searchBar.text?.lowercaseString)!, date: "all", completionHandler: { (data, err) in
                     self.eventDict = data! as [AnyObject]
                })
            }
        }
    }
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        if status == CLAuthorizationStatus.Denied
        {
            searchBar.text = "Orlando,fl"
            Events.instance.getEventsList((self.searchBar.text?.lowercaseString)!, date: "all", completionHandler: { (data, err) in
                self.eventDict = data! as [AnyObject]
            })
        }
    }
    //To reduce cell gaps
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        return CGSize(width: (collectionView.frame.size.width - 3)/3, height: 190)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat
    {
        return 1
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat
    {
        return 1
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = eventCollectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! EventCollectionViewCell
        cell.activityInd.hidden = false
        cell.activityInd.startAnimating()
        cell.eventImage.image = UIImage(named: "placeholder")
        self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    func configureCell(cell: EventCollectionViewCell, atIndexPath indexPath: NSIndexPath)
    {
        if eventDict.count != 0
        {
            dispatch_async(dispatch_get_main_queue())
            {
                print(self.eventDict[indexPath.row].valueForKey("title"))
                cell.eventTitle.text = self.eventDict[indexPath.row].valueForKey("title") as? String
                cell.eventTime.text = self.eventDict[indexPath.row].valueForKey("start_time") as? String
                cell.eventVenue.text = self.eventDict[indexPath.row].valueForKey("venue_address") as? String
                cell.activityInd.stopAnimating()
                cell.activityInd.hidden = true
            }
            
        }
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return numberofEvents
    }
    
    func alertMsg(title: String, msg: String)
    {
            let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
    }

}


//
//  EventViewController.swift
//  Events-NearBy
//
//  Created by kavita patel on 5/24/16.
//  Copyright © 2016 kavita patel. All rights reserved.
//

import UIKit
import MapKit

class EventViewController: UIViewController, CLLocationManagerDelegate , UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate
{
    @IBOutlet weak var eventCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UITextField!
    let refreshControl = UIRefreshControl()
    let locationManager = CLLocationManager()
    var eventDict = [AnyObject]()
    var numberofEvents = 10
    var selectedIndex : Int = 0
    var error = false
    let alertObj = AlertViewController()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Ask for Authorization from the User.
        self.locationManager.requestWhenInUseAuthorization()
        searchBar.text = Events.instance.city
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.requestAlwaysAuthorization()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startMonitoringSignificantLocationChanges()
        }
        eventCollectionView.allowsMultipleSelection = true
        refreshControl.tintColor = UIColor.redColor()
        refreshControl.addTarget(self, action: #selector(EventViewController.getEvent), forControlEvents: .ValueChanged)
        getEvent()
    }
    
    override func viewDidAppear(animated: Bool)
    {
        eventCollectionView.addSubview(refreshControl)
        eventCollectionView.alwaysBounceVertical = true
        eventCollectionView.reloadData()
    }
    func clearCollection()
    {
        eventDict.removeAll()
        EventDetails.events.removeAll()
        eventCollectionView.reloadData()
    }
    func getEvent()
    {
        error = false
        numberofEvents = 10
        clearCollection()
        Events.instance.getEventsList({ (data, err) in
            if data == nil && err == nil
            {
                self.alertObj.alertMsg("Error", msg: "Data Connection Error",VC: self)
                EventDetails.events.removeAll()
                self.refreshControl.endRefreshing()
                self.error = true
            }
            else if err != nil
            {
                self.alertObj.alertMsg("Error", msg: err!,VC: self)
                EventDetails.events.removeAll()
                self.refreshControl.endRefreshing()
                self.error = true
            }
            else
            {
                self.eventDict = data! as [AnyObject]
                self.numberofEvents = self.eventDict.count
                self.refreshControl.endRefreshing()
                self.error = false
            }
            dispatch_async(dispatch_get_main_queue())
            {
                self.eventCollectionView.reloadData()
            }
        })
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        Events.instance.city = self.searchBar.text!
        getEvent()
        return true
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
                Events.instance.city = self.searchBar.text!
                self.getEvent()
            }
        }
    }
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        if status == CLAuthorizationStatus.Denied
        {
            searchBar.text = "Orlando,fl"
            Events.instance.city = searchBar.text!
            getEvent()
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
        if error == true
        {
            cell.activityInd.stopAnimating()
            eventDict.removeAll()
            cell.activityInd.hidden = true
            return cell
        }
        
        cell.eventImage!.image = UIImage(named: "placeholder")
        self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    @IBAction func unwindToRefineMenu(segue: UIStoryboardSegue)
    {
        if segue.sourceViewController is EventsRefineController
        {
            getEvent()
        }
    }
    func configureCell(cell: EventCollectionViewCell, atIndexPath indexPath: NSIndexPath)
    {
        if eventDict.count != 0
        {
            
                // Allocate value to cell labels
                let imgURL = EventDetails.events[indexPath.row].imageURL
                if imgURL != nil
                {
                    let url = NSURL(string: imgURL!)
                    let data = NSData(contentsOfURL: url!)
                    dispatch_async(dispatch_get_main_queue())
                    {
                        if data != nil
                        {
                            cell.eventImage!.image = UIImage(data: data!)!
                        }
                    }
                }
                // Allocate tag to ticket button, so when it pressed we know which index number of cell.
                cell.eventTicket.tag = indexPath.row
                cell.eventTitle.text = EventDetails.events[indexPath.row].title
                cell.eventTime.text = EventDetails.events[indexPath.row].start_time
                cell.eventVenue.text = EventDetails.events[indexPath.row].venue_name
                if EventDetails.events[indexPath.row].ticketURL != nil
                    {
                        cell.eventTicket.enabled = true
                        cell.eventTicket.hidden = false
                    }
                else
                {
                    cell.eventTicket.hidden = true
                }
            cell.activityInd.stopAnimating()
            cell.activityInd.hidden = true
        }
        else
        {
            cell.eventTitle.text = ""
            cell.eventTime.text = ""
            cell.eventVenue.text = ""
            cell.eventTicket.hidden = true
        }
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return numberofEvents
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        selectedIndex = indexPath.row
        performSegueWithIdentifier("detailSegue", sender: self)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "detailSegue"
        {
            let detailVC = segue.destinationViewController as! DetailViewController
            detailVC.eventIndex = selectedIndex
        }
    }
    @IBAction func ticketBtnPressed(sender: AnyObject)
    {
        clearCollection()
        if EventDetails.events.count > 0
        {
            if EventDetails.events[sender.tag].ticketURL != nil
            {
                let url = NSURL(string: (EventDetails.events[sender.tag].ticketURL)!)
                if UIApplication.sharedApplication().canOpenURL(url!)
                {
                    UIApplication.sharedApplication().openURL(url!)
                }
                else
                {
                    alertObj.alertMsg("Link Error", msg: "Ticket Link is Not InValid",VC: self )
                }
            }

        }
    }
    
}


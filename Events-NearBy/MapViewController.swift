//
//  MapViewController.swift
//  Events-NearBy
//
//  Created by kavita patel on 5/21/16.
//  Copyright © 2016 kavita patel. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate
{
    var radiusList = [25,50,100]
    var miles = 25
    @IBOutlet weak var radiusBtn: UIButton!
    @IBOutlet weak var radiusTableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    var selectedIndex : Int = 0
    override func viewDidLoad()
    {
        super.viewDidLoad()
        radiusTableView.delegate = self
        radiusTableView.dataSource = self
        radiusTableView.hidden = true
        // Default selection of radius
        radiusBtn.setTitle("\(Events.instance.radius) Miles", forState: .Normal)
        mapView.delegate = self
    }
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        refreshData()
        forwardGeocoding(Events.instance.city)
    }
    func forwardGeocoding(address: String)
    {
        CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
            if error != nil {
                print(error)
                return
            }
            if placemarks?.count > 0
            {
                let placemark = placemarks?[0]
                let location = placemark?.location
                let coordinate = location?.coordinate
                let region = MKCoordinateRegionMakeWithDistance(coordinate!, 2000 * Double(Events.instance.radius), 2000 * Double(Events.instance.radius))
                self.mapView.setRegion(region, animated: true)
            }
        })
    }
    func refreshData()
    {
        mapView.removeAnnotations(self.mapView.annotations)
        var annotations = [MKPointAnnotation]()
        for event in EventDetails.events
        {
            let annotation = MKPointAnnotation()
            annotation.coordinate.latitude = CLLocationDegrees(event.latitude!)
            annotation.coordinate.longitude = CLLocationDegrees(event.longitude!)
            annotation.title = event.title
            annotation.subtitle = event.venue_name
            annotations.append(annotation)
        }
        dispatch_async(dispatch_get_main_queue())
        {
            self.mapView.addAnnotations(annotations)
        }
    }
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?
    {
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil
        {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else
        {
            pinView!.annotation = annotation
        }
        return pinView
    }
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
    {
            if control == view.rightCalloutAccessoryView
            {
                    var cnt = 0
                    for event in EventDetails.events
                    {
                        if event.title == (view.annotation?.title)!
                        {
                            selectedIndex = cnt
                            performSegueWithIdentifier("detailSegue", sender: self)
                        }
                        cnt = cnt + 1
                     }
            }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        let detailVC = segue.destinationViewController as! DetailViewController
        detailVC.eventIndex = selectedIndex
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return radiusList.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = radiusTableView.dequeueReusableCellWithIdentifier("radiusCell", forIndexPath: indexPath) 
        cell.textLabel?.text = String(radiusList[indexPath.row])
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        radiusBtn.setTitle(String(radiusList[indexPath.row]), forState: .Normal)
        radiusTableView.hidden = true
        Events.instance.radius = radiusList[indexPath.row]
        forwardGeocoding(Events.instance.city)
        
        Events.instance.getEventsList({ (data, err) in
            print("Update MapView")
            dispatch_async(dispatch_get_main_queue())
            {
                self.refreshData()
                self.forwardGeocoding(Events.instance.city)
            }
        })
    }
    
    @IBAction func radiusBtnPressed(sender: AnyObject)
    {
        radiusTableView.hidden = false
    }
   

}

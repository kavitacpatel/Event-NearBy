//
//  DetailViewController.swift
//  Events-NearBy
//
//  Created by kavita patel on 5/23/16.
//  Copyright © 2016 kavita patel. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController
{
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var venuePlaceLbl: UILabel!
    @IBOutlet weak var venueAddLbl: UILabel!
    @IBOutlet weak var ticketBtn: UIButton!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var venueCityLbl: UILabel!
    @IBOutlet weak var venueStateLbl: UILabel!
    var eventIndex: Int = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        titleLbl.text = EventDetails.events[eventIndex].title
        dateLbl.text = EventDetails.events[eventIndex].start_time
        venuePlaceLbl.text = EventDetails.events[eventIndex].venue_name
        venueAddLbl.text = EventDetails.events[eventIndex].venue_address
        venueCityLbl.text = EventDetails.events[eventIndex].city_name
        venueStateLbl.text = EventDetails.events[eventIndex].region_name
        descLbl.text = EventDetails.events[eventIndex].desc
        let imgURL = EventDetails.events[eventIndex].imageURL
        if imgURL != nil
        {
            let url = NSURL(string: imgURL!)
            let data = NSData(contentsOfURL: url!)
            dispatch_async(dispatch_get_main_queue())
            {
                if data != nil
                {
                    self.img.image = UIImage(data: data!)!
                }
            }
        }
        if EventDetails.events[eventIndex].ticketURL != nil
        {
            ticketBtn.enabled = true
            ticketBtn.hidden = false
        }
        else
        {
            ticketBtn.hidden = true
        }
    }
    @IBAction func ticketBtnPressed(sender: AnyObject)
    {
        let urlStr = EventDetails.events[eventIndex].ticketURL
        let url = NSURL(string: (urlStr)!)
        if UIApplication.sharedApplication().canOpenURL(url!)
        {
            UIApplication.sharedApplication().openURL(url!)
        }
        else
        {
            print("Ticket Link is Not InValid" )
        }

    }
    @IBAction func doneBtnPresed(sender: AnyObject)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }

}

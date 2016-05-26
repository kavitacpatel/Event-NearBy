//
//  EventDetails.swift
//  Events-NearBy
//
//  Created by kavita patel on 5/24/16.
//  Copyright © 2016 kavita patel. All rights reserved.
//

import Foundation
import UIKit

struct EventDetails
{
    var imageURL: String?
    var title: String?
    var venue_name: String?
    var start_time: String?
    var venue_address: String?
    var city_name: String?
    var region_name: String?
    var postal_code: String?
    var desc: String?
    var latitude: Float?
    var longitude: Float?
    var ticketURL: String?
    static var events = [EventDetails]()
    
    init(dict: NSDictionary)
    {
        imageURL = dict.valueForKeyPath("image.medium.url") as? String
        title = dict.valueForKeyPath("title") as? String
        postal_code = dict.valueForKeyPath("postal_code") as? String
        city_name = dict.valueForKeyPath("city_name") as? String
        start_time = dict.valueForKeyPath("start_time") as? String
        desc = dict.valueForKeyPath("description") as? String
        let lati = dict.valueForKeyPath("latitude") as? String
        latitude = (NSNumberFormatter().numberFromString(lati!)?.floatValue)!
        let long = dict.valueForKeyPath("longitude") as? String
        longitude = (NSNumberFormatter().numberFromString(long!)?.floatValue)!
        region_name = dict.valueForKeyPath("region_name") as? String
        venue_name = dict.valueForKeyPath("venue_name") as? String
        venue_address = dict.valueForKeyPath("venue_address") as? String
        let links = dict.valueForKeyPath("tickets.link")
        if links?.count > 0
        {
            if links![0].valueForKey("url") != nil
            {
                ticketURL = links![0].valueForKey("url") as? String
            }
        }
        
    }
    static func eventsFromResults(results: NSArray) -> [EventDetails]
    {
        
        for event in results
        {
            events.append(EventDetails(dict: event as! NSDictionary))
        }
        return events
    }
}
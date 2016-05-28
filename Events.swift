//
//  Events.swift
//  Events-NearBy
//
//  Created by kavita patel on 5/23/16.
//  Copyright © 2016 kavita patel. All rights reserved.
//

import Foundation

class Events
{
    static var instance = Events()
    var radius: Int = 25
    var page: Int = 1
    var date: String = "All"
    var city: String = "Orlando,fl"
    var category: String = "All"
    func getEventsList(completionHandler: (data: NSArray?, err: String?) -> Void )
    {
        let dateNewString = date.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.LiteralSearch, range: nil)
        let categoryNewString = category.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.LiteralSearch, range: nil)
        let cityNewString = city.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.LiteralSearch, range: nil)
        let urlString:String = "\(BASE_URL)\(API_KEY)&location=\(cityNewString)&page_number=\(page)&date=\(dateNewString.lowercaseString)&within=\(radius)&c=\(categoryNewString.lowercaseString)&mature=safe&include=tickets"
        print(urlString)
        let nsURL: NSURL? = NSURL(string: urlString)
        
        if nsURL != nil
        {
            let request = NSMutableURLRequest(URL: nsURL!)
            request.addValue("\(API_KEY)", forHTTPHeaderField: "X-Parse-REST-API-Key")
            let session = NSURLSession.sharedSession()
            // Clear Event History
            EventDetails.events.removeAll()
            let task = session.dataTaskWithRequest(request) { data, response, error in
                if data == nil
                {
                    completionHandler(data: nil, err: nil)
                }
                else if error != nil
                {
                    completionHandler(data: nil, err: error?.description)
                }
                else
                {
                    self.parsedResult(data!, completionHandler: { (result, err) in
                        completionHandler(data: result, err: err)
                    })
                    
                }
            }
            task.resume()

        }
        else
        {
            completionHandler(data: nil, err: "Try Valid City name + State code")
        }
    }
    func parsedResult(data: NSData, completionHandler: (result: NSArray?, err: String?) -> Void)
    {
        let parsedResult: NSDictionary?
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
            if let dict = parsedResult!["events"] as? NSDictionary
            {
                let eventDict = dict["event"] as? NSArray
                if eventDict?.count != 0
                {
                    EventDetails.eventsFromResults(eventDict!)
                    completionHandler(result: eventDict!, err: nil)
                }
                else
                {
                    completionHandler(result: eventDict!, err: nil)
                }
 
            }
            else
            {
                completionHandler(result: nil, err: "Enter Valid City Name")
            }
         } catch let err as NSError
        {
            completionHandler(result: nil, err: err.description)
        }
    }
    
    
}
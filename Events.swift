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
    let radius: Int = 25
    let page: Int = 1
    
    func getEventsList(place: String,date: String,completionHandler: (data: NSArray?, err: NSError?) -> Void )
    {
        let urlString:String = "\(BASE_URL)\(API_KEY)&location=\(place)&date=\(date)&within=\(radius)&page_number=\(page)"
        print(urlString)
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        request.addValue("\(API_KEY)", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
       
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if data == nil
            {
                completionHandler(data: nil, err: nil)
            }
            else if error != nil
            {
                completionHandler(data: nil, err: error)
            }
            else
            {
                self.parsedResult(data!, completionHandler: { (result, err) in
                    completionHandler(data: result, err: nil)
                })
                
            }
        }
        task.resume()
    }
    func parsedResult(data: NSData, completionHandler: (result: NSArray?, err: NSError?) -> Void)
    {
        let parsedResult: NSDictionary?
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
            let dict = parsedResult!["events"] as! NSDictionary
            let eventDict = dict["event"] as? NSArray
            completionHandler(result: eventDict!, err: nil)
        } catch let err as NSError
        {
            completionHandler(result: nil, err: err)
        }
    }
    
    
}
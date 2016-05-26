//
//  ViewController.swift
//  Events-NearBy
//
//  Created by kavita patel on 5/16/16.
//  Copyright © 2016 kavita patel. All rights reserved.
//

import UIKit

class EventsRefineController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    var timeList = ["All","Today","This Week","This Weekend","This Month"]
    
    @IBOutlet weak var categoryContentView: UIView!
    @IBOutlet weak var eventCategoryScrollView: UIScrollView!
    @IBOutlet weak var eventTimeBtn: UIButton!
    @IBOutlet weak var timeTableView: UITableView!
    @IBOutlet var categoryBtn: [MaterialButton]!
    let eventObj = Events()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        timeTableView.dataSource =  self
        timeTableView.delegate = self
        timeTableView.hidden = true
        eventCategoryScrollView.contentSize = categoryContentView.bounds.size
        // set event time to anytime
        eventTimeBtn.setTitle(Events.instance.date, forState: .Normal)
        for index in 0...categoryBtn.count-1
        {
            if categoryBtn[index].titleLabel?.text == Events.instance.category
            {
                // categoryBtn[index].backgroundColor = UIColor.redColor()
                categoryBtn[index].setTitleColor(UIColor.blackColor(), forState: .Normal)
            }
        }
     }
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        timeTableView.flashScrollIndicators()
    }
    @IBAction func eventTimeBtn(sender: AnyObject)
    {
        timeTableView.hidden = false
    }
   
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return timeList.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = timeTableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) 
        cell.textLabel?.text = timeList[indexPath.row]
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        eventTimeBtn.setTitle(timeList[indexPath.row], forState: .Normal)
        Events.instance.date = timeList[indexPath.row]
        timeTableView.hidden = true
    }
    @IBAction func eventCategoryPressed(sender: UIButton)
    {
        for index in 0...categoryBtn.count-1
        {
            if index == sender.tag
            {
               // categoryBtn[index].backgroundColor = UIColor.redColor()
                categoryBtn[index].setTitleColor(UIColor.blackColor(), forState: .Normal)
            }
            else
            {
                categoryBtn[index].setTitleColor(UIColor.redColor(), forState: .Normal)
                
            }
        }
       Events.instance.category = sender.titleLabel!.text!
    }
    
    func alertMsg(title: String, msg: String)
    {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
   
}


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
   
    let eventObj = Events()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        timeTableView.dataSource =  self
        timeTableView.delegate = self
        timeTableView.hidden = true
        eventCategoryScrollView.contentSize = categoryContentView.bounds.size
        // set event time to anytime
        let rowToSelect:NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
        timeTableView.selectRowAtIndexPath(rowToSelect, animated: true, scrollPosition:UITableViewScrollPosition.None)
        eventTimeBtn.setTitle(timeList[0], forState: .Normal)
        
    }
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
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
        timeTableView.hidden = true
    }
    @IBAction func eventCategoryPressed(sender: AnyObject)
    {
       
    }
    func saveEventPlace()
    {
        
    }
    @IBAction func doneBtn(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func alertMsg(title: String, msg: String)
    {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
   
}


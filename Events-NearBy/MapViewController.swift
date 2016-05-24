//
//  MapViewController.swift
//  Events-NearBy
//
//  Created by kavita patel on 5/21/16.
//  Copyright © 2016 kavita patel. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController,UITableViewDataSource, UITableViewDelegate
{
    var radiusList = ["25 Miles","50 Miles","100 Miles"]
    
    @IBOutlet weak var radiusBtn: UIButton!
    @IBOutlet weak var radiusTableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        radiusTableView.delegate = self
        radiusTableView.dataSource = self
        radiusTableView.hidden = true
        // Default selection of radius
        let rowToSelect:NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
        radiusTableView.selectRowAtIndexPath(rowToSelect, animated: true, scrollPosition:UITableViewScrollPosition.None)
        radiusBtn.setTitle(radiusList[0], forState: .Normal)
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return radiusList.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = radiusTableView.dequeueReusableCellWithIdentifier("radiusCell", forIndexPath: indexPath) 
        cell.textLabel?.text = radiusList[indexPath.row]
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        radiusBtn.setTitle(radiusList[indexPath.row], forState: .Normal)
        radiusTableView.hidden = true
    }
     
    @IBAction func radiusBtnPressed(sender: AnyObject)
    {
        radiusTableView.hidden = false
    }

}

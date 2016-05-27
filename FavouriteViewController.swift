//
//  FavouriteViewController.swift
//  Events-NearBy
//
//  Created by kavita patel on 5/26/16.
//  Copyright © 2016 kavita patel. All rights reserved.
//

import UIKit
import CoreData

class FavouriteViewController: UITableViewController
{

    var events = [NSManagedObject]()
    let request = NSFetchRequest(entityName: "Event")
    let appdelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var context: NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if let managedObjectContext: NSManagedObjectContext? = appDelegate.managedObjectContext
        {
            return managedObjectContext
        }
        else
        {
            return nil
        }
    }()
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        //let context = appdelegate.managedObjectContext
        
        do{
            let results = try context!.executeFetchRequest(request)
            events = results as! [NSManagedObject]
            
        }catch
        {
            print("Can not Load Events")
        }
        self.tableView.reloadData()
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return events.count
    }
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == UITableViewCellEditingStyle.Delete
        {
            //events.removeAtIndex(indexPath.row)
            context!.deleteObject(events.removeAtIndex(indexPath.row))
            do{
                
                try context?.save()
            }
            catch
            {
                print("Not Removed to Favourite")
            }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("favouriteCell", forIndexPath: indexPath) as! FavouriteTableViewCell
        if events.count != 0
        {
            cell.title.text = events[indexPath.row].valueForKey("title") as? String
            cell.venue.text = events[indexPath.row].valueForKey("venuePlace") as? String
            if let imgName = events[indexPath.row].valueForKey("image") as? String
            {
                let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
                let fileURL = documentsURL.URLByAppendingPathComponent(imgName)
                let img = UIImage(contentsOfFile: fileURL.path!)
                    cell.img.image = img
            }
            return cell

        }
        else
        {
            cell.title.text = ""
            cell.venue.text = ""
            cell.img.image = UIImage(named: "banner")
  
        }
        return cell
    }
    
}

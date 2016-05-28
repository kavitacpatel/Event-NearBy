//
//  AlertViewController.swift
//  Events-NearBy
//
//  Created by kavita patel on 5/28/16.
//  Copyright © 2016 kavita patel. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController
{
    func alertMsg(title: String, msg: String,VC: UIViewController)
    {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        VC.presentViewController(alert, animated: true, completion: nil)
    }
}

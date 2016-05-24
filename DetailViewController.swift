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

    override func viewDidLoad()
    {
        super.viewDidLoad()

    }

    @IBAction func cancelBtnPresed(sender: AnyObject)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }

}

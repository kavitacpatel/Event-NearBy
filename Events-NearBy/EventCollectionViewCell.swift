//
//  EventCollectionViewCell.swift
//  Events-NearBy
//
//  Created by kavita patel on 5/24/16.
//  Copyright © 2016 kavita patel. All rights reserved.
//

import UIKit

class EventCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var eventImage: UIImageView?
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var eventVenue: UILabel!
    @IBOutlet weak var eventTicket: UIButton!
    @IBOutlet weak var activityInd: UIActivityIndicatorView!
    @IBOutlet weak var favoriteBtn: UIButton!
}

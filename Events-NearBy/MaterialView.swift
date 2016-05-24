//
//  MaterialView.swift
//  Events-NearBy
//
//  Created by kavita patel on 5/16/16.
//  Copyright © 2016 kavita patel. All rights reserved.
//

import UIKit

class MaterialView: UIView
{

    override func awakeFromNib()
    {
        let shadowcolor: CGFloat = 157.0/255.0
        layer.cornerRadius = 2.0
        layer.shadowColor = UIColor(red: shadowcolor, green: shadowcolor, blue: shadowcolor, alpha: 1.0).CGColor
        layer.shadowRadius = 8.0
        layer.shadowOpacity = 0.8
        layer.shadowOffset = CGSizeMake(0.0, 2.0)
    }
}

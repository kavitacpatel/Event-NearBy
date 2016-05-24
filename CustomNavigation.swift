//
//  CustomNavigation.swift
//  Events-NearBy
//
//  Created by kavita patel on 5/24/16.
//  Copyright © 2016 kavita patel. All rights reserved.
//

import UIKit

class CustomNavigation: UINavigationBar
{
    override func awakeFromNib()
    {
        self.barStyle = .Default
        self.barTintColor = UIColor.redColor()
        let imgview = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
         imgview.contentMode = .ScaleAspectFit
        let img = UIImage(named: "banner")
        imgview.image = img
        self.topItem?.titleView = imgview
        
    }
    
}

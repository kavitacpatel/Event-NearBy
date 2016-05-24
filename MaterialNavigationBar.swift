//
//  MaterialNavigationBar.swift
//  Events-NearBy
//
//  Created by kavita patel on 5/24/16.
//  Copyright © 2016 kavita patel. All rights reserved.
//

import UIKit

class MaterialNavigationBar: UINavigationBar
{
    override func awakeFromNib()
    {
        let attrs = [
            NSForegroundColorAttributeName : UIColor.redColor(),
            NSFontAttributeName : UIFont(name: "Georgia-Bold", size: 24)!
        ]
        
        self.titleTextAttributes = attrs
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        let logo = UIImage(named: "banner.jpg")
         imageView.image = logo
        imageView.contentMode = .ScaleAspectFill
        self.setBackgroundImage(imageView.image, forBarMetrics: .Default)
    }
   
}

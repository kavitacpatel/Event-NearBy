//
//  MaterialNavigation.swift
//  Events-NearBy
//
//  Created by kavita patel on 5/24/16.
//  Copyright © 2016 kavita patel. All rights reserved.
//

import UIKit

class MaterialNavigation: UINavigationItem
{
    override func awakeFromNib() {
        let attrs = [
            NSForegroundColorAttributeName : UIColor.redColor(),
            NSFontAttributeName : UIFont(name: "Georgia-Bold", size: 24)!
        ]
        
        let logo = UIImage(named: "banner.jpg")
        let imageview = UIImageView(image: logo)
        imageview.contentMode = .ScaleAspectFit
        imageview.frame = CGRect(x: 0, y: 0, width: self.titleView!.frame.width, height: self.titleView!.frame.height)
        self.titleView = imageview
        
    }
    

}

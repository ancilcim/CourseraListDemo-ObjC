//
//  ImageDrawer.swift
//  CourseraListDemo-ObjC
//
//  Created by Imanou PETIT on 17/07/2015.
//  Copyright (c) 2015 Ancil Marshall. All rights reserved.
//

import UIKit

class ImageDrawer: NSObject {

    /* Generate a hamburger image that can be use as a custom image in a UIBarButtonItem */
    
    class ImageDrawer {
        
        private static var _hamburgerMenuImage: UIImage?
        
        class var hamburgerMenuImage: UIImage {
            if let image = _hamburgerMenuImage {
                return image
            }
            
            let rect = CGRect(x: 0, y: 0, width: 35, height: 35)
            UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
            
            let outterMargin: CGFloat = 6
            let innerMargin: CGFloat = 5
            let barWidth = rect.width - outterMargin * 2
            let barHeight = (rect.height - outterMargin * 2 - innerMargin * 2) / 3
            
            let rectanglePath1 = UIBezierPath(rect: CGRect(x: outterMargin, y: outterMargin, width: barWidth, height: barHeight))
            UIColor.blackColor().setFill()
            rectanglePath1.fill()
            
            let rectanglePath2 = UIBezierPath(rect: CGRect(x: outterMargin, y: outterMargin + innerMargin + barHeight, width: barWidth, height: barHeight))
            UIColor.blackColor().setFill()
            rectanglePath2.fill()
            
            let rectanglePath3 = UIBezierPath(rect: CGRect(x: outterMargin, y: outterMargin + innerMargin * 2 + barHeight * 2, width: barWidth, height: barHeight))
            UIColor.blackColor().setFill()
            rectanglePath3.fill()
            
            _hamburgerMenuImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            
            return _hamburgerMenuImage!
        }
        
    }
    
}

//
//  UIFont+YBKAdditions.swift
//  YouBike
//
//  Generated on Zeplin. (by snakeking on 4/26/2016).
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

import UIKit

extension UIFont {
    class func ybkTextStyleFont(fontSize: CGFloat) -> UIFont? {
    return UIFont(name: "Helvetica-Bold", size: fontSize)
  }

    class func ybkTextStyle2Font(fontSize: CGFloat) -> UIFont? {
    return UIFont(name: "PingFangTC-Medium", size: fontSize)
  }
    
    class func ybkTextStylePingFangTCRegular(fontSize: CGFloat) -> UIFont? {
        return UIFont(name: "PingFangTC-Regular", size: fontSize)
    }
    
    class func ybkTextStylePingFangTCMedium(fontSize: CGFloat) -> UIFont? {
        return UIFont(name: "PingFangTC-Medium", size: fontSize)
    }
    
    class func ybkTextStyleHelveticaBold(fontSize: CGFloat) -> UIFont? {
        return UIFont(name: "Helvetica-Bold", size: fontSize)
    }
    
    class func ybkTextStyleHelvetica(fontSize: CGFloat) -> UIFont? {
        return UIFont(name: "Helvetica", size: fontSize)
    }

    
}
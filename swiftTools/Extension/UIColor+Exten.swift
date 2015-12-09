//
//  ColorHex.swift
//  swiftTest
//
//  Created by napiao on 15/11/26.
//  Copyright © 2015年 JINMARONG. All rights reserved.
//

import Foundation


extension UIColor {
    
      public class func colorWithHexString (hex:String) -> UIColor {
            var cString:String
            = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
            if (cString.hasPrefix("#")){
                cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))
            }
        
            if (cString.characters.count != 6) {
                    return UIColor.grayColor()
            }
        
            var rString = cString.substringToIndex(cString.startIndex.advancedBy(2))
            
            var gString = cString.substringFromIndex(cString.startIndex.advancedBy(2)).substringToIndex(cString.startIndex.advancedBy(3))
            
            var bString =  cString.substringFromIndex(cString.startIndex.advancedBy(4)).substringToIndex(cString.startIndex.advancedBy(2))
        
            var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
            
            NSScanner.init(string: rString).scanHexInt(&r)
            
            NSScanner.init(string: gString).scanHexInt(&g)
            
            NSScanner.init(string: bString).scanHexInt(&b)
        
            return UIColor(red:CGFloat(r)/CGFloat(255.0), green:CGFloat(g)/CGFloat(255.0), blue:CGFloat(b)/CGFloat(255.0), alpha:CGFloat(1))
            
    }
    
    class func colorWith(red: Int, green: Int, blue: Int, alpha: CGFloat) -> UIColor {
        let color = UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
        return color
    }

}
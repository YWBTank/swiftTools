//
//  String+Exten.swift
//  swiftTest
//
//  Created by napiao on 15/11/27.
//  Copyright © 2015年 JINMARONG. All rights reserved.
//

import Foundation
import CoreLocation

extension String {
    /// 将字符串转换成经纬度
    func stringToCLLocationCoordinate2D(separator: String) -> CLLocationCoordinate2D? {
        let arr = self.componentsSeparatedByString(separator)
        if arr.count != 2 {
            return nil
        }
        
        let latitude: Double = NSString(string: arr[1]).doubleValue
        let longitude: Double = NSString(string: arr[0]).doubleValue
        
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

}
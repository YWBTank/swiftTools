//
//  YWBVersionTools.swift
//  swiftTest
//
//  Created by napiao on 15/11/26.
//  Copyright © 2015年 JINMARONG. All rights reserved.
//

//private let VERSION_IOS_REVIEWS_URL_FORMAT = "itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=990869716"

private let VERSION_IOS7_REVIEWS_URL_FORMAT = "itms-apps://itunes.apple.com/app/id990869716"

private let VERSION_IOS8_REVIEWS_URL_FORMAT = "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=990869716&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"

import Foundation

// 单例
class VersionTools {
    private static let shareInstance = VersionTools()
        class var shareManager : VersionTools {
        return shareInstance
        }
    
    func apenAppReviews() {
        var url:NSURL
        
    if UIDevice.currentDevice().systemVersion.compare("7.0") != NSComparisonResult.OrderedDescending{
            url = NSURL(string: VERSION_IOS7_REVIEWS_URL_FORMAT)!
        } else {
            url = NSURL(string: VERSION_IOS8_REVIEWS_URL_FORMAT)!
        }
    
        UIApplication.sharedApplication().openURL(url)
    }
    
}
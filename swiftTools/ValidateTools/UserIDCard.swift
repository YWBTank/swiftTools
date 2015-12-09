//
//  UserIDCard.swift
//  swiftTest
//
//  Created by napiao on 15/11/25.
//  Copyright © 2015年 JINMARONG. All rights reserved.
//  根据身份正获取信息

import Foundation

class UserIDCard{
    
    
    // 获取年
    class func obtainYearWith(IDCard:String) ->String {
        var newIDCard = IDCard
        if self.validate18PaperId(IDCard) {
            if IDCard.characters.count == 15 {
                newIDCard = self .exchange15IDCardTo18IDCard(IDCard)
            }
            return self .getStringWithRange(newIDCard, value1: 6, value2: 4)
        }
        return ""
    }
    
    //获取月
    class func obtainMonthWith(IDCard:String) ->String {
        var newIDCard = IDCard
        if self.validate18PaperId(IDCard) {
            if IDCard.characters.count == 15 {
                newIDCard = self .exchange15IDCardTo18IDCard(IDCard)
            }
            return self .getStringWithRange(newIDCard, value1: 10, value2: 2)
        }
        return ""
    }
    
    // 获取日
    class func obtainDayWith(IDCard:String) ->String {
        var newIDCard = IDCard
        if self.validate18PaperId(IDCard) {
            if IDCard.characters.count == 15 {
                newIDCard = self .exchange15IDCardTo18IDCard(IDCard)
            }
            return self.getStringWithRange(newIDCard, value1: 12, value2: 2)
        }
        return ""
    }
    
    //获取生日
    class func obtainBirthdayWith(IDCard:String)->String {
        var newIDCard = IDCard
        if self.validate18PaperId(IDCard) {
            if IDCard.characters.count == 15 {
                newIDCard = self .exchange15IDCardTo18IDCard(IDCard)
            }
            return self.getStringWithRange(newIDCard, value1: 6, value2: 4)+"-"+self.getStringWithRange(newIDCard, value1: 10, value2: 2)+"-"+self.getStringWithRange(newIDCard, value1: 12, value2: 2)
        }
        return ""
    }
    
    //获取年龄
    class func obtainAgeWith(IDCard:String)->String {
        let IDCardYear: Int = Int(self.obtainYearWith(IDCard))!
        let IDCardMonth:Int = Int(self.obtainMonthWith(IDCard))!
        let IDCardDay:Int = Int(self.obtainDayWith(IDCard))!
        
        var iAge = 0
        
        let now = NSDate()
        
        let cal = NSCalendar.currentCalendar()
        
        let unitFlags:NSCalendarUnit = [NSCalendarUnit.Year,NSCalendarUnit.Month,NSCalendarUnit.Day, NSCalendarUnit.Hour,NSCalendarUnit.Minute , NSCalendarUnit.Second]
        
        let dateComponents:NSDateComponents = cal.components(unitFlags, fromDate: now)
        let y = dateComponents.year
        let m = dateComponents.month
        let d = dateComponents.day
        
        if let IDyear:Int = IDCardYear, let IDMonth:Int = IDCardMonth, let IDDay:Int = IDCardDay {
            if y > IDyear {
                iAge += y - IDyear - 1
                
                if m > IDMonth {
                    ++iAge
                } else if m == IDMonth{
                    if d >= IDDay {
                        ++iAge
                    }
                }
            }
        }
        return String(iAge)
    }
    
    // 获取性别
    class func obtainSexWith(IDCard:String)->String {
        var newIDCard = IDCard
        if self.validate18PaperId(IDCard) {
            if IDCard.characters.count == 15 {
                newIDCard = self.exchange15IDCardTo18IDCard(IDCard)
            }
            let a = self.getStringWithRange(newIDCard, value1: 14, value2: 3)
            
            if a == "1" {
                return "男"
            } else {
                return "女"
            }
        }
        return ""
    }
    
    
    //15位身份证转为18位身份证
    private class func exchange15IDCardTo18IDCard(IDCard:String)->String {
        var carid:String = IDCard
        
        // 加权因子
        let  R:[Int] = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 ]
        // 校验码
        let sChecker:[String] = ["1","0", "X" , "9", "8", "7", "6", "5", "4", "3","2" ]
        
        var  mString:String = IDCard
        
        if IDCard.characters.count == 15 {
            mString.insert(Character.init("1"), atIndex: mString.startIndex.advancedBy(6))
            mString.insert(Character.init("9"), atIndex: mString.startIndex.advancedBy(7))
            
            var p = 0
            
            let pid = (mString as NSString).UTF8String
            
            for i in 0...16 {
                p += (pid[i]-48)*R[i]
            }
            
            let o:Int = p%11
            
            let string_content = String(format: "%@", sChecker[o])
            
            mString.insert(Character.init(string_content), atIndex: mString.endIndex.advancedBy(0))
            
            carid = mString
        }
        return carid;
    }
    
    // 验证身份证是否合法
    private class func validate18PaperId(input:String) ->Bool{
        if (input.characters.count != 15)&&(input.characters.count != 18) {
            return false
        }
        
        let carid:String = input
        
        var lSumQT = 0
        // 加权因子
        let  R:[Int] = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 ]
        // 校验码
        let sChecker:[String] = ["1","0", "X" , "9", "8", "7", "6", "5", "4", "3","2" ]
        
        var  mString:String = input
        
        if input.characters.count == 15 {
            mString.insert(Character.init("1"), atIndex: mString.startIndex.advancedBy(6))
            mString.insert(Character.init("9"), atIndex: mString.startIndex.advancedBy(7))
            
            var p = 0
            
            let pid = (mString as NSString).UTF8String
            
            for i in 0...16 {
                p += (pid[i]-48)*R[i]
            }
            
            let o:Int = p%11
            
            let string_content = String(format: "%@", sChecker[o])
            
            mString.insert(Character.init(string_content), atIndex: mString.endIndex.advancedBy(0))
        }
        
        let sProvince = carid.substringToIndex(carid.startIndex.advancedBy(2))
        
        if !self.areaCode(sProvince) {
            return false
        }
        
        // 判断年月日是否有效
        // 年
        let strYear = (self.getStringWithRange(carid, value1: 6, value2: 4) as NSString).intValue
        // 月
        let strMonth = (self.getStringWithRange(carid, value1: 10, value2: 2) as NSString).intValue
        // 日
        let strDay = (self.getStringWithRange(carid, value1: 12, value2: 2) as NSString).intValue
        
        let localZone:NSTimeZone = NSTimeZone.localTimeZone()
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        dateFormatter.timeZone = localZone
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        print(String(format: "%d-%d-%d", strYear,strMonth,strDay))
        
        let data = dateFormatter.dateFromString(String(format: "%d-%d-%d 12:01:01", strYear,strMonth,strDay))
        
        if data == nil {
            return false
        }
        
        let PaperId:UnsafePointer<CChar> = (carid as NSString).UTF8String
        
        print(PaperId)
        
        if carid.characters.count != 18 {
            return false;
        }
        for i in 0..<18 {
            if ((isdigit(Int32(PaperId[i]))).distanceTo(1) != 0 && (!("X".characterAtIndex(0) == UInt16(PaperId[i]) || UnicodeScalar("x").value == UInt32(PaperId[i])) && 17 == i))
            {
                return false;
            }
        }
        
        for i in 0...16 {
            lSumQT += (PaperId[i] - 48) * R[i]
        }
        
        if (sChecker[lSumQT%11] as NSString).characterAtIndex(0) != UInt16(PaperId[17]) {
            return false
        }
        return true
    }
    
    
    // 私有方法 字符串的范围取值
    private class func getStringWithRange(str:String,value1:Int,value2:Int)->String{
        return  (str as NSString).substringWithRange(NSMakeRange(value1, value2))
    }
    
    // 私有方法 判断是否符合地理编码
    private class func areaCode(code:String)->Bool {
        var dict = [String:String]()
        dict["11"] = "北京"
        dict["12"] = "天津"
        dict["13"] = "河北"
        dict["14"] = "山西"
        dict["15"] = "内蒙古"
        dict["21"] = "辽宁"
        dict["22"] = "吉林"
        dict["23"] = "黑龙江"
        dict["31"] = "上海"
        dict["32"] = "江苏"
        dict["33"] = "浙江"
        dict["34"] = "安徽"
        dict["35"] = "福建"
        dict["36"] = "江西"
        dict["37"] = "山东"
        dict["41"] = "河南"
        dict["42"] = "湖北"
        dict["43"] = "湖南"
        dict["44"] = "广东"
        dict["45"] = "广西"
        dict["46"] = "海南"
        dict["50"] = "重庆"
        dict["51"] = "四川"
        dict["52"] = "贵州"
        dict["53"] = "云南"
        dict["54"] = "西藏"
        dict["61"] = "陕西"
        dict["62"] = "甘肃"
        dict["63"] = "青海"
        dict["64"] = "宁夏"
        dict["65"] = "新疆"
        dict["71"] = "台湾"
        dict["81"] = "香港"
        dict["82"] = "澳门"
        dict["91"] = "国外"
        if dict[code] == nil {
            return false
        }
        return true
    }
    
}

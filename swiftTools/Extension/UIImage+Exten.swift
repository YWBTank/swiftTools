//
//  UIImage+Name.swift
//  swiftTest
//
//  Created by napiao on 15/11/27.
//  Copyright © 2015年 JINMARONG. All rights reserved.
//

import Foundation



extension UIImage {
    
    static func addRoundedRectToPath(context:CGContextRef, rect:CGRect, ovalWidth:CGFloat,
        ovalHeight:CGFloat)
    {
        let fw:CGFloat, fh:CGFloat;
    
    if (ovalWidth == 0 || ovalHeight == 0)
    {
    CGContextAddRect(context, rect)
    return
    }
    
    CGContextSaveGState(context)
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect))
    CGContextScaleCTM(context, ovalWidth, ovalHeight)
    fw = CGRectGetWidth(rect) / ovalWidth
    fh = CGRectGetHeight(rect) / ovalHeight
    
    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
    
    CGContextClosePath(context)
    CGContextRestoreGState(context)
    }
    
    
    // 圆角图片的生成
    
    class func creatRoundedRectImage(image:UIImage, size:CGSize, radius:CGFloat)-> UIImage {
        let w = Int(size.width)
        let h = Int(size.height)
        var img = image
        
        let  colorSpace:CGColorSpaceRef = CGColorSpaceCreateDeviceRGB()!;
        let bitmapInfo = CGBitmapInfo(rawValue:CGImageAlphaInfo.PremultipliedFirst.rawValue)
        var a:Void
        let context:CGContextRef = CGBitmapContextCreate(&a, w, h, 8, 4 * w, colorSpace, bitmapInfo.rawValue)!;
        let  rect = CGRectMake(0, 0,CGFloat(w), CGFloat(h));
        
        CGContextBeginPath(context)
        self.addRoundedRectToPath(context, rect: rect, ovalWidth: radius, ovalHeight: radius)
        CGContextClosePath(context)
        CGContextClip(context);
        CGContextDrawImage(context, CGRectMake(0, 0, CGFloat(w), CGFloat(h)), img.CGImage)
        let imageMasked:CGImageRef = CGBitmapContextCreateImage(context)!
        img = UIImage(CGImage:imageMasked)
        return img;
    }
    
    // 根据颜色生成图片
    class func createImageWithColor(color:UIColor)->UIImage {
        let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        UIGraphicsBeginImageContext(rect.size);
        let context:CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, rect);
        let theImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return theImage;
    }
    
    
    // 图片拉伸
    class func resizedImageWithName(name:String!, left:Float, right:Float)->UIImage {
        let image = UIImage(named: name)!
        return (image.stretchableImageWithLeftCapWidth(Int(Float((image.size.width)) * left), topCapHeight:Int(Float((image.size.height)) * right)))
    }
    
    // 图片中间拉伸
    class func resizedImageWithName(name:String)->UIImage {
        return self.resizedImageWithName(name, left: 0.5, right: 0.5)
    }
    
    
    // 图片的缩放
    func transformWidth(width:CGFloat,height:CGFloat)->UIImage {
        let destW = width
        let destH = height
        let sourceW = width
        let sourceH = height
        
        let imageRef:CGImageRef = self.CGImage!
        let bitmapInfo =  CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedFirst.rawValue | CGBitmapInfo.ByteOrder32Little.rawValue)
        var tempa:Void
        let bitmap:CGContextRef = CGBitmapContextCreate(&tempa,Int(destW), Int(destH), CGImageGetBitsPerComponent(imageRef),Int(4*destW),CGImageGetColorSpace(imageRef), bitmapInfo.rawValue)!
        
        CGContextDrawImage(bitmap, CGRectMake(0, 0, sourceW, sourceH), imageRef)
        
        let ref:CGImageRef = CGBitmapContextCreateImage(bitmap)!
        let resultImage:UIImage = UIImage(CGImage: ref)
        return resultImage;
    }
    
    /// 按尺寸裁剪图片大小
    class func imageClipToNewImage(image: UIImage, newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize)
        image.drawInRect(CGRect(origin: CGPointZero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// 将传入的图片裁剪成带边缘的原型图片
    class func imageWithClipImage(image: UIImage, borderWidth: CGFloat, borderColor: UIColor) -> UIImage {
        let imageWH = image.size.width
        //        let border = borderWidth
        let ovalWH = imageWH + 2 * borderWidth
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(ovalWH, ovalWH), false, 0)
        let path = UIBezierPath(ovalInRect: CGRectMake(0, 0, ovalWH, ovalWH))
        borderColor.set()
        path.fill()
        
        let clipPath = UIBezierPath(ovalInRect: CGRectMake(borderWidth, borderWidth, imageWH, imageWH))
        clipPath.addClip()
        image.drawAtPoint(CGPointMake(borderWidth, borderWidth))
        
        let clipImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return clipImage
    }
    
    /// 将传入的图片裁剪成圆形图片
    func imageClipOvalImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        let ctx = UIGraphicsGetCurrentContext()
        let rect = CGRectMake(0, 0, self.size.width, self.size.height)
        CGContextAddEllipseInRect(ctx, rect)
        
        CGContextClip(ctx)
        self.drawInRect(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }



    func imageByApplyingAlpha(alpha:CGFloat)-> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        
        let ctx:CGContextRef = UIGraphicsGetCurrentContext()!
        let area:CGRect = CGRectMake(0, 0, self.size.width, self.size.height);
        
        CGContextScaleCTM(ctx, 1, -1);
        CGContextTranslateCTM(ctx, 0, -area.size.height);
        
        CGContextSetBlendMode(ctx, CGBlendMode.Multiply);
        
        CGContextSetAlpha(ctx, alpha);
        
        CGContextDrawImage(ctx, area, self.CGImage);
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        return newImage
    }
    
    
    // 图片的旋转
    func imageRotatedByDegrees(degrees:CGFloat)-> UIImage {
        let width = CGImageGetWidth(self.CGImage);
        let height = CGImageGetHeight(self.CGImage);
        
        var rotatedSize = CGSize()
        
        rotatedSize.width = CGFloat(width);
        rotatedSize.height = CGFloat(height);
        
        UIGraphicsBeginImageContext(rotatedSize);
        let bitmap:CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
        CGContextRotateCTM(bitmap, degrees * CGFloat(M_PI) / 180);
        CGContextRotateCTM(bitmap,CGFloat(M_PI));
        CGContextScaleCTM(bitmap, -1.0, 1.0);
        CGContextDrawImage(bitmap, CGRectMake(-rotatedSize.width/2, -rotatedSize.height/2, rotatedSize.width, rotatedSize.height), self.CGImage);
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;

    }
    
    
}
//
//  UIImage+ColorPicking.swift
//  SwitUIColorPicker
//
//  Created by Alex Chase on 6/3/19.
//  Copyright © 2019 AlexChase. All rights reserved.
//

import UIKit

extension UIImage {
    
    func  getPixelColor(point: CGPoint, alpha:Bool = true) -> UIColor? {
        if alpha { return getPixelWithAlpha(from: point) }
        return getPixelColor(from: point)
    }
    

    func getPixelColor(from point:CGPoint) -> UIColor? {
        guard let pixelBuffer = unSafeBitmapData() else { return nil }
        
        let pixel = pixelBuffer + Int(point.y) * Int(size.width) + Int(point.x)
        
        let r = relativeValue(red(pixel.pointee))
        let g = relativeValue(green(pixel.pointee))
        let b = relativeValue(blue(pixel.pointee))
        let a = relativeValue(alpha(pixel.pointee))
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
    func getPixelWithAlpha(from point: CGPoint) -> UIColor? {
        guard let cgImage = self.cgImage else { return nil}
        let width = Int(size.width)
        let height = Int(size.height)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        if let context = CGContext.init(data: nil,
                                        width: width,
                                        height: height,
                                        bitsPerComponent: 8,
                                        bytesPerRow: width * 4,
                                        space: colorSpace,
                                        bitmapInfo: CGBitmapInfo.byteOrder32Little.rawValue |
                                            CGImageAlphaInfo.premultipliedFirst.rawValue) {
            
            context.draw(cgImage, in: CGRect(origin: .zero, size: size))
            guard let pixelBuffer = unSafeBitmapData() else { return nil }
            
            let pixel = pixelBuffer + Int(point.y) * width + Int(point.x)
            let r = relativeValue(red(pixel.pointee))
            let g = relativeValue(green(pixel.pointee))
            let b = relativeValue(blue(pixel.pointee))
            let a = relativeValue(alpha(pixel.pointee))
            return UIColor(red: r, green: g, blue: b, alpha: a)
        }
        return nil
    }
    
    func unSafeBitmapData() -> UnsafeMutablePointer<UInt32>? {
        guard let cgImage = self.cgImage else { return nil }
        
        let width = Int(self.size.width)
        let height = Int(self.size.height)
        let bitsPerComponent = 8
        
        let bytesPerPixel = 4
        let bytesPerRow = width * bytesPerPixel
        let maxPix = width * height
        
        let imageData =  calloc(maxPix, MemoryLayout<UInt32>.size).assumingMemoryBound(to: UInt32.self)
        defer { imageData.deallocate() }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue
        bitmapInfo |= CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        guard let imageContext = CGContext(data: imageData, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else { return nil }
        imageContext.draw(cgImage, in: CGRect(origin: CGPoint.zero, size: self.size))
        return imageData
    }
    
    func red(_ color: UInt32)   -> UInt8 { UInt8((color >> 0) & 255) }
    func green(_ color: UInt32) -> UInt8 { UInt8((color >> 8) & 255) }
    func blue(_ color: UInt32)  -> UInt8 { UInt8((color >> 16) & 255) }
    func alpha(_ color: UInt32) -> UInt8 { UInt8((color >> 24) & 255) }
    
    func relativeValue(_ p:UInt8) -> CGFloat { CGFloat(p) / 255.0 }

    func rgba(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) -> UInt32 {
        let a:UInt32 = UInt32(alpha)
        let r:UInt32 = UInt32(red)
        let g:UInt32 = UInt32(green)
        let b:UInt32 = UInt32(blue)
        return (a << 24) | (r << 16) | (g << 8) | (b << 0)
    }
}

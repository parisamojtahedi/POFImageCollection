//
//  UIImage+Extension.swift
//  POFAssignment
//
//  Created by Parisa on 2020-01-25.
//  Copyright © 2020 Parisa. All rights reserved.
//

import UIKit

extension UIImage{
    var rounded: UIImage {
        let rect = CGRect(origin:CGPoint(x: 0, y: 0), size: self.size)
        UIGraphicsBeginImageContextWithOptions(self.size, false, 1)
        
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()

        let pathRect = rect.insetBy(dx: 10 / 2.0, dy: 10 / 2.0)
        let path = UIBezierPath(roundedRect: pathRect, cornerRadius: 10)
        context?.beginPath()
        context?.addPath(path.cgPath)
        context?.closePath()
        context?.clip()
        self.draw(in: rect)
        context?.restoreGState()
        UIColor.white.setStroke()
        path.lineWidth = 10
        path.stroke()
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? self
    }
    
    var shadowAdded: UIImage {
        guard let cgImage = self.cgImage else { return self }
        let blurSize: CGFloat = 10
        let shadowColor = UIColor(white: 0, alpha: 0.8).cgColor
        let context = CGContext(data: nil,
                                width: Int(self.size.width + blurSize),
                                height: Int(self.size.height + blurSize),
                                bitsPerComponent: cgImage.bitsPerComponent,
                                bytesPerRow: 0,
                                space: CGColorSpaceCreateDeviceRGB(),
                                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!

        context.setShadow(offset: CGSize(width: blurSize/2, height: -blurSize/2),
                          blur: blurSize,
                          color: shadowColor)
        context.draw(cgImage,
                     in: CGRect(x: 0,
                                y: blurSize,
                                width: self.size.width,
                                height: self.size.height),
                     byTiling: false)

        return UIImage(cgImage: context.makeImage() ?? cgImage)
    }
}

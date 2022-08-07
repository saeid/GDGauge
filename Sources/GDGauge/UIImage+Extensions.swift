//
//  UIImage+Extensions.swift
//  gaugetest
//
//  Created by Saeid on 2022-08-07.
//  Copyright © 2022 Saeid Basirnia. All rights reserved.
//

import UIKit

extension UIImage {
    private func getContext(
        data: UnsafeMutableRawPointer?,
        width: Int,
        height: Int,
        bitsPerComponent: Int,
        bytesPerRow: Int,
        space: CGColorSpace,
        bitmapInfo: UInt32
    ) -> CGContext? {
        CGContext(
            data: data,
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bytesPerRow: bytesPerRow,
            space: space,
            bitmapInfo: bitmapInfo
        )
    }

    func maskWithColor(color: UIColor) -> UIImage? {
        guard let maskImage = cgImage else {
            fatalError("Can not get image data")
        }
        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        guard let context = getContext(
            data: nil,
            width: Int(width),
            height: Int(height),
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: colorSpace,
            bitmapInfo: bitmapInfo.rawValue
        ) else {
            fatalError("Can not create the context")
        }
        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)
        
        guard let cgImage = context.makeImage() else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
}

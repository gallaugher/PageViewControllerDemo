//
//  UIImage+Alpha.swift
//  PageViewControllerDemo
//
//  Created by John Gallaugher on 11/18/16.
//  Copyright © 2016 Gallaugher. All rights reserved.
//

import UIKit

extension UIImage {
    func alpha(value: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

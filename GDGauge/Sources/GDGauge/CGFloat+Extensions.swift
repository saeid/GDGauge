//
//  CGFloat+Extensions.swift
//  
//
//  Created by Saeid on 2022-08-07.
//

import UIKit

extension CGFloat {
    var radian: CGFloat {
        CGFloat(self * CGFloat(.pi / 180.0))
    }
}

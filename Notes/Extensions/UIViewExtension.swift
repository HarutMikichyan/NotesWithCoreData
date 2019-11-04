//
//  UIViewExtension.swift
//  Notes
//
//  Created by Harut Mikichyan on 10/31/19.
//  Copyright © 2019 Harut Mikichyan. All rights reserved.
//

import UIKit

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, topPad: CGFloat, bottom: NSLayoutYAxisAnchor?, bottomPad: CGFloat,
                left: NSLayoutXAxisAnchor?, leftPad: CGFloat, right: NSLayoutXAxisAnchor?, rightPad: CGFloat,
                height: CGFloat, width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top { topAnchor.constraint(equalTo: top, constant: topPad).isActive = true }
        if let bottom = bottom { bottomAnchor.constraint(equalTo: bottom, constant: -bottomPad).isActive = true }
        if let left = left { leftAnchor.constraint(equalTo: left, constant: leftPad).isActive = true }
        if let right = right { rightAnchor.constraint(equalTo: right, constant: -rightPad).isActive = true }
        
        if height > 0 { heightAnchor.constraint(equalToConstant: height).isActive = true }
        if width > 0 { widthAnchor.constraint(equalToConstant: width).isActive = true }
    }
}

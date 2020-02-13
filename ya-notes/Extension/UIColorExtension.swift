//
//  UIColorExtension.swift
//  ya-notes
//
//  Created by Nikita Pekurin on 2/10/20.
//  Copyright © 2020 Nikita Pekurin. All rights reserved.
//

import UIKit.UIColor

extension UIColor {
    
    func hexString() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = Int(r * 255) << 16 | Int(g * 255) << 8 | Int(b * 255) << 0
        
        return NSString(format:"#%06x", rgb) as String
    }
    
}

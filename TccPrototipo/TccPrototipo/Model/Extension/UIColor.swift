//
//  UIColor.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 06/04/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        //scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
    
    static let lightGreen = UIColor.init(hex: "B2FBBA")
    static let triangleYellow = UIColor.init(hex: "F5CE23")
    static let squareRed = UIColor.init(hex: "F5243D")
    static let circleBlue = UIColor.init(hex: "2587F5")
}



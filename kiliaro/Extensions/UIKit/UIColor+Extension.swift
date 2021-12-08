//
//  UIColor+Extension.swift
//  kiliaro
//
//  Created by Emad Bayramy on 12/5/21.
//

import UIKit

extension UIColor {
    
    private enum CustomColor: String {
        
        case kiliaroOrange
        
        var color: UIColor {
            guard let color = UIColor(named: rawValue) else {
                assertionFailure("Color missing from asset catalogue")
                return .systemOrange
            }
            return color
        }
    }
    
    static var kiliaroOrange: UIColor = {
        CustomColor.kiliaroOrange.color
    }()
}

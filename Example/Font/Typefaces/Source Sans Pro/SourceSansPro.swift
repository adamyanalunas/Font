//
//  SourceSansPro.swift
//  Font
//
//  Created by Adam Yanalunas on 10/2/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import Font

public extension Font {
    private static func sourceSansPro(weight: FontWeight) -> String {
        switch weight {
        case .ultralight:
            return "ExtraLight"
            
        case .thin:
            fallthrough
            
        case .light:
            return "Light"
            
        case .regular:
            fallthrough
            
        case .medium:
            return "Regular"
            
        case .semibold:
            return "Semibold"
            
        case .heavy:
            return "Bold"
            
        case .black:
            return "Black"
            
        default:
            return "Regular"
        }
    }
    
    private static func name(weight: FontWeight, style: FontStyle) -> String {
        let base = "SourceSansPro"
        let weightNumber = sourceSansPro(weight: weight)
        
        let weightAndStyle: String
        switch style {
        case _ where style == .italic && (weight == .regular || weight == .medium):
            weightAndStyle = "It"
        case .italic:
            weightAndStyle = "\(weightNumber)It"
        default:
            weightAndStyle = weightNumber
        }
        
        return "\(base)-\(weightAndStyle)"
    }
    
    static func SourceSansPro(size: CGFloat = 16, weight: FontWeight = .medium, style: FontStyle = .none) -> Font {
        let fontName = name(weight: weight, style:style)
        return Font(fontName: fontName, size: size, weight: weight, style: style)
    }
}

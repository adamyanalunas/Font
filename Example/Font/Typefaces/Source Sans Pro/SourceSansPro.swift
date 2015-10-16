//
//  SourceSansPro.swift
//  Font
//
//  Created by Adam Yanalunas on 10/2/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import Font

public extension Font {
    private static func sourceSansProWeight(weight:FontWeight) -> String {
        switch weight {
        case .Ultralight:
            return "ExtraLight"
            
        case .Thin:
            fallthrough
        case .Light:
            return "Light"
            
        case .Regular:
            fallthrough
        case .Medium:
            return "Regular"
            
        case .Semibold:
            return "Semibold"
            
        case .Heavy:
            return "Bold"
            
        case .Black:
            return "Black"
        }
    }
    
    private static func name(weight:FontWeight, style:FontStyle) -> String {
        let base = "SourceSansPro"
        let weightNumber = sourceSansProWeight(weight)
        
        let weightAndStyle:String
        switch style {
        case _ where style == .Italic && (weight == .Regular || weight == .Medium):
            weightAndStyle = "It"
        case .Italic:
            weightAndStyle = "\(weightNumber)It"
        default:
            weightAndStyle = weightNumber
        }
        
        return "\(base)-\(weightAndStyle)"
    }
    
    static func SourceSansPro(size:CGFloat = 16, weight:FontWeight = .Medium, style:FontStyle = .None) -> Font {
        let fontName = name(weight, style:style)
        return Font(fontName: fontName, size: size, weight: weight, style: style)
    }
}

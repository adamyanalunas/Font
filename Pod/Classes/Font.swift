//
//  Font.swift
//  Pods
//
//  Created by Adam Yanalunas on 10/2/15.
//
//

import Foundation

public enum FontStyle:String {
    case None, Italic
}

public enum FontWeight:String {
    case Ultralight, Thin, Light, Regular, Medium, Semibold, Heavy, Black
    
    public init(type:String) {
        self = FontWeight(rawValue: type)!
    }
}

public struct Font: Equatable {
    public typealias FontScaler = (sizeClass:String) -> CGFloat
    public let fontName:String
    public let size:CGFloat
    public let weight:FontWeight
    public let style:FontStyle
    
    public init(fontName:String, size:CGFloat, weight:FontWeight = .Medium, style:FontStyle = .None) {
        self.fontName = fontName
        self.size = size
        self.weight = weight
        self.style = style
    }
    
    private func dynamicSize(sizeClass:String) -> CGFloat {
        let adjustedSize:CGFloat
        
        switch sizeClass {
        case UIContentSizeCategoryExtraSmall:
            adjustedSize = floor(size / 1.6) //10
        case UIContentSizeCategorySmall:
            adjustedSize = floor(size / 1.4) //11
        case UIContentSizeCategoryMedium:
            adjustedSize = floor(size / 1.2) //13
        case UIContentSizeCategoryLarge:
            adjustedSize = size //16
        case UIContentSizeCategoryExtraLarge:
            adjustedSize = floor(size * 1.15) //18
        case UIContentSizeCategoryExtraExtraLarge:
            adjustedSize = floor(size * 1.25) //20
        case UIContentSizeCategoryExtraExtraExtraLarge:
            adjustedSize = floor(size * 1.4) //22
        case UIContentSizeCategoryAccessibilityMedium:
            adjustedSize = floor(size * 1.5) //24
        case UIContentSizeCategoryAccessibilityLarge:
            adjustedSize = floor(size * 1.65) //26
        case UIContentSizeCategoryAccessibilityExtraLarge:
            adjustedSize = floor(size * 1.75) //28
        case UIContentSizeCategoryAccessibilityExtraExtraLarge:
            adjustedSize = floor(size * 1.9) //30
        case UIContentSizeCategoryAccessibilityExtraExtraExtraLarge:
            adjustedSize = floor(size * 2) //32
        default:
            adjustedSize = 16
        }
        
        return adjustedSize
    }
    
    public static func fromUIFont(font:UIFont) -> Font? {
        let descriptor = font.fontDescriptor()
        
        guard let name = descriptor.fontAttributes()[UIFontDescriptorNameAttribute] as? NSString
            else { return nil }
        guard let size = descriptor.fontAttributes()[UIFontDescriptorSizeAttribute] as? NSNumber
            else { return nil }
        
        return Font.init(fontName: String(name), size: CGFloat(size))
    }
    
    public func generate(sizeClass:String = UIApplication.sharedApplication().preferredContentSizeCategory, resizer:FontScaler? = nil) -> UIFont? {
        let adjustedSize = resizer != nil ? resizer!(sizeClass: sizeClass) : dynamicSize(sizeClass)
        return UIFont(name: fontName, size: adjustedSize)
    }
}

public func ==(lhs:Font, rhs:Font) -> Bool {
    return lhs.fontName == rhs.fontName
        && lhs.size == rhs.size
        && lhs.weight == rhs.weight
        && lhs.style == rhs.style
}

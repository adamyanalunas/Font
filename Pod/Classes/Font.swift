//
//  Font.swift
//  Pods
//
//  Created by Adam Yanalunas on 10/2/15.
//
//

import Foundation

public enum FontStyle:String {
    case none, italic
}

public enum FontWeight:String {
    case ultralight, thin, light, regular, medium, semibold, bold, heavy, black
    
    public init(type:String) {
        self = FontWeight(rawValue: type)!
    }
}

public struct Font: Equatable {
    public typealias FontScaler = (_ sizeClass:UIContentSizeCategory) -> CGFloat
    public let fontName:String
    public let size:CGFloat
    public let weight:FontWeight
    public let style:FontStyle
    
    public init(fontName:String, size:CGFloat, weight:FontWeight = .medium, style:FontStyle = .none) {
        self.fontName = fontName
        self.size = size
        self.weight = weight
        self.style = style
    }
    
    fileprivate func dynamicSize(_ sizeClass:UIContentSizeCategory) -> CGFloat {
        let adjustedSize:CGFloat
        
        switch sizeClass {
        case UIContentSizeCategory.extraSmall:
            adjustedSize = floor(size / 1.6) //10
        case UIContentSizeCategory.small:
            adjustedSize = floor(size / 1.4) //11
        case UIContentSizeCategory.medium:
            adjustedSize = floor(size / 1.2) //13
        case UIContentSizeCategory.large:
            adjustedSize = size //16
        case UIContentSizeCategory.extraLarge:
            adjustedSize = floor(size * 1.15) //18
        case UIContentSizeCategory.extraExtraLarge:
            adjustedSize = floor(size * 1.25) //20
        case UIContentSizeCategory.extraExtraExtraLarge:
            adjustedSize = floor(size * 1.4) //22
        case UIContentSizeCategory.accessibilityMedium:
            adjustedSize = floor(size * 1.5) //24
        case UIContentSizeCategory.accessibilityLarge:
            adjustedSize = floor(size * 1.65) //26
        case UIContentSizeCategory.accessibilityExtraLarge:
            adjustedSize = floor(size * 1.75) //28
        case UIContentSizeCategory.accessibilityExtraExtraLarge:
            adjustedSize = floor(size * 1.9) //30
        case UIContentSizeCategory.accessibilityExtraExtraExtraLarge:
            adjustedSize = floor(size * 2) //32
        default:
            adjustedSize = 16
        }
        
        return adjustedSize
    }
    
    public func generate(_ sizeClass:UIContentSizeCategory = UIApplication.shared.preferredContentSizeCategory, resizer:FontScaler? = nil) -> UIFont? {
        let adjustedSize = resizer != nil ? resizer!(sizeClass) : dynamicSize(sizeClass)
        return UIFont(name: fontName, size: adjustedSize)
    }
}

public func ==(lhs:Font, rhs:Font) -> Bool {
    return lhs.fontName == rhs.fontName
        && lhs.size == rhs.size
        && lhs.weight == rhs.weight
        && lhs.style == rhs.style
}

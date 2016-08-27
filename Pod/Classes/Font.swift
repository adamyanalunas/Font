//
//  Font.swift
//  Pods
//
//  Created by Adam Yanalunas on 10/2/15.
//
//

import Foundation
import UIKit

public enum FontStyle: String {
    case None, Italic
}

public enum FontWeight: String {
    case ultralight, thin, light, regular, medium, semibold, bold, heavy, black
    
    public init(type: String) {
        self = FontWeight(rawValue: type)!
    }
}

public struct Font: Equatable {
    public typealias FontScaler = (_ sizeClass: String) -> CGFloat
    public let fontName:String
    public let size: CGFloat
    public let weight: FontWeight
    public let style: FontStyle
    
    public init(fontName: String, size: CGFloat, weight: FontWeight = .medium, style: FontStyle = .None) {
        self.fontName = fontName
        self.size = size
        self.weight = weight
        self.style = style
    }
    
    private func dynamicSize(_ sizeClass: UIContentSizeCategory) -> CGFloat {
        let adjustedSize: CGFloat
        
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
    
    public static func fromUIFont(font: UIFont) -> Font {
        let descriptor = font.fontDescriptor
        let name = descriptor.fontAttributes[UIFontDescriptorNameAttribute]
        let size = descriptor.fontAttributes[UIFontDescriptorSizeAttribute]
        
        return Font.init(fontName: String(describing: name), size: CGFloat(size as! NSNumber))
    }
    
    public func generate(sizeClass: UIContentSizeCategory = UIApplication.shared.preferredContentSizeCategory, resizer: FontScaler? = nil) -> UIFont? {
        let adjustedSize = (resizer != nil) ? resizer!(sizeClass.rawValue) : dynamicSize(sizeClass)
        return UIFont(name: fontName, size: adjustedSize)
    }
}

public func ==(lhs: Font, rhs: Font) -> Bool {
    return lhs.fontName == rhs.fontName
        && lhs.size == rhs.size
        && lhs.weight == rhs.weight
        && lhs.style == rhs.style
}

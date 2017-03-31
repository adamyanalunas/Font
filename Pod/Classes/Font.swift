//
//  Font.swift
//  Pods
//
//  Created by Adam Yanalunas on 10/2/15.
//
//

import Foundation

// TODO: Remove in preference of FontWidth
public enum FontStyle:String {
    case regular, condensed, expanded
}

public enum FontWeight:String {
    case ultralight, thin, light, regular, medium, semibold, bold, heavy, black
    
    public static let lightWeights:[FontWeight] = [.ultralight, .thin, .light]
    public static let boldWeights:[FontWeight] = [.semibold, .bold, .heavy, .black]
    
    public func value() -> Int {
        switch self {
        case .ultralight:
            return 100
        case .thin:
            return 200
        case .light:
            return 300
        case .regular:
            return 400
        case .medium:
            return 500
        case .semibold:
            return 600
        case .bold:
            return 700
        case .heavy:
            return 800
        case .black:
            return 900
        }
    }
    
    // TODO: Reference https://github.com/Microsoft/WinObjC/pull/1039/files#diff-4bd7a9c14e083a674288c2255f70e8f0R80
    public init(fromCoreTextWeightTrait weight:Float) {
        if weight > 0.8 {
            self = .black
        } else if weight >= 0.4 {
            self = .heavy
        } else if weight >= 0.3 {
            self = .semibold
        } else if weight >= 0.2 {
            self = .medium
        } else if weight >= 0 {
            self = .regular
        } else if weight >= -0.4 {
            self = .light
        } else if weight >= -0.6 {
            self = .thin
        } else {
            self = .ultralight
        }
    }
}

public enum FontWidth:String {
    case undefined
    case ultraCondensed
    case extraCondensed
    case condensed
    case semiCondensed
    case regular
    case semiExpanded
    case expanded
    case extraExpanded
    case ultraExpanded
    
    public static let condensedWidths:[FontWidth] = [.ultraCondensed, .extraCondensed, .condensed, .semiCondensed]
    public static let expandedWidths:[FontWidth] = [.semiExpanded, .expanded, .extraExpanded, .ultraExpanded]
    
    public init(fromCoreTextWidthTrait number:Float) {
        if number == 1 {
            self = .ultraExpanded
        } else if number >= 0.7 {
            self = .extraExpanded
        } else if number >= 0.4 {
            self = .expanded
        } else if number >= 0.1 {
            self = .semiExpanded
        } else if number == 0 {
            self = .regular
        } else if number >= -0.1 {
            self = .semiCondensed
        } else if number >= -0.4 {
            self = .condensed
        } else if number >= -0.7 {
            self = .extraCondensed
        } else if number == -1 {
            self = .ultraCondensed
        } else {
            self = .undefined
        }
    }
}


public struct Font: Equatable {
    public typealias FontScaler = (_ sizeClass:UIContentSizeCategory) -> CGFloat
    public let fontName:String
    public let size:CGFloat
    public let weight:FontWeight
    public let isItalic:Bool
    public let style:FontStyle
    
    public init(fontName:String, size:CGFloat, weight:FontWeight = .medium, isItalic:Bool = false, style:FontStyle = .regular) {
        self.fontName = fontName
        self.size = size
        self.weight = weight
        self.isItalic = isItalic
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
    
    public static func fromUIFont(_ font:UIFont) -> Font {
        let descriptor = font.fontDescriptor
        let name = descriptor.fontAttributes[UIFontDescriptorNameAttribute] as! String
        let size = descriptor.fontAttributes[UIFontDescriptorSizeAttribute] as! CGFloat
        
        return Font.init(fontName: name, size: size)
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
        && lhs.isItalic == rhs.isItalic
        && lhs.style == rhs.style
}

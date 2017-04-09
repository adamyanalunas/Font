//
//  FontAutoloader.swift
//  Pods
//
//  Created by Adam Yanalunas on 3/3/17.
//
//

import Foundation
import os

// TODO: Translate FontDescriptor to Font instance
// TODO: New class to load font from URL?
// TODO: Switch UI to allow adding multiple font types for preview in a table-like collection, tap to edit details, swipe to delete?
// TODO: Switch to using UIFont for as much as possible, remove FontWeight, FontStyle, FontWidth, etc. in lieu of using UIFont and UIFontDescriptor for all needed info? Will UIKit be enough without CoreText?
// TODO: Test for memory leaks as this seems leaky
final public class FontAutoloader {
    // TODO: This is dumb. Change to compiler flag?
    var debug = false
    
    private(set) public var families:[FontFamily] = []
    var validExtensions:[FontType] = [.TrueType, .OpenType]
    
    // NOTE: Required to let users FontAutoloader()
    public init() {}
    
    public func load(fromBundle bundle:Bundle = Bundle.main) {
        let fontNames = loadFonts(fromPath: bundle.bundlePath)
        parse(fontNames: fontNames)
    }
    
    public func parse(fontNames names:[String]) {
        let descriptors:[FontDescriptor] = names.flatMap {
            guard let font = CGFont.init($0 as CFString) else { return nil }
            return FontDescriptor(from: font)
        }
        add(fonts: descriptors)
    }
    
    public func add(fonts:[FontDescriptor]) {
        for font in fonts {
            // TODO: Getting into n^2 territory here. Refactor.
            if let offset = families.index(where: { $0.name == font.family }) {
                families[offset].add(font: font)
            } else {
                families.append(FontFamily(named: font.family, fonts: [font]))
            }
        }
    }
}

public struct FontFamily {
    public let name:String
    private(set) public var fonts:[FontDescriptor] = []
    
    public var weights:[FontWeight] {
        // NOTE: Always sorted by weight ascending. Unnecessary?
        return Array(Set(fonts.flatMap { $0.weight })).sorted(by: { $0.value() < $1.value() })
    }
    
    public var widths:[FontWidth] {
        return Array(Set(fonts.flatMap { $0.width }))
    }
    
    init(named name:String, fonts:[FontDescriptor]) {
        self.name = name
        self.fonts = fonts
    }
    
    mutating func add(font:FontDescriptor) {
        assert(font.family == name, "Font should belong to \(name), not \(font.family)")
        fonts.append(font)
    }
    
    public func font(size:CGFloat, weight:FontWeight = .regular, italic:Bool = false, width:FontWidth = .regular) -> UIFont? {
        for font in fonts {
            if font.weight == weight, font.isItalic == italic, font.width == width {
                return UIFont(name: font.postScriptName, size: size)
            }
        }
        
        return nil
    }
}

public struct FontDescriptor {
    public let family:String
    public let name:String
    public let postScriptName:String
    public let weight:FontWeight
    public let isBold:Bool
    public let width:FontWidth
    public let slant:Float
    public let isItalic:Bool
    public let monospace:Bool
    public let url:URL?
    
    // NOTE: UIFont would have been nicer but it's missing things like weight and slant data
    init?(from font:CGFont) {
        guard let psName = font.postScriptName else { return nil }
        
        let descriptor = CTFontDescriptorCreateWithNameAndSize(psName, 0)
        let CTFontRef = CTFontCreateWithName(psName, 0, nil)
        let symbolicTraits = CTFontGetSymbolicTraits(CTFontRef)
        
        postScriptName = psName as String
        monospace = symbolicTraits.contains(.traitMonoSpace)
        
        if let urlAttribute = CTFontDescriptorCopyAttribute(descriptor, kCTFontURLAttribute) as? URL {
            url = urlAttribute
        } else {
            url = nil
        }
        
        if let familyAttribute = CTFontDescriptorCopyAttribute(descriptor, kCTFontFamilyNameAttribute) as? String {
            family = familyAttribute
        } else {
            return nil
        }
        
        if let displayNameAttribute = CTFontDescriptorCopyAttribute(descriptor, kCTFontDisplayNameAttribute) as? String {
            name = displayNameAttribute
        } else {
            return nil
        }
        
        if let traits = CTFontDescriptorCopyAttribute(descriptor, kCTFontTraitsAttribute) {
            if let weightVal = traits[kCTFontWeightTrait] as? Float {
                weight = FontWeight(fromCoreTextWeightTrait: weightVal)
                isBold = FontWeight.boldWeights.contains(weight)
            } else {
                return nil
            }
            
            if let widthVal = traits[kCTFontWidthTrait] as? Float {
                width = FontWidth(fromCoreTextWidthTrait: widthVal)
            } else {
                return nil
            }
            
            if let slantVal = traits[kCTFontSlantTrait] as? Float {
                slant = slantVal
                isItalic = slantVal != 0
            } else {
                slant = 0
                isItalic = false
            }
        } else {
            return nil
        }
    }
}

private extension FontAutoloader {
    func loadFonts(fromPath path:String, fileManager:FileManager = FileManager.default) -> [String] {
        do {
            let contents = try fileManager.contentsOfDirectory(atPath: path) as [String]
            return fontFileURLs(fromPath: path, withContents: contents).flatMap {
                return loadFont(fromFile: $0)
            }
        } catch let error as NSError {
            printDebugMessage(message: "There was an error loading fonts from the bundle. \nPath: \(path).\nError: \(error)")
        }
        
        return []
    }
    
    func loadFont(fromFile path: URL) -> String? {
        
        var fontError: Unmanaged<CFError>?
        
        // NOTE: All of this just to get the true PostScript name
        if let fontData = try? Data(contentsOf: path) as CFData,
            let dataProvider = CGDataProvider(data: fontData) {
            let fontRef = CGFont(dataProvider)
        
            // NOTE: Going to ignore the error here as data-backed registration *should* work and calling this for already-registered fonts fails, lowering the usefulness of this library. This is both a hack and a gamble. Congrats, me!
            let _ = CTFontManagerRegisterFontsForURL(path as CFURL, .process, &fontError)
            return fontRef.postScriptName as String?
        } else {
            printDebugMessage(message: "Failed to load font from \(path.absoluteString)")
        }
        
        return nil
    }
    
    func fontFileURLs(fromPath path: String, withContents contents: [String]) -> [URL] {
        return contents.filter { FontType.isValid(type: $0) }.map {
            let cheater = URL(fileURLWithPath: $0)
            return URL(fileURLWithPath: path).appendingPathComponent(cheater.deletingPathExtension().lastPathComponent).appendingPathExtension(cheater.pathExtension)
        }
    }
    
    private func printDebugMessage(message: String) {
        if debug == true {
            if #available(iOS 10.0, *) {
                os_log("%@: %@", #file, message)
            } else {
                print("\(#file): \(message)")
            }
        }
    }
}

public enum FontType:String {
    case TrueType = "ttf"
    case OpenType = "otf"
    
    public static func isValid(type:String) -> Bool {
        return FontType(rawValue: (type as NSString).pathExtension) != nil
    }
}

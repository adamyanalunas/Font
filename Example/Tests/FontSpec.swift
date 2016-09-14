//
//  FontSpec.swift
//  Font
//
//  Created by Adam Yanalunas on 10/9/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import Font
import Font_Example
import UIKit

extension UIFont {
    func size() -> NSNumber {
        return self.fontDescriptor.fontAttributes[UIFontDescriptorSizeAttribute] as! NSNumber
    }
}

class FontSpec: QuickSpec {
    override func spec() {
        var testFont:Font!
        
        beforeEach {
            testFont = Font.SourceSansPro()
        }
        
        describe("generate") {
            it("creates a UIFont instance") {
                let font = testFont.generate()
                expect(font?.isKind(of: UIFont.self)) == true
            }
            
            it("is the default size") {
                let font = testFont.generate()
                expect(font?.size()) == 16
            }
        }
        
        describe("dynamicSize") {
            it("resizes the font to extra small") {
                let font = testFont.generate(UIContentSizeCategory.extraSmall)
                expect(font?.size()) == 10
            }
            
            it("resizes the font to small") {
                let font = testFont.generate(UIContentSizeCategory.small)
                expect(font?.size()) == 11
            }
            
            it("resizes the font to medium") {
                let font = testFont.generate(UIContentSizeCategory.medium)
                expect(font?.size()) == 13
            }
            
            it("resizes the font to large") {
                let font = testFont.generate(UIContentSizeCategory.large)
                expect(font?.size()) == 16
            }
            
            it("resizes the font to extra large") {
                let font = testFont.generate(UIContentSizeCategory.extraLarge)
                expect(font?.size()) == 18
            }
            
            it("resizes the font to extra extra large") {
                let font = testFont.generate(UIContentSizeCategory.extraExtraLarge)
                expect(font?.size()) == 20
            }
            
            it("resizes the font to extra extra extra large") {
                let font = testFont.generate(UIContentSizeCategory.extraExtraExtraLarge)
                expect(font?.size()) == 22
            }
            
            it("resizes the font to accessibility medium") {
                let font = testFont.generate(UIContentSizeCategory.accessibilityMedium)
                expect(font?.size()) == 24
            }
            
            it("resizes the font to accessibility large") {
                let font = testFont.generate(UIContentSizeCategory.accessibilityLarge)
                expect(font?.size()) == 26
            }
            
            it("resizes the font to accessibility extra large") {
                let font = testFont.generate(UIContentSizeCategory.accessibilityExtraLarge)
                expect(font?.size()) == 28
            }
            
            it("resizes the font to accessibility extra extra large") {
                let font = testFont.generate(UIContentSizeCategory.accessibilityExtraExtraLarge)
                expect(font?.size()) == 30
            }
            
            it("resizes the font to accessibility extra extra extra large") {
                let font = testFont.generate(UIContentSizeCategory.accessibilityExtraExtraExtraLarge)
                expect(font?.size()) == 32
            }
        }
        
        describe("equality") {
            it("matches similar instances") {
                let similarFont = Font.SourceSansPro()
                expect(testFont) == similarFont
            }
            
            it("will not match dissimilar sizes") {
                let dissimilarSize = Font.SourceSansPro(size: 123)
                expect(testFont) != dissimilarSize
            }
            
            it("will not match dissimilar weights") {
                let dissimilarWeight = Font.SourceSansPro(weight: .Black)
                expect(testFont) != dissimilarWeight
            }
            
            it("will not match dissimilar syles") {
                let dissimilarStyle = Font.SourceSansPro(style: .Italic)
                expect(testFont) != dissimilarStyle
            }
        }
    }
}

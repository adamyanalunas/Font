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
        return self.fontDescriptor().fontAttributes()[UIFontDescriptorSizeAttribute] as! NSNumber
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
                expect(font?.isKindOfClass(UIFont)) == true
            }
            
            it("is the default size") {
                let font = testFont.generate()
                expect(font?.size()) == 16
            }
        }
        
        describe("dynamicSize") {
            it("resizes the font to extra small") {
                let font = testFont.generate(UIContentSizeCategoryExtraSmall)
                expect(font?.size()) == 10
            }
            
            it("resizes the font to small") {
                let font = testFont.generate(UIContentSizeCategorySmall)
                expect(font?.size()) == 11
            }
            
            it("resizes the font to medium") {
                let font = testFont.generate(UIContentSizeCategoryMedium)
                expect(font?.size()) == 13
            }
            
            it("resizes the font to large") {
                let font = testFont.generate(UIContentSizeCategoryLarge)
                expect(font?.size()) == 16
            }
            
            it("resizes the font to extra large") {
                let font = testFont.generate(UIContentSizeCategoryExtraLarge)
                expect(font?.size()) == 18
            }
            
            it("resizes the font to extra extra large") {
                let font = testFont.generate(UIContentSizeCategoryExtraExtraLarge)
                expect(font?.size()) == 20
            }
            
            it("resizes the font to extra extra extra large") {
                let font = testFont.generate(UIContentSizeCategoryExtraExtraExtraLarge)
                expect(font?.size()) == 22
            }
            
            it("resizes the font to accessibility medium") {
                let font = testFont.generate(UIContentSizeCategoryAccessibilityMedium)
                expect(font?.size()) == 24
            }
            
            it("resizes the font to accessibility large") {
                let font = testFont.generate(UIContentSizeCategoryAccessibilityLarge)
                expect(font?.size()) == 26
            }
            
            it("resizes the font to accessibility extra large") {
                let font = testFont.generate(UIContentSizeCategoryAccessibilityExtraLarge)
                expect(font?.size()) == 28
            }
            
            it("resizes the font to accessibility extra extra large") {
                let font = testFont.generate(UIContentSizeCategoryAccessibilityExtraExtraLarge)
                expect(font?.size()) == 30
            }
            
            it("resizes the font to accessibility extra extra extra large") {
                let font = testFont.generate(UIContentSizeCategoryAccessibilityExtraExtraExtraLarge)
                expect(font?.size()) == 32
            }
        }
        
        describe("equality") {
            it("matches similar instances") {
                let similarFont = Font.SourceSansPro()
                expect(testFont == similarFont) == true
            }
            
            it("will not match dissimilar instances") {
                let dissimilarFont = Font.SourceSansPro(123)
                expect(testFont == dissimilarFont) == false
            }
        }
    }
}

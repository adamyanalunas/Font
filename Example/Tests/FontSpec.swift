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
        }
    }
}

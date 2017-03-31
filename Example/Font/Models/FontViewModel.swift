//
//  FontViewModel.swift
//  Font
//
//  Created by Adam Yanalunas on 10/3/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import Font
import Foundation
import UIKit

struct FontViewModel {
    let family:FontFamily
    let size:CGFloat
    let weight:FontWeight
    let isItalic:Bool
    let width:FontWidth

    func generateFont() -> UIFont? {
        return family.font(
            size: size,
            weight: weight,
            italic: isItalic,
            width: width
        )
    }
}

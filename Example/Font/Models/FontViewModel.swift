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
    let name:String
    let size:CGFloat
    let style:FontStyle
    let weight:FontWeight
    
    init(name:String, size:CGFloat, style:FontStyle, weight:FontWeight) {
        self.name = name
        self.size = size
        self.style = style
        self.weight = weight
    }
}
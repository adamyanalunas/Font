//
//  ExampleCollectionCell.swift
//  Font
//
//  Created by Adam Yanalunas on 3/31/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class ExampleCollectionCell: UICollectionViewCell {
    @IBOutlet weak var label:UILabel!
    
    static let identifier = "ExampleCollectionCell"
    
    var model:FontViewModel? = nil
}

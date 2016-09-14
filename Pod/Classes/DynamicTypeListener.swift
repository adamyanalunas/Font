//
//  DynamicTypeListener.swift
//  Pods
//
//  Created by Adam Yanalunas on 10/9/15.
//
//

import Foundation
import UIKit

public protocol DynamicTypeListener {
    func listenForDynamicTypeChanges()
    func ignoreDynamicTypeChanges()
    func respondToDynamicTypeChanges(_ notification:Notification)
}

public extension DynamicTypeListener where Self:UIViewController {
    func listenForDynamicTypeChanges() {
        NotificationCenter.default
            .addObserver(self, selector: Selector(("respondToDynamicTypeChanges")), name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
    }
    
    func ignoreDynamicTypeChanges() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
    }
}

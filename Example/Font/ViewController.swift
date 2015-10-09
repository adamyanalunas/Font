//
//  ViewController.swift
//  Font
//
//  Created by Adam Yanalunas on 10/02/2015.
//  Copyright (c) 2015 Adam Yanalunas. All rights reserved.
//

import Font
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var example:UILabel!
    var model:FontViewModel!

    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model = FontViewModel(name: "Source Sans Pro", size: 24, style: .Italic, weight: .Semibold)
        updateFont(model)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        let vc = segue.destinationViewController as! OptionsController
        vc.model = model
    }
    
    // MARK: - Helpers
    
    func updateFont(model:FontViewModel) {
        // Create an instance of your custom font and generate it into a UIFont instance
        let font = Font.SourceSansPro(model.size, weight: model.weight, style: model.style).generate()
        example.font = font
    }
}

extension ViewController: DynamicTypeListener {
    // Subscribe to UIContentSizeCategoryDidChangeNotification notifications
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        listenForDynamicTypeChanges()
        updateFont(model)
    }
    
    // Unsubscribe from UIContentSizeCategoryDidChangeNotification notifications
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        ignoreDynamicTypeChanges()
    }
    
    // Do something when UIContentSizeCategoryDidChangeNotification notifications come in
    func respondToDynamicTypeChanges(notification:NSNotification) {
        updateFont(model)
    }
}

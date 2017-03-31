//
//  ViewController.swift
//  Font
//
//  Created by Adam Yanalunas on 10/02/2015.
//  Copyright (c) 2015 Adam Yanalunas. All rights reserved.
//

import Font
import UIKit

protocol FontUpdateable: class {
    func didUpdateFont(using model: FontViewModel)
}

class ViewController: UIViewController {
    
    @IBOutlet weak var example:UILabel!
    
    let fonts = FontAutoloader()
    var model:FontViewModel!

    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fonts.load()
        guard let firstFamily = fonts.families.first else { return }
        
        model = FontViewModel(family: firstFamily, size: 24, weight: .regular, isItalic: false, width: .regular)
        updateFont()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let vc = segue.destination as? OptionsController {
            vc.model = model
            vc.delegate = self
        }
    }
    
    // MARK: - Helpers
    
    func updateFont() {
        // Create an instance of your custom font and generate it into a UIFont instance
//        let font = Font.SourceSansPro(size: model.size, weight: model.weight, style: model.style).generate()
//        example.font = font
        example.font = model.family.font(size: model.size, weight: model.weight, italic: model.isItalic, width: model.width)
    }
}

extension ViewController: FontUpdateable {
    func didUpdateFont(using model: FontViewModel) {
        self.model = model
        updateFont()
    }
}

extension ViewController: DynamicTypeListener {
    // Subscribe to UIContentSizeCategoryDidChangeNotification notifications
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        listenForDynamicTypeChanges()
    }
    
    // Unsubscribe from UIContentSizeCategoryDidChangeNotification notifications
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        ignoreDynamicTypeChanges()
    }
    
    // Do something when UIContentSizeCategoryDidChangeNotification notifications come in
    func respondToDynamicTypeChanges(_ notification:Notification) {
        // TODO: Find better way to update this
        updateFont()
    }
}

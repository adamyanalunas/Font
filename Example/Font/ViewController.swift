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
    var model:FontViewModel?

    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let _ = Font.SourceSansPro()
//        let _ = Font.SourceSansPro(weight: .Semibold)
//        let _ = Font.SourceSansPro(style: .Italic)
        
        model = FontViewModel(name: "Source Sans Pro", size: 24, style: .Italic, weight: .Semibold)
        updateFont(model!)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateFont(model!)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        let vc = segue.destinationViewController as! OptionsController
        vc.model = model!
    }
    
    // MARK: - Helpers
    
    func updateFont(model:FontViewModel) {
        let font = Font.SourceSansPro(model.size, weight: model.weight, style: model.style).generate()
        example.font = font
    }
}


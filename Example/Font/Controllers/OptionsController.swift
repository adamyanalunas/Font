//
//  OptionsController.swift
//  Font
//
//  Created by Adam Yanalunas on 10/2/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import Font
import Foundation
import UIKit

class OptionsController: UITableViewController {
    
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var italicSwitch:UISwitch!
    @IBOutlet weak var sizeField:UITextField!
    @IBOutlet weak var weightLabel:UILabel!
    var weightOptions:[String]!
    @IBOutlet weak var weightSelector:UIPickerView!
    
    var model:FontViewModel!
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weightOptions = [FontWeight.Ultralight, .Thin, .Light, .Regular, .Medium, .Semibold, .Heavy, .Black].map {
            $0.rawValue
        }
        weightSelector.reloadAllComponents()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        sizeField.text = String(model.size)
        italicSwitch.on = model.style == .Italic
        weightLabel.text = model.weight.rawValue
        nameLabel.text = model.name
        
        let selectedWeight = weightOptions.indexOf(model.weight.rawValue)
        weightSelector.selectRow(selectedWeight!, inComponent: 0, animated: false)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        self.view.endEditing(true)
        resetModel()
        
        let vc = segue.destinationViewController as! ViewController
        vc.model = generateModel()
    }
    
    // MARK: - Model consumption
    
    func generateModel() -> FontViewModel {
        guard let size = NSNumberFormatter().numberFromString(sizeField.text!)
            else { return model }
        
        return FontViewModel(
            name: nameLabel.text!,
            size: CGFloat(size),
            style: (italicSwitch.on ? .Italic : .None),
            weight: FontWeight(type: weightLabel.text!)
        )
    }
    
    func resetModel() {
        model = generateModel()
    }
    
    // MARK: - Actions
    
    @IBAction func switchStyle() {
        resetModel()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard indexPath.section == 0 else { return }
        
        switch indexPath.row {
        case 0:
            sizeField.becomeFirstResponder()
        case 1:
            italicSwitch.on = !italicSwitch.on
        default:
            view.endEditing(true)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension OptionsController: UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return weightOptions.count
    }
}

extension OptionsController: UIPickerViewDelegate {
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return weightOptions[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        weightLabel.text = weightOptions[row]
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 36
    }
}

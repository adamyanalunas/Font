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

//extension Selector {
//    static let doneSelector = #selector(OptionsController.finishEdit(button:))
//}

class OptionsController: UITableViewController {
    
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var nameSelector:UIPickerView!
    @IBOutlet weak var italicSwitch:UISwitch!
    @IBOutlet weak var sizeField:UITextField!
    @IBOutlet weak var weightLabel:UILabel!
    @IBOutlet weak var weightSelector:UIPickerView!
    @IBOutlet weak var widthLabel:UILabel!
    
    var families:[FontFamily] = []
    var indexPath:IndexPath?
    var model:FontViewModel? //{
//        didSet {
//            guard let model = model else { return }
//            delegate?.didUpdateFont(using: model)
//        }
//    }
    
    var nameSelectorModel:Picker!
    var weightSelectorModel:Picker!
    
    weak var delegate:FontUpdateable?
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fonts = FontAutoloader()
        fonts.load()
        
        families = fonts.families.sorted(by: { $0.name < $1.name })
        let nameOptions = families.map({ $0.name })
        
        nameSelectorModel = Picker(options: nameOptions, rowHeight: 36, label: nameLabel)
        weightSelectorModel = Picker(options: [], rowHeight: 36, label: weightLabel)
        
        nameSelector.reloadAllComponents()
        weightSelector.reloadAllComponents()
        
//        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: .doneSelector)
//        navigationController?.navigationBar.topItem?.rightBarButtonItem = doneButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let model = model else { return }
        
        sizeField.text = String(describing: model.size)
        italicSwitch.isOn = model.isItalic
        
        guard let nameRow = nameSelectorModel.options.index(of: model.family.name) else { return }
        nameSelector.selectRow(nameRow, inComponent: 0, animated: false)
        
        if let row = families[nameRow].weights.index(of: model.weight) {
            weightSelector.selectRow(row, inComponent: 0, animated: false)
        }
        
        widthLabel.text = model.weight.rawValue
        updateValues(forFamily: model.family)
    }
    
    // MARK: - Model consumption
    
    func generateModel() -> FontViewModel? {
        guard let size = NumberFormatter().number(from: sizeField.text!)
            else { return nil }
        
        return FontViewModel(
            family: families[nameSelector.selectedRow(inComponent: 0)],
            size: CGFloat(size),
            weight: FontWeight(rawValue: weightLabel.text!) ?? .regular,
            isItalic: italicSwitch.isOn,
            width: FontWidth(rawValue: widthLabel.text!) ?? .regular
        )
    }
    
    func updateModel() {
        let italicsCount = families[nameSelector.selectedRow(inComponent: 0)].fonts.reduce(0) {
            $0 + ($1.isItalic ? 1 : 0)
        }
        if italicsCount == 0 {
            italicSwitch.isEnabled = false
            italicSwitch.isOn = false
        } else {
            italicSwitch.isEnabled = true
        }
        
        model = generateModel()
    }
    
    func updateValues(forFamily family: FontFamily) {
        nameSelectorModel.label.text = family.name
        weightSelectorModel.label.text = family.weights[weightSelector.selectedRow(inComponent: 0)].rawValue
        widthLabel.text = family.widths.first?.rawValue
        
    }
    
    func modelForSelector(_ picker:UIPickerView) -> Picker? {
        switch picker {
        case weightSelector:
            return weightSelectorModel
        case nameSelector:
            return nameSelectorModel
        default:
            return nil
        }
    }
    
    // MARK: - Actions
    
    @IBAction func switchStyle() {
        updateModel()
    }
    
    @IBAction func finishEdit(button:UIBarButtonItem) {
        guard let model = model else { return }
//        delegate?.didUpdateFont(using: model)
        delegate?.didUpdate(model: model, atIndexPath: indexPath)
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 0 else { return }
        
        switch indexPath.row {
        case 0:
            sizeField.becomeFirstResponder()
        case 1:
            if italicSwitch.isEnabled {
                italicSwitch.isOn = !italicSwitch.isOn
            }
        default:
            view.endEditing(true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension OptionsController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateModel()
    }
}

extension OptionsController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == nameSelector {
            guard let model = modelForSelector(pickerView) else { return 0 }
            return model.options.count
        } else {
            return families[nameSelector.selectedRow(inComponent: component)].weights.count
        }
    }
}

extension OptionsController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == nameSelector {
            return modelForSelector(pickerView)?.options[row]
        } else {
            let weights = families[nameSelector.selectedRow(inComponent: 0)].weights
            return weights[row].rawValue
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == nameSelector {
            weightSelector.reloadAllComponents()
        }
        
        let family = families[nameSelector.selectedRow(inComponent: component)]
        updateValues(forFamily: family)
        updateModel()
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        guard let model = modelForSelector(pickerView) else { return 0 }
        return model.rowHeight
    }
}

struct Picker {
    let options:[String]
    let rowHeight:CGFloat
    let label:UILabel
}

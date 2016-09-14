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
        
        weightOptions = [FontWeight.ultralight, .thin, .light, .regular, .medium, .semibold, .heavy, .black].map {
            $0.rawValue
        }
        weightSelector.reloadAllComponents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sizeField.text = String(describing: model.size)
        italicSwitch.isOn = model.style == .italic
        weightLabel.text = model.weight.rawValue
        nameLabel.text = model.name
        
        let selectedWeight = weightOptions.index(of: model.weight.rawValue)
        weightSelector.selectRow(selectedWeight!, inComponent: 0, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        self.view.endEditing(true)
        resetModel()
        
        let vc = segue.destination as! ViewController
        vc.model = generateModel()
    }
    
    // MARK: - Model consumption
    
    func generateModel() -> FontViewModel {
        guard let size = NumberFormatter().number(from: sizeField.text!)
            else { return model }
        
        return FontViewModel(
            name: nameLabel.text!,
            size: CGFloat(size),
            style: (italicSwitch.isOn ? .italic : .none),
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 0 else { return }
        
        switch indexPath.row {
        case 0:
            sizeField.becomeFirstResponder()
        case 1:
            italicSwitch.isOn = !italicSwitch.isOn
        default:
            view.endEditing(true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension OptionsController: UIPickerViewDataSource {
    func numberOfComponents(in: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return weightOptions.count
    }
}

extension OptionsController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return weightOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        weightLabel.text = weightOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 36
    }
}

//
//  PickerTextField.swift
//  OpenLibrary
//
//  Created by Remar Supnet on 5/22/19.
//  Copyright © 2019 Remar Supnet. All rights reserved.
//

import UIKit

class PickerTextField: UITextField, UIPickerViewDelegate, UIPickerViewDataSource {

    let pickerView = UIPickerView()
    var selectedIndex : Int = 0
    var options : [String]! {
        didSet {
            pickerView.reloadAllComponents()
        }
    }
    var pickerDelegate: PickerTextFieldDelegate?
    
    //the init called when using the XIB/storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        privateInit()
    }

    private func privateInit() {
        setUpPicker()
    }
    
    //adding a done button dismiss the pickerview
    private func setUpPicker() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePressed))
        doneButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        
        //creating flexible space
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.barStyle = UIBarStyle.blackTranslucent
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        
        self.inputView = pickerView
        self.inputAccessoryView = toolbar
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    @objc private func donePressed() {
        pickerDelegate?.pickerTextFieldItemSelected(row: selectedIndex, view: self)
        self.resignFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        //number of spinny columns things
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as? UILabel
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "Helvetica", size: 16)
            pickerLabel?.textAlignment = NSTextAlignment.center
        }
        pickerLabel?.text = options[row]
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if options.count > 0 {
            selectedIndex = row
            self.text = options[row]
        }
    }
    
    func getSelectedItemPosition() -> Int {
        return selectedIndex
    }
    
    func setSelection(_ index : Int) {
        selectedIndex = index
        self.text = options[index]
        pickerView.selectRow(index, inComponent: 0, animated: false)
    }
    
    func hasOptions() -> Bool {
        return options.count > 0
    }
}

protocol PickerTextFieldDelegate {
    func pickerTextFieldItemSelected(row: Int, view : PickerTextField)
}

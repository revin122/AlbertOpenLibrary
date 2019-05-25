//
//  DoneKeyboardTextField.swift
//  OpenLibrary
//
//  Created by Remar Supnet on 5/22/19.
//  Copyright © 2019 Remar Supnet. All rights reserved.
//

import UIKit

class DoneKeyboardTextField: UITextField, UITextFieldDelegate {
    
    var doneKeyboardDelegate : DoneKeyboardDelegate?
    
    //the init called when using the XIB/storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        privateInit()
    }
    
    private func privateInit() {
        self.returnKeyType = UIReturnKeyType.done
        self.delegate = self
        
        addDoneButton()
    }
    
    //uitextfielddelegate when the return key on keyboard is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        doneKeyboardDelegate?.donePressed(text: self.text ?? "")
        return false
    }
    
    //adding a done button if user wants another way to dismiss the keyboard
    private func addDoneButton() {
        //generating a done button above the keyboard
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePressed))
        doneButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        
        //creating flexible space
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.barStyle = UIBarStyle.blackTranslucent
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        
        self.inputAccessoryView = toolbar
    }
    
    //triggered when done button is clicked
    @objc private func donePressed() {
        self.resignFirstResponder()
        doneKeyboardDelegate?.donePressed(text: self.text ?? "")
    }

}

protocol DoneKeyboardDelegate {
    func donePressed(text : String)
}

//
//  UITextField+Extension.swift
//  Pig Dice Game
//
//  Created by Denis Goloborodko on 7.03.21.
//

import UIKit

extension UITextField {
    
    // Add toolbar with 'done' button for a numeric keyboard ()
    func addToolbarWithDoneButton() {
        let toolbarWithDoneButton = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        
        toolbarWithDoneButton.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        ]
        
        toolbarWithDoneButton.sizeToFit()
        
        self.inputAccessoryView = toolbarWithDoneButton
    }
    
    @objc func dismissKeyboard() {
        self.resignFirstResponder()
    }
}

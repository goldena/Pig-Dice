//
//  UIViewController+Extension.swift
//  Pig Dice Game
//
//  Created by Denis Goloborodko on 26.02.21.
//

import UIKit

extension UIViewController {
    
    func updateColorMode() {
        switch Options.colorMode {
        case .System:
            overrideUserInterfaceStyle = .unspecified
        case .Light:
            overrideUserInterfaceStyle = .light
        case .Dark:
            overrideUserInterfaceStyle = .dark
        }
    }
    
    func changeColorOfButton(_ button: UIButton, to color: UIColor) {
        button.backgroundColor = color
    }
    
    func changeColorOfButtons(_ buttons: [UIButton], to color: UIColor) {
        for button in buttons {
            changeColorOfButton(button, to: color)
        }
    }

    private func disableButton(_ button: UIButton) {
        DispatchQueue.main.async {
            button.isEnabled = false
        }
    }
    
    private func enableButton(_ button: UIButton) {
        button.isEnabled = true
    }
    
    func disableButtons(_ buttons: [UIButton]) {
        for button in buttons {
            disableButton(button)
        }
    }
    
    func enableButtons(_ buttons: [UIButton]) {
        for button in buttons {
            enableButton(button)
        }
    }
    
    // Displays info alert with Okay button
    func alertThenHandleEvent(color: UIColor, title: String, message: String, handler: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(
            title: LocalizedUI.alertActionTitle.translate(to: Options.language),
            style: .default,
            handler: { _ in handler() }
        ))
        
        #warning("Refactor")
        // Insert a new line, to add space between the title and the message
        
        // Customize font, design and color.
        alertController.view.tintColor = color

        let attributedTitle = NSMutableAttributedString(string: "\n" + title)
        let attributedMessage = NSMutableAttributedString(string: "\n" + message)
        
        if let titleFont = UIFont(name: "Lato-Regular", size: 18) {
            attributedTitle.addAttributes([NSAttributedString.Key.font: titleFont], range: NSMakeRange(0, title.utf8.count + 1))
        }
        
        if let messageFont = UIFont(name: "Lato-Regular", size: 18) {
            attributedMessage.addAttributes([NSAttributedString.Key.font: messageFont], range: NSMakeRange(0, message.utf8.count + 1))
        }

        alertController.setValue(attributedTitle, forKey: "attributedTitle")
        alertController.setValue(attributedMessage, forKey: "attributedMessage")
        
        present(alertController, animated: true, completion: nil)
    }
    
    func addTapOutsideTextFieldGestureRecognizer() {
        // Dismissed keyboard after tapping outside an edited field
        let tapOutsideTextField = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tapOutsideTextField.cancelsTouchesInView = false
        view.addGestureRecognizer(tapOutsideTextField)
    }
}

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
    
    func makeButtonRounded(_ button: UIButton, withRadius: CGFloat) {
        button.layer.cornerRadius = withRadius
    }
    
    func makeButtonsRounded(_ buttons: [UIButton], withRadius: CGFloat) {
        for button in buttons {
            makeButtonRounded(button, withRadius: withRadius)
        }
    }
    
    // Displays info alert with Okay button
    func alertThenHandleEvent(color: UIColor, title: String, message: String, handler: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        alertController.addAction(
            UIAlertAction(
                title: LocalizedUI.alertActionTitle.translate(to: Options.language),
                style: .default,
                handler: { _ in handler() }
            )
        )
        
        // Customize font, design and color.
        alertController.view.tintColor = color
        
        // Insert a new line, to add space between the title and the message
        let attributedTitle = makeNSMutableAttributedString(fromString: title, usingFont: Const.font)
        let attributedMessage = makeNSMutableAttributedString(fromString: "\n" + message, usingFont: Const.font)

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

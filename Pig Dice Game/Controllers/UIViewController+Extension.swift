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
    func alertThenHandleEvent(title: String, message: String, handler: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(
            title: LocalizedUI.alertActionTitle.translate(to: Options.language),
            style: .default,
            handler: { _ in handler() }
        ))
        
        present(alertController, animated: true, completion: nil)
    }

}

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
    
    func makeViewRounded(_ aView: UIView, withRadius: CGFloat) {
        aView.layer.cornerRadius = withRadius
    }
    
    func makeViewsRounded(_ views: [UIView], withRadius: CGFloat) {
        for aView in views {
            makeViewRounded(aView, withRadius: withRadius)
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
}

extension UIViewController {
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
        let attributedTitle = makeNSMutableAttributedString(fromString: "\n" + title, usingFont: Const.font)
        let attributedMessage = makeNSMutableAttributedString(fromString: "\n" + message, usingFont: Const.font)

        alertController.setValue(attributedTitle, forKey: "attributedTitle")
        alertController.setValue(attributedMessage, forKey: "attributedMessage")
        
        // Workaround a bug with UIViewAlertController to avoid an error with a negative Auto Layout constraint
        // To be removed after the bug is fixed
        if let constraints = alertController.view?.subviews.first?.constraints {
            for constraint in constraints {
                if constraint.constant < 0 {
                    constraint.constant.negate()
                }
            }
        }
        
        // If on iPad
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view
            
            popoverController.sourceRect = CGRect(
                x: self.view.bounds.midX,
                y: self.view.bounds.maxY - 150,
                width: 0,
                height: 0
            )
            
            popoverController.permittedArrowDirections = []
        }
        
        present(alertController, animated: true, completion: nil)
    }
}
    
extension UIViewController {
    func addTapOutsideTextFieldGestureRecognizer() {
        // Dismissed keyboard after tapping outside an edited field
        let tapOutsideTextField = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tapOutsideTextField.cancelsTouchesInView = false
        view.addGestureRecognizer(tapOutsideTextField)
    }
}

extension UIViewController {

    #warning("remove")
//override func viewWillLayoutSubviews() {
//    particleEmitter.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
//}
    
    func victoryConfetti() -> CAEmitterLayer {
        let particleEmitter = makeParticleEmitter(with: makeParticles(emojis: "🏆🎈🎉"))

        return particleEmitter
    }
        
    func defeatConfetti() -> CAEmitterLayer {
        let particleEmitter = makeParticleEmitter(with: makeParticles(emojis: "🐽🐷"))

        return particleEmitter
    }
    
    func stopConfetti(particleEmitter: CAEmitterLayer) {
        particleEmitter.birthRate = 0
    }
    
     func makeParticleEmitter(with particles: [CAEmitterCell]) -> CAEmitterLayer {
        let particleEmitter = CAEmitterLayer()
        
        particleEmitter.position = CGPoint(x: view.center.x, y: -100)
        particleEmitter.emitterShape = .line
        particleEmitter.emitterSize = CGSize(width: view.frame.size.width, height: 1)
        particleEmitter.emitterCells = particles

        return particleEmitter
    }
    
     func makeParticles(emojis: String) -> [CAEmitterCell] {
        var particles: [CAEmitterCell] = []
        
        for emoji in emojis {
            let cell = CAEmitterCell()
            
            cell.birthRate = 5
            cell.lifetime = 12
            cell.velocity = 120
            cell.velocityRange = 50
            cell.emissionLongitude = CGFloat.pi
            cell.emissionRange = CGFloat.pi / 4
            cell.spin = 1
            cell.spinRange = 1
            cell.scaleRange = 0.2
            cell.scaleSpeed = 0.1
            cell.contents = emoji.image().cgImage
            
            particles.append(cell)
        }
        
        return particles
    }
}

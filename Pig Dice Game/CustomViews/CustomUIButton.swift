//
//  customUIButton.swift
//  Pig Dice Game
//
//  Created by Denis Goloborodko on 26.12.20.
//

import UIKit

class CustomUIButton: UIButton {
    
    override open var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                setTitleColor(.lightGray, for: .highlighted)
            } else {
                setTitleColor(.white, for: .normal)
            }
            backgroundColor = self.backgroundColor?.withAlphaComponent(0.9)
        }
    }

    override open var isEnabled: Bool {
        didSet {
            if isEnabled {
                setTitleColor(.white, for: .normal)
                backgroundColor = Const.Player1Color
            } else {
                setTitleColor(.lightGray, for: .disabled)
                backgroundColor = .darkGray
            }
        }
    }
}

//
//  customUIButton.swift
//  Pig Dice Game
//
//  Created by Denis Goloborodko on 26.12.20.
//

import UIKit

class customUIButton: UIButton {
    override open var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                setTitleColor(.lightGray, for: .highlighted)
                backgroundColor = Const.ButtonColor.withAlphaComponent(0.9)
            } else {
                setTitleColor(.white, for: .normal)
                backgroundColor = Const.ButtonColor
            }
        }
    }
    
    override open var isEnabled: Bool {
        didSet {
            if isEnabled {
                setTitleColor(.white, for: .normal)
                backgroundColor = Const.ButtonColor
            } else {
                setTitleColor(.lightGray, for: .disabled)
                backgroundColor = .darkGray
            }
        }
    }
}

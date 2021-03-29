//
//  makeNSMutableAttributedString.swift
//  Pig Dice
//
//  Created by Denis Goloborodko on 9.03.21.
//

import UIKit

func makeNSMutableAttributedString(fromString string: String, usingFont font: String) -> NSMutableAttributedString {
    let attributedString = NSMutableAttributedString(string: string)
    
    if let font = UIFont(name: font, size: 22) {
        attributedString.addAttributes(
            [NSAttributedString.Key.font: font],
            range: NSMakeRange(0, string.utf16.count)
        )
    }
    
    return attributedString
}

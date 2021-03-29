//
//  String+Extension.swift
//  Pig Dice
//
//  Created by Denis Goloborodko on 27.03.21.
//

import UIKit

extension String.Element {
    
    func image(with font: UIFont = UIFont.systemFont(ofSize: 14.0)) -> UIImage {
        let nsString = NSString(string: String(self))
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        let size = nsString.size(withAttributes: attributes)

        return UIGraphicsImageRenderer(size: size).image { _ in
            nsString.draw(at: .zero, withAttributes: attributes)
        }
    }
}

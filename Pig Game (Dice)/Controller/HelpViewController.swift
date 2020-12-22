//
//  HelpViewController.swift
//  Pig Game (Dice)
//
//  Created by Denis Goloborodko on 10/26/20.
//

import UIKit

class HelpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Options.load()
        localiseUI()
    }

    private func localiseUI() {
        let language = Options.language
        
        BackButton.setTitle(LocalizedUI.backButton.translate(to: language), for: .normal)
        GameRulesTextView.text = LocalizedUI.gameRulesTextView.translate(to: language)
        GameRulesTextView.textAlignment = .natural
    }

    @IBOutlet private weak var GameRulesTextView: UITextView!
    
    @IBOutlet private weak var BackButton: UIButton!
    
    @IBAction private func BackButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

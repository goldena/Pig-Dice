//
//  HelpViewController.swift
//  Pig Dice Game
//
//  Created by Denis Goloborodko on 10/26/20.
//

import UIKit

class HelpViewController: UIViewController {

    // MARK: - Outlet(s)
    
    @IBOutlet private weak var GameRulesTextView: UITextView!
    
    @IBOutlet private weak var BackButton: UIButton!
    
    @IBAction private func BackButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Options.load()
        localizeUI()
    }

    // MARK: - Method(s)
    
    private func localizeUI() {
        let language = Options.language
        
        BackButton.setTitle(LocalizedUI.backButton.translate(to: language), for: .normal)
        GameRulesTextView.text = LocalizedUI.gameRulesTextView.translate(to: language)
        GameRulesTextView.textAlignment = .natural
    }
}

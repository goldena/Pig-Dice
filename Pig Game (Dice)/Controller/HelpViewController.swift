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

    func localiseUI() {
        BackButton.setTitle(LocalisedUI.backButton.translate(to: Options.language), for: .normal)
        
        GameRulesTextView.text = LocalisedUI.gameRulesTextView.translate(to: Options.language)
        GameRulesTextView.textAlignment = .natural
    }

    @IBOutlet weak var GameRulesTextView: UITextView!
    
    @IBOutlet weak var BackButton: UIButton!
    
    @IBAction func BackButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

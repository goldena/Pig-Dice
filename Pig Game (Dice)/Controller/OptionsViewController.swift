//
//  OptionsViewController.swift
//  Pig Game (Dice)
//
//  Created by Denis Goloborodko on 11/1/20.
//

import UIKit

class OptionsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Options.load()
        
        if Options.language == Language.En.rawValue {
            LanguageSelectionSegmentedControl.selectedSegmentIndex = 0
        } else if Options.language == Language.Ru.rawValue {
            LanguageSelectionSegmentedControl.selectedSegmentIndex = 1
        }
            
        Player1NameTextField.text = Options.player1Name
        Player2NameTextField.text = Options.player2Name
        ScoreLimitTextField.text = String(Options.scoreLimit)
    }
    
    @IBOutlet weak var LanguageSelectionSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var Player1NameTextField: UITextField!
    
    @IBOutlet weak var Player2NameTextField: UITextField!
    
    @IBOutlet weak var ScoreLimitTextField: UITextField!
    
    @IBAction func CancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func SaveButtonPressed(_ sender: UIButton) {
        
        if LanguageSelectionSegmentedControl.selectedSegmentIndex == 0 {
            Options.language = Language.En.rawValue
        } else {
            Options.language = Language.Ru.rawValue
        }
        
        Options.player1Name = Player1NameTextField.text ?? "Player1"
        Options.player2Name = Player2NameTextField.text ?? "Player2"
        
        if let scoreLimit = ScoreLimitTextField.text {
            Options.scoreLimit = Int(scoreLimit) ?? 100
        }
        
        self.dismiss(animated: true, completion: Options.save)
    }
}

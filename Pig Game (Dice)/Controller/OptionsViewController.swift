//
//  OptionsViewController.swift
//  Pig Game (Dice)
//
//  Created by Denis Goloborodko on 11/1/20.
//

import UIKit

// Options screen
class OptionsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Options.load()
        
        // Note: view controller knows too much about options - might need refactoring
        switch Options.language {
        case .En:
            LanguageSelectionSegmentedControl.selectedSegmentIndex = 0
        case .Ru:
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
    
    // Returt to the main screen without saving any changes to the Options
    @IBAction func CancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func SaveButtonPressed(_ sender: UIButton) {
        switch LanguageSelectionSegmentedControl.selectedSegmentIndex {
        case 0:
            Options.language = .En
        case 1:
            Options.language = .Ru
        default:
            print("Localization not found")
        }
        
        Options.player1Name = Player1NameTextField.text ?? "Player1"
        Options.player2Name = Player2NameTextField.text ?? "Player2"
        
        if let scoreLimit = ScoreLimitTextField.text {
            Options.scoreLimit = Int(scoreLimit) ?? 100
        }
        
        // Dismiss view controller and save options
        self.dismiss(animated: true, completion: Options.save)
    }
}

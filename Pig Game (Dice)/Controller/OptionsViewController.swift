//
//  OptionsViewController.swift
//  Pig Game (Dice)
//
//  Created by Denis Goloborodko on 11/1/20.
//

import UIKit

class OptionsViewController: UIViewController {
    
    var options = Options()
         
    override func viewDidLoad() {
        super.viewDidLoad()
        
        options.load()
        
        if options.localization == "En" {
            LanguageSelectionSegmentedControl.selectedSegmentIndex = 0
        } else if options.localization == "Ru" {
            LanguageSelectionSegmentedControl.selectedSegmentIndex = 1
        }
            
        Player1NameTextField.text = options.player1Name
        Player2NameTextField.text = options.player2Name
        ScoreLimitTextField.text = String(options.scoreLimit)
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
            options.localization = "En"
        } else {
            options.localization = "Ru"
        }
        
        options.player1Name = Player1NameTextField.text ?? "Player1"
        options.player2Name = Player2NameTextField.text ?? "Player2"
        
        if let scoreLimit = ScoreLimitTextField.text {
            options.scoreLimit = Int(scoreLimit) ?? 100
        }
        
        self.dismiss(animated: true, completion: options.save)
    }
}

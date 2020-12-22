//
//  OptionsViewController.swift
//  Pig Game (Dice)
//
//  Created by Denis Goloborodko on 11/1/20.
//

import UIKit

protocol ViewControllerDelegate: UIViewController {
    func viewWillDimiss()
}

// Options screen
class OptionsViewController: UIViewController, UITextFieldDelegate {
    
    weak var optionsViewControllerDelegate: ViewControllerDelegate?
    
    // Dismiss keyboard after pressing Return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Player1NameTextField.delegate = self
        Player2NameTextField.delegate = self
        ScoreLimitTextField.delegate = self
        
        // Dismissed keyboard after tapping outside an edited field
        let tapOutsideTextField = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tapOutsideTextField.cancelsTouchesInView = false
        view.addGestureRecognizer(tapOutsideTextField)
        
        Options.load()
        localiseUI()
        updateUI()
    }
    
    private func localiseUI() {
        let language = Options.language
                
        SoundEnabledTitle.text = LocalizedUI.soundEnabledSwitch.translate(to: language)
        Player1NameTitle.text = LocalizedUI.player1NameTitle.translate(to: language)
        Player2NameTitle.text = LocalizedUI.player2NameTitle.translate(to: language)
        Is2ndPlayerAITitile.text = LocalizedUI.is2ndPlayerAITitle.translate(to: language)
        ScoreLimitTitle.text = LocalizedUI.scoreLimitTitle.translate(to: language)
        With1or2DiceTitle.text = LocalizedUI.with1or2DiceTitle.translate(to: language)
        NoteLabel.text = LocalizedUI.noteLabel.translate(to: language)
        NoteLabel.textAlignment = .natural
        
        SaveButton.setTitle(LocalizedUI.saveButton.translate(to: language), for: .normal)
        CancelButton.setTitle(LocalizedUI.cancelButton.translate(to: language), for: .normal)
        With1or2DiceSegmentedControl.setTitle(LocalizedUI.with1DiceSegmentedControlLabel.translate(to: language), forSegmentAt: 0)
        With1or2DiceSegmentedControl.setTitle(LocalizedUI.with2DiceSegmentedControlLabel.translate(to: language), forSegmentAt: 1)
    }
    
    private func updateUI() {
        switch Options.language {
        case .En:
            LanguageSelectionSegmentedControl.selectedSegmentIndex = 0
        case .Ru:
            LanguageSelectionSegmentedControl.selectedSegmentIndex = 1
        }
           
        SoundEnabledSwitch.isOn = Options.isSoundEnabled
        
        switch Options.gameType {
        case .pigGame1Dice:
            With1or2DiceSegmentedControl.selectedSegmentIndex = 0
        case .pigGame2Dice:
            With1or2DiceSegmentedControl.selectedSegmentIndex = 1
        }
        
        Player1NameTextField.text = Options.player1Name
        Player2NameTextField.text = Options.player2Name
        Is2ndPlayerAISwitch.isOn = Options.is2ndPlayerAI
        ScoreLimitTextField.text = String(Options.scoreLimit)
    }
    
    @IBOutlet private weak var LanguageSelectionSegmentedControl: UISegmentedControl!
    
    @IBOutlet private weak var SoundEnabledTitle: UILabel!
    @IBOutlet private weak var SoundEnabledSwitch: UISwitch!
    
    @IBOutlet private weak var Player1NameTitle: UILabel!
    @IBOutlet private weak var Player1NameTextField: UITextField!
    
    @IBOutlet private weak var Player2NameTitle: UILabel!
    @IBOutlet private weak var Player2NameTextField: UITextField!
    
    @IBOutlet private weak var Is2ndPlayerAITitile: UILabel!
    @IBOutlet private weak var Is2ndPlayerAISwitch: UISwitch!
    
    @IBOutlet private weak var ScoreLimitTitle: UILabel!
    @IBOutlet private weak var ScoreLimitTextField: UITextField!
    
    @IBOutlet private weak var With1or2DiceTitle: UILabel!
    @IBOutlet private weak var With1or2DiceSegmentedControl: UISegmentedControl!
    
    @IBOutlet private weak var NoteLabel: UILabel!
    
    @IBOutlet private weak var CancelButton: UIButton!
    @IBOutlet private weak var SaveButton: UIButton!
    
    // Changes localisation on the fly
    @IBAction private func LanguageSelectionChanged(_ sender: UISegmentedControl) {
        switch LanguageSelectionSegmentedControl.selectedSegmentIndex {
        case 0:
            Options.language = .En
        case 1:
            Options.language = .Ru
        default:
            print("Missing language selected")
        }
        
        localiseUI()
    }
    
    // Returt to the main screen without saving any changes to the Options
    @IBAction private func CancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func SaveButtonPressed(_ sender: UIButton) {
        switch LanguageSelectionSegmentedControl.selectedSegmentIndex {
        case 0:
            Options.language = .En
        case 1:
            Options.language = .Ru
        default:
            Options.language = .En
            print("Localization not found")
        }
        
        Options.isSoundEnabled = SoundEnabledSwitch.isOn
        
        switch With1or2DiceSegmentedControl.selectedSegmentIndex {
        case 0:
            Options.gameType = .pigGame1Dice
        case 1:
            Options.gameType = .pigGame2Dice
        default:
            break
        }
        
        Options.player1Name = Player1NameTextField.text ?? Options.player1Name
        Options.player2Name = Player2NameTextField.text ?? Options.player2Name
        Options.is2ndPlayerAI = Is2ndPlayerAISwitch.isOn
        
        if let scoreLimitString = ScoreLimitTextField.text {
            if let scoreLimitInt = Int(scoreLimitString) {
                Options.scoreLimit = scoreLimitInt
            } else {
                print("Invalid score limit input")
            }
        }
        
        // Save options, call delegate to localise the Game screen and dismiss view controller
        Options.save()
        optionsViewControllerDelegate?.viewWillDimiss()
        
        self.dismiss(animated: true, completion: nil)
    }
}

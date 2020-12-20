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
    
    func localiseUI() {
        let language = Options.language
                
        SoundEnabledTitle.text = LocalisedUI.soundEnabledSwitch.translate(to: language)
        Player1NameTitle.text = LocalisedUI.player1NameTitle.translate(to: language)
        Player2NameTitle.text = LocalisedUI.player2NameTitle.translate(to: language)
        Is2ndPlayerAITitile.text = LocalisedUI.is2ndPlayerAITitle.translate(to: language)
        ScoreLimitTitle.text = LocalisedUI.scoreLimitTitle.translate(to: language)
        With1or2DiceTitle.text = LocalisedUI.with1or2DiceTitle.translate(to: language)
        NoteLabel.text = LocalisedUI.noteLabel.translate(to: language)
        NoteLabel.textAlignment = .natural
        
        SaveButton.setTitle(LocalisedUI.saveButton.translate(to: language), for: .normal)
        CancelButton.setTitle(LocalisedUI.cancelButton.translate(to: language), for: .normal)
        With1or2DiceSegmentedControl.setTitle(LocalisedUI.with1DiceSegmentedControlLabel.translate(to: language), forSegmentAt: 0)
        With1or2DiceSegmentedControl.setTitle(LocalisedUI.with2DiceSegmentedControlLabel.translate(to: language), forSegmentAt: 1)
    }
    
    func updateUI() {
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
    
    @IBOutlet weak var LanguageSelectionSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var SoundEnabledTitle: UILabel!
    @IBOutlet weak var SoundEnabledSwitch: UISwitch!
    
    @IBOutlet weak var Player1NameTitle: UILabel!
    @IBOutlet weak var Player1NameTextField: UITextField!
    
    @IBOutlet weak var Player2NameTitle: UILabel!
    @IBOutlet weak var Player2NameTextField: UITextField!
    
    @IBOutlet weak var Is2ndPlayerAITitile: UILabel!
    @IBOutlet weak var Is2ndPlayerAISwitch: UISwitch!
    
    @IBOutlet weak var ScoreLimitTitle: UILabel!
    @IBOutlet weak var ScoreLimitTextField: UITextField!
    
    @IBOutlet weak var With1or2DiceTitle: UILabel!
    @IBOutlet weak var With1or2DiceSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var NoteLabel: UILabel!
    
    @IBOutlet weak var CancelButton: UIButton!
    @IBOutlet weak var SaveButton: UIButton!
    
    // Changes localisation on the fly
    @IBAction func LanguageSelectionChanged(_ sender: UISegmentedControl) {
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

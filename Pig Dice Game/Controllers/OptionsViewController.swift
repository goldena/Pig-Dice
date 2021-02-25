//
//  OptionsViewController.swift
//  Pig Dice Game
//
//  Created by Denis Goloborodko on 11/1/20.
//

import UIKit

// Delegation Protocol for on-fly-updates of the Main Game Screen for some Options
protocol ViewControllerDelegate: UIViewController {
    func viewWillDimiss()
}

class OptionsViewController: UIViewController, UITextFieldDelegate {
    // MARK: - Property(s)
    var playerColor: UIColor? = nil
    
    weak var optionsViewControllerDelegate: ViewControllerDelegate?

    // MARK: - Outlet(s)
    
    @IBOutlet private weak var LanguageSelectionSegmentedControl: UISegmentedControl!
    
    @IBOutlet private weak var SoundEnabledTitle: UILabel!
    @IBOutlet private weak var SoundEnabledSwitch: UISwitch!
    
    @IBOutlet weak var VibrationEnabledTitle: UILabel!
    @IBOutlet weak var VibrationEnabledSwitch: UISwitch!
    
    @IBOutlet private weak var ColorModeTitle: UILabel!
    @IBOutlet private weak var UIColorModeSegmentedControl: UISegmentedControl!
    
    @IBOutlet private weak var Player1NameLabel: UILabel!
    @IBOutlet private weak var Player1NameTextField: UITextField!
    
    @IBOutlet private weak var Player2NameLabel: UILabel!
    @IBOutlet private weak var Player2NameTextField: UITextField!
    
    @IBOutlet private weak var Is2ndPlayerAILabel: UILabel!
    @IBOutlet private weak var Is2ndPlayerAISwitch: UISwitch!
    
    @IBOutlet private weak var ScoreLimitLabel: UILabel!
    @IBOutlet private weak var ScoreLimitTextField: UITextField!
    @IBOutlet weak var ScoreLimitRangeLabel: UILabel!
    
    @IBOutlet private weak var GameTypeTitle: UILabel!
    @IBOutlet private weak var GameTypeSegmentedControl: UISegmentedControl!
    
    @IBOutlet private weak var NoteLabel: UILabel!
    
    @IBOutlet private weak var CancelButton: UIButton!
    @IBOutlet private weak var SaveButton: UIButton!

    // MARK: - Action(s)
    
    // Returt to the main screen without saving any changes to the Options
    @IBAction private func CancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
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
        
        localizeUI()
    }
    
    @IBAction private func ColorModeSelectionChanged(_ sender: UISegmentedControl) {
        switch UIColorModeSegmentedControl.selectedSegmentIndex {
        case 0:
            Options.colorMode = .System
            
        case 1:
            Options.colorMode = .Light
            
        case 2:
            Options.colorMode = .Dark
            
        default:
            print("Missing Color Mode")
        }
        
        updateColorMode()
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
        Options.isVibrationEnabled = VibrationEnabledSwitch.isOn
        
        switch GameTypeSegmentedControl.selectedSegmentIndex {
        case 0:
            Options.gameType = .PigGame1Dice
            
        case 1:
            Options.gameType = .PigGame2Dice
            
        default:
            break
        }
        
        Options.player1Name     = Player1NameTextField.text ?? Options.player1Name
        Options.player2Name     = Player2NameTextField.text ?? Options.player2Name
        Options.is2ndPlayerAI   = Is2ndPlayerAISwitch.isOn
        
        if let newScoreLimitString = ScoreLimitTextField.text {
            if let newScoreLimit = Int(newScoreLimitString) {
                if 10...1000 ~= newScoreLimit {
                    Options.scoreLimit = newScoreLimit
                } else {
                    updateUI()
                    print("Invalid score limit range, reverting to default")
                }
            }
        }
            
        // Save options, call delegate to localise the Game screen and dismiss view controller
        Options.save()
        optionsViewControllerDelegate?.viewWillDimiss()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Player1NameTextField.delegate   = self
        Player2NameTextField.delegate   = self
        ScoreLimitTextField.delegate    = self
        
        // Dismissed keyboard after tapping outside an edited field
        let tapOutsideTextField = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tapOutsideTextField.cancelsTouchesInView = false
        view.addGestureRecognizer(tapOutsideTextField)
        
        Options.load()
        updateColorMode()
        localizeUI()
        updateUI()
    }

    // MARK: - Method(s)
    
    // Dismiss keyboard after pressing Return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
        
    private func localizeUI() {
        let language = Options.language
                
        SoundEnabledTitle.text = LocalizedUI.soundEnabledSwitch.translate(to: language)
        VibrationEnabledTitle.text = LocalizedUI.vibrationEnabledSwitch.translate(to: language)
        ColorModeTitle.text = LocalizedUI.colorModeSelectionLabel.translate(to: language)
        
        Player1NameLabel.text = LocalizedUI.player1NameLabel.translate(to: language)
        Player2NameLabel.text = LocalizedUI.player2NameLabel.translate(to: language)
        Is2ndPlayerAILabel.text = LocalizedUI.is2ndPlayerAILabel.translate(to: language)
        
        ScoreLimitLabel.text = LocalizedUI.scoreLimitLabel.translate(to: language)
        GameTypeTitle.text = LocalizedUI.gameTypeLabel.translate(to: language)
        
        NoteLabel.text = LocalizedUI.noteLabel.translate(to: language)
        NoteLabel.textAlignment = .natural
        
        SaveButton.setTitle(LocalizedUI.saveButton.translate(to: language), for: .normal)
        CancelButton.setTitle(LocalizedUI.cancelButton.translate(to: language), for: .normal)
        
        GameTypeSegmentedControl
            .setTitle(LocalizedUI.with1DiceSegmentedControlLabel.translate(to: language), forSegmentAt: 0)
        GameTypeSegmentedControl
            .setTitle(LocalizedUI.with2DiceSegmentedControlLabel.translate(to: language), forSegmentAt: 1)
        
        UIColorModeSegmentedControl
            .setTitle(LocalizedUI.colorSysModeSegmentedControlLabel.translate(to: language), forSegmentAt: 0)
        UIColorModeSegmentedControl
            .setTitle(LocalizedUI.colorLightModeSegmentedControlLabel.translate(to: language), forSegmentAt: 1)
        UIColorModeSegmentedControl
            .setTitle(LocalizedUI.colorDarkModeSegmentedControlLabel.translate(to: language), forSegmentAt: 2)
    }
    
    private func updateUI() {
        switch Options.language {
        case .En:
            LanguageSelectionSegmentedControl.selectedSegmentIndex = 0
            
        case .Ru:
            LanguageSelectionSegmentedControl.selectedSegmentIndex = 1
        }
        
        switch Options.colorMode {
        case .System:
            UIColorModeSegmentedControl.selectedSegmentIndex = 0
            
        case .Light:
            UIColorModeSegmentedControl.selectedSegmentIndex = 1
            
        case .Dark:
            UIColorModeSegmentedControl.selectedSegmentIndex = 2
        }
           
        SaveButton.backgroundColor = playerColor
        CancelButton.backgroundColor = playerColor
        
        SoundEnabledSwitch.isOn     = Options.isSoundEnabled
        VibrationEnabledSwitch.isOn = Options.isVibrationEnabled
        
        switch Options.gameType {
        case .PigGame1Dice:
            GameTypeSegmentedControl.selectedSegmentIndex = 0
            
        case .PigGame2Dice:
            GameTypeSegmentedControl.selectedSegmentIndex = 1
        }
        
        Player1NameTextField.text = Options.player1Name
        Player2NameTextField.text = Options.player2Name
        Is2ndPlayerAISwitch.isOn  = Options.is2ndPlayerAI
        ScoreLimitTextField.text  = String(Options.scoreLimit)
    }
}

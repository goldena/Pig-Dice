//
//  OptionsListTableViewController.swift
//  Pig Dice Game
//
//  Created by Denis Goloborodko on 3.03.21.
//

import UIKit

protocol OptionsTableViewControllerDelegate {
    func UIOptionsAreUpdated()
}

class OptionsTableViewController: UITableViewController, UITextFieldDelegate {

    // MARK: - Outlet(s)
    
    @IBOutlet weak var LanguageSelectionSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var SoundEnabledLabel: UILabel!
    @IBOutlet weak var SoundEnabledSwitch: UISwitch!
    
    @IBOutlet weak var VibrationEnabledLabel: UILabel!
    @IBOutlet weak var VibrationEnabledSwitch: UISwitch!
    
//    @IBOutlet weak var ColorModeTitle: UILabel!
    @IBOutlet weak var UIColorModeSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var Player1NameLabel: UILabel!
    @IBOutlet weak var Player1NameTextField: UITextField!
    
    @IBOutlet weak var Player2NameLabel: UILabel!
    @IBOutlet weak var Player2NameTextField: UITextField!
    
    @IBOutlet weak var Is2ndPlayerAILabel: UILabel!
    @IBOutlet weak var Is2ndPlayerAISwitch: UISwitch!
    
    @IBOutlet weak var ScoreLimitLabel: UILabel!
    @IBOutlet weak var ScoreLimitTextField: UITextField!
    @IBOutlet weak var ScoreLimitRangeLabel: UILabel!
    
//    @IBOutlet weak var GameTypeLabel: UILabel!
    @IBOutlet weak var GameTypeSegmentedControl: UISegmentedControl!
    
    @IBOutlet private weak var NoteLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Dismissed keyboard after tapping outside an edited field
        let tapOutsideTextField = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tapOutsideTextField.cancelsTouchesInView = false
        view.addGestureRecognizer(tapOutsideTextField)
        
        Player1NameTextField.delegate   = self
        Player2NameTextField.delegate   = self
        ScoreLimitTextField.delegate    = self
        
        localizeUI()
        updateUI()
    }
        
    // MARK: - Action(s)
    
    // Changes localization on the fly
    @IBAction private func LanguageSelectionChanged(_ sender: UISegmentedControl) {
        switch LanguageSelectionSegmentedControl.selectedSegmentIndex {
        case 0:
            Options.language = .En
            
        case 1:
            Options.language = .Ru
            
        default:
            NSLog("Missing language selected")
        }
        
        localizeUI()
        tableView.reloadData()
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
            NSLog("Missing Color Mode")
        }
        
        updateColorMode()
    }
            
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let language = Options.language
        
        #warning("add proper localized strings")
        switch section {
        case 0:
            return NSLocalizedString("Language / Язык", comment: "")
        case 1:
            return LocalizedUI.colorModeSelectionLabel.translate(to: language)
        case 2:
            return NSLocalizedString("Sound and Vibration", comment: "")
        case 3:
            return NSLocalizedString("Players", comment: "")
        case 4:
            return LocalizedUI.gameTypeLabel.translate(to: language)
        case 5:
            return NSLocalizedString("Note", comment: "")
        default:
            return nil
        }
    }
    
    #warning("Start here")
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        indexPath == IndexPath(row: 0, section: 5) ? 132 : tableView.rowHeight
        
    }
    
    // MARK: - Method(s)
    
    private func localizeUI() {
        let language = Options.language
                
        SoundEnabledLabel.text = LocalizedUI.soundEnabledSwitch.translate(to: language)
        VibrationEnabledLabel.text = LocalizedUI.vibrationEnabledSwitch.translate(to: language)
        
        Player1NameLabel.text = LocalizedUI.player1NameLabel.translate(to: language)
        Player2NameLabel.text = LocalizedUI.player2NameLabel.translate(to: language)
        Is2ndPlayerAILabel.text = LocalizedUI.is2ndPlayerAILabel.translate(to: language)
        
        ScoreLimitLabel.text = LocalizedUI.scoreLimitLabel.translate(to: language)
        
        NoteLabel.text = LocalizedUI.noteLabel.translate(to: language)
        NoteLabel.textAlignment = .natural
                
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

    // Dismiss keyboard after pressing Return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}

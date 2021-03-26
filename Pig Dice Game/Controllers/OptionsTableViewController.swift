//
//  OptionsListTableViewController.swift
//  Pig Dice Game
//
//  Created by Denis Goloborodko on 3.03.21.
//

import UIKit

class OptionsTableViewController: UITableViewController, UITextFieldDelegate {

    // MARK: - Outlet(s)
    
    @IBOutlet weak var LanguageSelectionSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var BackgroundImageSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var SoundEnabledLabel: UILabel!
    @IBOutlet weak var SoundEnabledSwitch: UISwitch!
    
    @IBOutlet weak var MusicEnabledLabel: UILabel!
    @IBOutlet weak var MusicEnabledSwitch: UISwitch!
    
    @IBOutlet weak var VibrationEnabledLabel: UILabel!
    @IBOutlet weak var VibrationEnabledSwitch: UISwitch!
    
    @IBOutlet weak var ColorModeSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var Player1NameLabel: UILabel!
    @IBOutlet weak var Player1NameTextField: UITextField!
    
    @IBOutlet weak var Player2NameLabel: UILabel!
    @IBOutlet weak var Player2NameTextField: UITextField!
    
    @IBOutlet weak var Is2ndPlayerAILabel: UILabel!
    @IBOutlet weak var Is2ndPlayerAISwitch: UISwitch!
    
    @IBOutlet weak var ScoreLimitLabel: UILabel!
    @IBOutlet weak var ScoreLimitTextField: UITextField!
    @IBOutlet weak var ScoreLimitRangeLabel: UILabel!

    @IBOutlet weak var GameTypeSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var NoteLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTapOutsideTextFieldGestureRecognizer()        
        ScoreLimitTextField.addToolbarWithDoneButton()
        
        Player1NameTextField.delegate = self
        Player2NameTextField.delegate = self
        ScoreLimitTextField.delegate = self
                
        localizeUI()
        updateUI()
    }
       
    // Special hight for Note section (relatively long text there)
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        indexPath == IndexPath(row: 0, section: 6) ? 150 : 50 // Tall row for the "Note"
    }
    
    // Localize section titles
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let language = Options.language
        
        switch section {
        case 0:
            return LocalizedUI.languageSectionTitle.translate(to: language)
        case 1:
            return LocalizedUI.colorModeSectionTitle.translate(to: language)
        case 2:
            return LocalizedUI.backgroundImageSectionTitle.translate(to: language)
        case 3:
            return LocalizedUI.soundAndVibrationSectionTitle.translate(to: language)
        case 4:
            return LocalizedUI.playersSegmentTitle.translate(to: language)
        case 5:
            return LocalizedUI.gameTypeLabel.translate(to: language)
        case 6:
            return LocalizedUI.noteSegmentTitle.translate(to: language)
        default:
            return nil
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case ScoreLimitTextField:
            // Check if the input of Score limit is valid and within range, else alert and revert to the default
            guard let newScoreLimit = Int(textField.text ?? "Invalid input"),
                  10...1000 ~= newScoreLimit else {
                alertThenHandleEvent(
                    color: Const.Player1Color,
                    title: "Invalid Score Limit input or range",
                    message: "The Score Limit will be set to the default value: \(Const.DefaultScoreLimit)",
                    handler: {
                        textField.text = String(Const.DefaultScoreLimit)
                    })
                return
            }
        case Player1NameTextField, Player2NameTextField:
            guard let isEmptyString = textField.text?.trimmingCharacters(in: .whitespaces).isEmpty else { return }
            
            if isEmptyString {
                alertThenHandleEvent(
                    color: Const.Player1Color,
                    title: "Empty or invalid name",
                    message: "The name will be set to a default one",
                    handler: {
                        textField.text = (textField === self.Player1NameTextField) ? Const.DefaultPlayer1Name : Const.DefaultPlayer2Name
                    })
                return
            }
        default:
            NSLog("Unexpected fallthrough while matching text fields of the options list")
            return
        }
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
        
        // Localize parent View Controller
        let optionsViewController = self.parent as? OptionsViewController
        optionsViewController?.localizeUI()
    }
    
    @IBAction private func ColorModeSelectionChanged(_ sender: UISegmentedControl) {
        switch ColorModeSegmentedControl.selectedSegmentIndex {
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
        
        // Update Color Mode of the parent View Controller
        let optionsViewController = self.parent as? OptionsViewController
        optionsViewController?.updateColorMode()
    }
    
    
    @IBAction func BackgroundImageValueChanged(_ sender: UISegmentedControl) {
        
        // Update Background Image of the parent View Controller
        let optionsViewController = self.parent as? OptionsViewController
        
        switch BackgroundImageSegmentedControl.selectedSegmentIndex {
        case 0:
            Options.backgroundImage = .piggies
        case 1:
            Options.backgroundImage = .blackboard
        default:
            Options.backgroundImage = .none
        }
                
        optionsViewController?.updateBackgroundImage()
    }
    
    @IBAction func MusicSwitchValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            SoundAndHapticController.playNext()
        } else {
            SoundAndHapticController.stopMusic()
        }
    }
    
    // MARK: - Method(s)
    
    func localizeUI() {
        let language = Options.language
                
        SoundEnabledLabel.text = LocalizedUI.soundEnabledSwitch.translate(to: language)
        MusicEnabledLabel.text = LocalizedUI.musicEnabledSwitch.translate(to: language)
        VibrationEnabledLabel.text = LocalizedUI.vibrationEnabledSwitch.translate(to: language)
        
        Player1NameLabel.text = LocalizedUI.player1NameLabel.translate(to: language)
        Player2NameLabel.text = LocalizedUI.player2NameLabel.translate(to: language)
        Is2ndPlayerAILabel.text = LocalizedUI.is2ndPlayerAILabel.translate(to: language)
        
        ScoreLimitLabel.text = LocalizedUI.scoreLimitLabel.translate(to: language)
        ScoreLimitRangeLabel.text = LocalizedUI.scoreLimitRangeLabel.translate(to: language)
        
        NoteLabel.text = LocalizedUI.noteLabel.translate(to: language)
        NoteLabel.textAlignment = .natural
        
        GameTypeSegmentedControl.setTitle(
            LocalizedUI.with1DiceSegmentedControlLabel.translate(to: language), forSegmentAt: 0
        )
        GameTypeSegmentedControl.setTitle(
            LocalizedUI.with2DiceSegmentedControlLabel.translate(to: language), forSegmentAt: 1
        )
        
        ColorModeSegmentedControl.setTitle(
            LocalizedUI.colorSysModeSegmentedControlLabel.translate(to: language), forSegmentAt: 0
        )
        ColorModeSegmentedControl.setTitle(
            LocalizedUI.colorLightModeSegmentedControlLabel.translate(to: language), forSegmentAt: 1
        )
        ColorModeSegmentedControl.setTitle(
            LocalizedUI.colorDarkModeSegmentedControlLabel.translate(to: language), forSegmentAt: 2
        )
        
        BackgroundImageSegmentedControl.setTitle(
                LocalizedUI.pigsBackgroundImageSegmentedControlLabel.translate(to: language), forSegmentAt: 0
            )
        BackgroundImageSegmentedControl.setTitle(
                LocalizedUI.blackboardBackgroundImageSegmentedControlLabel.translate(to: language), forSegmentAt: 1
            )
        BackgroundImageSegmentedControl.setTitle(
            LocalizedUI.noBackgroundImageSegmentedControlLabel.translate(to: language), forSegmentAt: 2
        )
    }
    
    func updateUI() {
        switch Options.language {
        case .En:
            LanguageSelectionSegmentedControl.selectedSegmentIndex = 0
        case .Ru:
            LanguageSelectionSegmentedControl.selectedSegmentIndex = 1
        }
        
        switch Options.colorMode {
        case .System:
            ColorModeSegmentedControl.selectedSegmentIndex = 0
        case .Light:
            ColorModeSegmentedControl.selectedSegmentIndex = 1
        case .Dark:
            ColorModeSegmentedControl.selectedSegmentIndex = 2
        }
        
        switch Options.backgroundImage {
        case .piggies:
            BackgroundImageSegmentedControl.selectedSegmentIndex = 0
        case .blackboard:
            BackgroundImageSegmentedControl.selectedSegmentIndex = 1
        case .none:
            BackgroundImageSegmentedControl.selectedSegmentIndex = 2
        }
        
        SoundEnabledSwitch.isOn     = Options.isSoundEnabled
        MusicEnabledSwitch.isOn     = Options.isMusicEnabled
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

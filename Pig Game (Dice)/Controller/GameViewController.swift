//
//  ViewController.swift
//  Pig Game (Dice)
//
//  Created by Denis Goloborodko on 10/8/20.
//

import UIKit

// Main screen view controller
class GameViewController: UIViewController, ViewControllerDelegate {
    
    @IBOutlet var ButtonsCollection: [UIButton]!
    @IBOutlet private weak var NewGameButton: UIButton!
    @IBOutlet private weak var RollButton: UIButton!
    @IBOutlet private weak var HoldButton: UIButton!
    
    // StackView for programmatically adding/removing 2-nd Dice
    @IBOutlet private weak var DiceImagesStackView: UIStackView!
    
    @IBOutlet private weak var CurrentScoreLabel: UILabel!
    @IBOutlet private weak var CurrentScoreValue: UILabel!
    
    @IBOutlet private weak var ScoreLimitLabel: UILabel!
    @IBOutlet private weak var ScoreLimitValue: UILabel!
    
    @IBOutlet private weak var TotalScoresLabel: UILabel!
    @IBOutlet private weak var PlayerOneScoreValue: UILabel!
    @IBOutlet private weak var PlayerTwoScoreValue: UILabel!
    
    @IBOutlet private weak var CurrentPlayerLabel: UILabel!
    @IBOutlet private weak var CurrentPlayerName: UILabel!
    
    @IBAction private func RollButtonPressed(_ sender: UIButton) {
        roll()
    }
    
    @IBAction private func HoldButtonPressed(_ sender: UIButton) {
        hold()
    }
    
    @IBAction private func OptionsButtonPressed(_ sender: Any) {
        self.present(optionsViewController, animated: true, completion: nil)
    }
    
    @IBAction private func NewGameButtonPressed(_ sender: UIButton) {
        // Reloads defaults in case there were changes
        startNewGame()
        alertThenHandleNewGame()
    }
        
    private var dice1ImageView: UIImageView!
    // The second dice ImageView is programmatic, initialized depending on a game type
    private var dice2ImageView: UIImageView!
    
    // For delegation needs, to dynamically update some of the options on the main game screen
    private var optionsViewController = OptionsViewController()
    
    var game = Game()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Save initial defaults if the game is launched for the first time
        Options.onFirstLaunch()
        Options.load()
        
        // Instantiate Options ViewController for delegation
        optionsViewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(identifier: "OptionsViewController")
        optionsViewController.optionsViewControllerDelegate = self
        
        // Create Dice 1 ImageView
        dice1ImageView = UIImageView()
        dice1ImageView.contentMode = .scaleAspectFit
        dice1ImageView.translatesAutoresizingMaskIntoConstraints = false
        DiceImagesStackView.addArrangedSubview(dice1ImageView)
        
        startNewGame()
        updateColorMode()
        updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        alertThenHandleNewGame()
    }
    
    // Delegation func, to localise UI once the Options are saved
    func viewWillDimiss() {
        updateColorMode()
        localiseUI()
    }
    
    // Add or Remove ImageView for the 2nd Dice
    private func updateDiceImageViews() {
        if Options.gameType == .PigGame2Dice && dice2ImageView == nil {
            dice2ImageView = UIImageView()
            dice2ImageView!.contentMode = .scaleAspectFit
            dice2ImageView!.translatesAutoresizingMaskIntoConstraints = false
            DiceImagesStackView.addArrangedSubview(dice2ImageView!)
        }
        
        if Options.gameType == .PigGame1Dice && dice2ImageView != nil {
            dice2ImageView?.removeFromSuperview()
            dice2ImageView = nil
        }
    }
        
    private func alertThenHandleNewGame() {
        alertThenHandleEvent(title: LocalizedUI.newGameTitle.translate(to: Options.language),
                             message: LocalizedUI.newGameMessage.translate(to: Options.language),
                             handler: {
                                self.updateUI()
                                self.nextMoveIfAI()
                                })
    }
    
    private func startNewGame() {
        Options.load()
        updateDiceImageViews()
        
        game.initNewGame()
        localiseUI()
    }
    
    private func nextMoveIfAI() {
        guard game.activePlayer.isAI else {
            return
        }

        disableButtons(ButtonsCollection)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            let AIPlayer = self.game.activePlayer
            // Hold if already had won the game
            if AIPlayer.roundScore + AIPlayer.totalScore >= Options.scoreLimit {
                self.hold()
                self.enableButtons(self.ButtonsCollection)
                return
            }
            
            // Hold if previos throw was 6 (for a single dice game)
            if Options.gameType == .PigGame1Dice && AIPlayer.previousDiceIs6 {
                self.hold()
                self.enableButtons(self.ButtonsCollection)
                return
            }
            
            // Hold if above some random cap, otherwise throw again
            // TODO: impelement more sophisticated AI behaviour,
            // more risk-prone, when the rival is far ahead and vice-versa
            if AIPlayer.roundScore >= Int.random(in: 12...24) {
                self.hold()
            } else {
                self.roll()
            }
            self.enableButtons(self.ButtonsCollection)
        })
    }
        
    private func alertThenHandleRollResult(_ dice: Int) {
        let player = game.activePlayer
        let language = Options.language
        
        switch dice {
        case 1:
            alertThenHandleEvent(title: LocalizedUI.threw1Title.translate(name: player.name,
                                                                          to: language),
                                 message: LocalizedUI.threw1Message.translate(name: player.name,
                                                                              to: language),
                                 handler: {
                                    self.game.nextPlayer()
                                    self.updateUI()
                                    self.nextMoveIfAI()
                                 })
        case 6:
            if game.activePlayer.previousDiceIs6 {
                alertThenHandleEvent(title: LocalizedUI.threw6TwiceTitle.translate(name: player.name,
                                                                                   to: Options.language),
                                     message: LocalizedUI.threw6TwiceMessage.translate(name: player.name,
                                                                                       to: Options.language),
                                     handler: {
                                        self.game.nextPlayer()
                                        self.updateUI()
                                        self.nextMoveIfAI()
                                        })
            } else {
                fallthrough
            }
        default:
            if dice == 6 {
                player.previousDiceIs6 = true
            } else {
                player.previousDiceIs6 = false
            }
                
            nextMoveIfAI()
        }
    }
    
    private func alertThenHandleRollResult(_ dice1: Int, _ dice2: Int) {
        let player = game.activePlayer
        
        switch (dice1, dice2) {
        case (_, 1), (1, _):
            alertThenHandleEvent(title: LocalizedUI.threw1Title.translate(name: player.name,
                                                                          to: Options.language),
                                 message: LocalizedUI.threw1Message.translate(name: player.name,
                                                                              to: Options.language),
                                 handler: {
                                    self.game.nextPlayer()
                                    self.updateUI()
                                    self.nextMoveIfAI()
                                 })
        case (6, 6):
            alertThenHandleEvent(title: LocalizedUI.threwTwo6Message.translate(name: player.name,
                                                                               to: Options.language),
                                 message: LocalizedUI.threwTwo6Message.translate(name: player.name,
                                                                                 to: Options.language),
                                 handler: {
                                    self.game.nextPlayer()
                                    self.updateUI()
                                    self.nextMoveIfAI()
                                 })
        default:
            nextMoveIfAI()
        }
    }
    
    private func roll() {
        // Game mechanics: roll, calculate scores, check conditions, display alerts
        let player = game.activePlayer
        player.rollDice()
        
        playHaptic()
        
        if Options.isSoundEnabled {
            playSound("dice_roll", type: "wav")
        }
        
        if game.gameType == .PigGame1Dice {
            guard let dice = player.dice1 else {
                print("Dice is nil")
                return
            }
            game.calculateScores(dice)
            updateUI()
            alertThenHandleRollResult(dice)
        }
        
        if game.gameType == .PigGame2Dice {
            guard let dice1 = player.dice1,
                  let dice2 = player.dice2 else {
                print("One of dice is nil")
                return
            }
            game.calculateScores(dice1, dice2)
            updateUI()
            alertThenHandleRollResult(dice1, dice2)
        }
    }
        
    private func alertThenHandleVictory() {
        alertThenHandleEvent(title: LocalizedUI.winnerTitle.translate(name: game.activePlayer.name,
                                                                      to: Options.language),
                             message: LocalizedUI.victoryMessage.translate(name: game.activePlayer.name,
                                                                           to: Options.language) + String(game.activePlayer.totalScore),
                             handler: {
                                self.startNewGame()
                                self.alertThenHandleNewGame()
                             })
    }
    
    private func hold() {
        // Hold current scores
        game.activePlayer.holdRoundScore()
        
        if game.activePlayer.totalScore >= game.scoreLimit {
            alertThenHandleVictory()
            return
        }
        
        game.nextPlayer()
        updateUI()
        nextMoveIfAI()
    }
    
    // Displays info alert with Okay button
    private func alertThenHandleEvent(title: String, message: String, handler: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: LocalizedUI.alertActionTitle.translate(to: Options.language), style: .default, handler: { _ in handler() }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func localiseUI() {
        let language = Options.language
        
        // Localise buttons
        NewGameButton.setTitle(LocalizedUI.newGameButton.translate(to: language), for: .normal)
        RollButton.setTitle(LocalizedUI.rollButton.translate(to: language), for: .normal)
        HoldButton.setTitle(LocalizedUI.holdButton.translate(to: language), for: .normal)
        
        // Localise text
        CurrentScoreLabel.text  = LocalizedUI.currentScoreLabel.translate(to: language)
        ScoreLimitLabel.text    = LocalizedUI.scoreLimitLabel.translate(to: language)
        TotalScoresLabel.text   = LocalizedUI.totalScoresLabel.translate(to: language)
        CurrentPlayerLabel.text = LocalizedUI.currentPlayerLabel.translate(to: language)
    }
    
    private func updateUI() {
        // Show or Hide dice image at the beginning of each round or a new game
        if let dice1 = game.activePlayer.dice1 {
            dice1ImageView.image = Const.DiceFaces[dice1 - 1]
        } else {
            dice1ImageView.image = nil
        }
        
        if game.gameType == .PigGame2Dice {
            if let dice2 = game.activePlayer.dice2 {
                dice2ImageView?.image = Const.DiceFaces[dice2 - 1]
            } else {
                dice2ImageView?.image = nil
            }
        }
        
        ScoreLimitValue.text     = String(game.scoreLimit)
        CurrentPlayerName.text  = game.activePlayer.name
        PlayerOneScoreValue.text = "\(game.player1.name): \(game.player1.totalScore)"
        PlayerTwoScoreValue.text = "\(game.player2.name): \(game.player2.totalScore)"
        CurrentScoreValue.text   = "\(game.activePlayer.roundScore)"
    }
}

extension GameViewController {
    private func updateColorMode() {
        switch Options.colorMode {
        case .System:
            overrideUserInterfaceStyle = .unspecified
        case .Light:
            overrideUserInterfaceStyle = .light
        case .Dark:
            overrideUserInterfaceStyle = .dark
        }
    }

    private func disableButton(_ button: UIButton) {
        DispatchQueue.main.async {
            button.isEnabled = false
        }
    }
    
    private func enableButton(_ button: UIButton) {
        button.isEnabled = true
    }
    
    private func disableButtons(_ buttons: [UIButton]) {
        for button in buttons {
            disableButton(button)
        }
    }
    
    private func enableButtons(_ buttons: [UIButton]) {
        for button in buttons {
            enableButton(button)
        }
    }
}

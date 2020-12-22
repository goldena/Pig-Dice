//
//  ViewController.swift
//  Pig Game (Dice)
//
//  Created by Denis Goloborodko on 10/8/20.
//

import UIKit

// Main screen view controller
class GameViewController: UIViewController, ViewControllerDelegate {
    
    private var game = Game()
    
    private var dice1ImageView: UIImageView!
    // The second dice ImageView is programmatic, initialized depending on the game type
    private var dice2ImageView: UIImageView?
    
    // For delegation needs, to dynamically update some of the options on the main game screen
    private var optionsViewController = OptionsViewController()
    
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        updateUI()
        alertThenHandleNewGame()
    }
    
    // Delegation func, to localise UI once the Options are saved
    func viewWillDimiss() {
        localiseUI()
    }
    
    // Add or Remove ImageView for the 2nd Dice
    private func updateDiceImageViews() {
        if Options.gameType == .pigGame2Dice && dice2ImageView == nil {
            dice2ImageView = UIImageView()
            dice2ImageView!.contentMode = .scaleAspectFit
            dice2ImageView!.translatesAutoresizingMaskIntoConstraints = false
            DiceImagesStackView.addArrangedSubview(dice2ImageView!)
        }
        
        if Options.gameType == .pigGame1Dice && dice2ImageView != nil {
            dice2ImageView?.removeFromSuperview()
            dice2ImageView = nil
        }
    }
    
    @IBAction private func NewGameButtonPressed(_ sender: UIButton) {
        // Reloads defaults in case there were changes
        startNewGame()
        alertThenHandleNewGame()
    }
    
    private func alertThenHandleNewGame() {
        alertThenHandleEvent(title: LocalizedUI.newGameTitle.translate(to: Options.language),
                             message: LocalizedUI.newGameMessage.translate(to: Options.language),
                             handler: {
                                self.updateUI()
                                
                                if self.game.activePlayer.isAI {
                                    self.nextMoveAsAI()
                                }
                             })
    }
    
    private func startNewGame() {
        Options.load()
        updateDiceImageViews()
        
        game.initNewGame()
        localiseUI()
    }
    
    private func nextMoveAsAI() {
        disableButtons()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            let AIPlayer = self.game.activePlayer
            
            // Hold if already had won the game
            if AIPlayer.roundScore + AIPlayer.totalScore >= Options.scoreLimit {
                self.hold()
                self.enableButtons()
                return
            }
            
            // Hold if previos throw was 6 (for a single dice game)
            if Options.gameType == .pigGame1Dice && AIPlayer.previousDiceIs6 {
                self.hold()
                self.enableButtons()
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
            self.enableButtons()
        })
    }
    
    @IBAction private func OptionsButtonPressed(_ sender: Any) {
        self.present(optionsViewController, animated: true, completion: nil)
    }
    
    private func alertThenHandleRollResult(_ dice: Int) {
        switch dice {
        case 1:
            alertThenHandleEvent(title: LocalizedUI.threw1Title.translate(to: Options.language),
                                 message: "\(game.activePlayer.name) \(LocalizedUI.threw1Message.translate(to: Options.language))",
                                 handler: {
                                    self.game.nextPlayer()
                                    self.updateUI()
                                    
                                    if self.game.activePlayer.isAI {
                                        self.nextMoveAsAI()
                                    }
                                 })
        case 6:
            if game.activePlayer.previousDiceIs6 {
                alertThenHandleEvent(title: LocalizedUI.threw6TwiceTitle.translate(to: Options.language),
                                     message: "\(game.activePlayer.name) \(LocalizedUI.threw6TwiceMessage.translate(to: Options.language))",
                                     handler: {
                                        self.game.nextPlayer()
                                        self.updateUI()
                                        
                                        if self.game.activePlayer.isAI {
                                            self.nextMoveAsAI()
                                        }
                                     })
            } else {
                fallthrough
            }
        default:
            if dice == 6 {
                game.activePlayer.previousDiceIs6 = true
            } else {
                game.activePlayer.previousDiceIs6 = false
            }
                
            if game.activePlayer.isAI {
                nextMoveAsAI()
            }
        }
    }
    
    private func alertThenHandleRollResult(_ dice1: Int, _ dice2: Int) {
        switch (dice1, dice2) {
        case (_, 1), (1, _):
            alertThenHandleEvent(title: LocalizedUI.threw1Title.translate(to: Options.language),
                                 message: "\(game.activePlayer.name) \(LocalizedUI.threw1Message.translate(to: Options.language))",
                                 handler: {
                                    self.game.nextPlayer()
                                    self.updateUI()
                                    
                                    if self.game.activePlayer.isAI {
                                        self.nextMoveAsAI()
                                    }
                                 })
        case (6, 6):
            alertThenHandleEvent(title: LocalizedUI.threw6TwiceTitle.translate(to: Options.language),
                                 message: "\(game.activePlayer.name) \(LocalizedUI.threw6TwiceMessage.translate(to: Options.language))",
                                 handler: {
                                    self.game.nextPlayer()
                                    self.updateUI()
                                    
                                    if self.game.activePlayer.isAI {
                                        self.nextMoveAsAI()
                                    }
                                 })
        default:
            if game.activePlayer.isAI {
                nextMoveAsAI()
            }
        }
    }
    
    private func roll() {
        // Game mechanics: roll, calculate scores, check conditions, display alerts
        let player = game.activePlayer
        player.rollDice()
        
        if Options.isSoundEnabled {
            playSound("dice_roll", type: "wav")
        }
        
        if game.gameType == .pigGame1Dice {
            guard let dice = player.dice1 else {
                print("Dice is nil")
                return
            }
            game.calculateScores(dice)
            updateUI()
            alertThenHandleRollResult(dice)
        }
        
        if game.gameType == .pigGame2Dice {
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
    
    @IBAction private func RollButtonPressed(_ sender: UIButton) {
        roll()
    }
    
    private func alertThenHandleVictory() {
        alertThenHandleEvent(title: LocalizedUI.winnerTitle.translate(to: Options.language),
                             message: "\(game.activePlayer.name) \(LocalizedUI.victoryMessage.translate(to: Options.language)) \(game.activePlayer.totalScore)!",
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
        
        if game.activePlayer.isAI {
            nextMoveAsAI()
        }
    }
    
    @IBAction private func HoldButtonPressed(_ sender: UIButton) {
        hold()
    }
    
    @IBOutlet private weak var NewGameButton: UIButton!
    @IBOutlet private weak var RollButton: UIButton!
    @IBOutlet private weak var HoldButton: UIButton!
    
    // StackView for programmatically adding/removing 2-nd Dice
    @IBOutlet private weak var DiceImagesStackView: UIStackView!
    
    @IBOutlet private weak var CurrentScoreTitle: UILabel!
    @IBOutlet private weak var CurrentScoreLabel: UILabel!
    
    @IBOutlet private weak var ScoreLimitTitle: UILabel!
    @IBOutlet private weak var ScoreLimitLabel: UILabel!
    
    @IBOutlet private weak var TotalScoresTitle: UILabel!
    @IBOutlet private weak var PlayerOneScoreLabel: UILabel!
    @IBOutlet private weak var PlayerTwoScoreLabel: UILabel!
    
    @IBOutlet private weak var CurrentPlayerTitle: UILabel!
    @IBOutlet private weak var CurrentPlayerLabel: UILabel!
    
    
    // Displays info alert with Okay button
    private func alertThenHandleEvent(title: String, message: String, handler: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: LocalizedUI.alertActionTitle.translate(to: Options.language), style: .default, handler: { _ in handler() }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func disableButton(_ button: UIButton) {
        DispatchQueue.main.async {
            button.isEnabled = false
            button.backgroundColor = .systemGray
        }
    }
    
    private func enableButton(_ button: UIButton) {
        button.isEnabled = true
        button.backgroundColor = Const.ButtonColor
    }
    
    private func disableButtons() {
        disableButton(RollButton)
        disableButton(HoldButton)
    }
    
    private func enableButtons() {
        enableButton(RollButton)
        enableButton(HoldButton)
    }
    
    private func localiseUI() {
        let language = Options.language
        
        // Localise buttons
        NewGameButton.setTitle(LocalizedUI.newGameButton.translate(to: language), for: .normal)
        RollButton.setTitle(LocalizedUI.rollButton.translate(to: language), for: .normal)
        HoldButton.setTitle(LocalizedUI.holdButton.translate(to: language), for: .normal)
        
        // Localise text
        CurrentScoreTitle.text  = LocalizedUI.currentScoreTitle.translate(to: language)
        ScoreLimitTitle.text    = LocalizedUI.scoreLimitTitle.translate(to: language)
        TotalScoresTitle.text   = LocalizedUI.totalScoresTitle.translate(to: language)
        CurrentPlayerTitle.text = LocalizedUI.currentPlayerTitle.translate(to: language)
    }
    
    private func updateUI() {
        // Show or Hide dice image at the beginning of each round or a new game
        if let dice1 = game.activePlayer.dice1 {
            dice1ImageView.image = Const.DiceFaces[dice1 - 1]
        } else {
            dice1ImageView.image = nil
        }
        
        if game.gameType == .pigGame2Dice {
            if let dice2 = game.activePlayer.dice2 {
                dice2ImageView?.image = Const.DiceFaces[dice2 - 1]
            } else {
                dice2ImageView?.image = nil
            }
        }
        
        ScoreLimitLabel.text     = String(game.scoreLimit)
        CurrentPlayerLabel.text  = game.activePlayer.name
        PlayerOneScoreLabel.text = "\(game.player1.name): \(game.player1.totalScore)"
        PlayerTwoScoreLabel.text = "\(game.player2.name): \(game.player2.totalScore)"
        CurrentScoreLabel.text   = "\(game.activePlayer.roundScore)"
    }
}

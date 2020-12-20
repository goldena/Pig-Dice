//
//  ViewController.swift
//  Pig Game (Dice)
//
//  Created by Denis Goloborodko on 10/8/20.
//

import UIKit

// Main screen view controller
class GameViewController: UIViewController, ViewControllerDelegate {
    
    var game = Game()
    
    var dice1ImageView: UIImageView!
    // The second dice ImageView is programmatic, depending on a game type
    var dice2ImageView: UIImageView?
    
    // For delegation needs, to dynamically update some of the options on the main game screen
    var optionsViewController = OptionsViewController()
    
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
    func updateDiceImageViews() {
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
    
    @IBAction func NewGameButtonPressed(_ sender: UIButton) {
        // Reloads defaults in case there were changes
        startNewGame()
        alertThenHandleNewGame()
    }
    
    func alertThenHandleNewGame() {
        alertThenHandleEvent(title: LocalisedUI.newGameTitle.translate(to: Options.language),
                             message: LocalisedUI.newGameMessage.translate(to: Options.language),
                             handler: {
                                self.updateUI()
                                
                                if self.game.activePlayer.isAI {
                                    self.nextMoveAsAI()
                                }
                             })
    }
    
    func startNewGame() {
        Options.load()
        updateDiceImageViews()
        
        game.initNewGame()
        localiseUI()
    }
    
    func nextMoveAsAI() {
        disableButtons()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            let AIPlayer = self.game.activePlayer
            
            // Hold if already had won the game
            if AIPlayer.roundScore + AIPlayer.totalScore >= Options.scoreLimit {
                self.hold()
                self.enableButtons()
                return
            }
            
            // Hold if previos thrown dice was 6
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
    
    @IBAction func OptionsButtonPressed(_ sender: Any) {
        self.present(optionsViewController, animated: true, completion: nil)
    }
    
    func alertThenHandleRollResult(_ dice: Int) {
        switch dice {
        case 1:
            alertThenHandleEvent(title: LocalisedUI.threw1Title.translate(to: Options.language),
                                 message: "\(game.activePlayer.name) \(LocalisedUI.threw1Message.translate(to: Options.language))",
                                 handler: {
                                    self.game.nextPlayer()
                                    self.updateUI()
                                    
                                    if self.game.activePlayer.isAI {
                                        self.nextMoveAsAI()
                                    }
                                 })
        case 6:
            if game.activePlayer.previousDiceIs6 {
                alertThenHandleEvent(title: LocalisedUI.threw6TwiceTitle.translate(to: Options.language),
                                     message: "\(game.activePlayer.name) \(LocalisedUI.threw6TwiceMessage.translate(to: Options.language))",
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
    
    func alertThenHandleRollResult(_ dice1: Int, _ dice2: Int) {
        switch (dice1, dice2) {
        case (_, 1), (1, _):
            alertThenHandleEvent(title: LocalisedUI.threw1Title.translate(to: Options.language),
                                 message: "\(game.activePlayer.name) \(LocalisedUI.threw1Message.translate(to: Options.language))",
                                 handler: {
                                    self.game.nextPlayer()
                                    self.updateUI()
                                    
                                    if self.game.activePlayer.isAI {
                                        self.nextMoveAsAI()
                                    }
                                 })
        case (6, 6):
            alertThenHandleEvent(title: LocalisedUI.threw6TwiceTitle.translate(to: Options.language),
                                 message: "\(game.activePlayer.name) \(LocalisedUI.threw6TwiceMessage.translate(to: Options.language))",
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
    
    func roll() {
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
            game.pigGameCalculateScores(dice)
            updateUI()
            alertThenHandleRollResult(dice)
        }
        
        if game.gameType == .pigGame2Dice {
            guard let dice1 = player.dice1,
                  let dice2 = player.dice2 else {
                print("One of dice is nil")
                return
            }
            game.pigGameCalculateScores(dice1, dice2)
            updateUI()
            alertThenHandleRollResult(dice1, dice2)
        }
    }
    
    @IBAction func RollButtonPressed(_ sender: UIButton) {
        roll()
    }
    
    func alertThenHandleVictory() {
        alertThenHandleEvent(title: LocalisedUI.winnerTitle.translate(to: Options.language),
                             message: "\(game.activePlayer.name) \(LocalisedUI.victoryMessage.translate(to: Options.language)) \(game.activePlayer.totalScore)!",
                             handler: {
                                self.startNewGame()
                                self.alertThenHandleNewGame()
                             })
    }
    
    func hold() {
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
    
    @IBAction func HoldButtonPressed(_ sender: UIButton) {
        hold()
    }
    
    @IBOutlet weak var NewGameButton: UIButton!
    @IBOutlet weak var RollButton: UIButton!
    @IBOutlet weak var HoldButton: UIButton!
    
    // StackView for programmatically adding/removing 2-nd Dice
    @IBOutlet weak var DiceImagesStackView: UIStackView!
    
    @IBOutlet weak var CurrentScoreTitle: UILabel!
    @IBOutlet weak var CurrentScoreLabel: UILabel!
    
    @IBOutlet weak var ScoreLimitTitle: UILabel!
    @IBOutlet weak var ScoreLimitLabel: UILabel!
    
    @IBOutlet weak var TotalScoresTitle: UILabel!
    @IBOutlet weak var PlayerOneScoreLabel: UILabel!
    @IBOutlet weak var PlayerTwoScoreLabel: UILabel!
    
    @IBOutlet weak var CurrentPlayerTitle: UILabel!
    @IBOutlet weak var CurrentPlayerLabel: UILabel!
    
    
    // Displays info alert with Okay button
    func alertThenHandleEvent(title: String, message: String, handler: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: LocalisedUI.alertActionTitle.translate(to: Options.language), style: .default, handler: { _ in handler() }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func disableButton(_ button: UIButton) {
        DispatchQueue.main.async {
            button.isEnabled = false
            button.backgroundColor = .systemGray
        }
    }
    
    func enableButton(_ button: UIButton) {
        button.isEnabled = true
        button.backgroundColor = Const.ButtonColor
    }
    
    func disableButtons() {
        disableButton(RollButton)
        disableButton(HoldButton)
    }
    
    func enableButtons() {
        enableButton(RollButton)
        enableButton(HoldButton)
    }
    
    func localiseUI() {
        let language = Options.language
        
        // Localise buttons
        NewGameButton.setTitle(LocalisedUI.newGameButton.translate(to: language), for: .normal)
        RollButton.setTitle(LocalisedUI.rollButton.translate(to: language), for: .normal)
        HoldButton.setTitle(LocalisedUI.holdButton.translate(to: language), for: .normal)
        
        // Localise text
        CurrentScoreTitle.text  = LocalisedUI.currentScoreTitle.translate(to: language)
        ScoreLimitTitle.text    = LocalisedUI.scoreLimitTitle.translate(to: language)
        TotalScoresTitle.text   = LocalisedUI.totalScoresTitle.translate(to: language)
        CurrentPlayerTitle.text = LocalisedUI.currentPlayerTitle.translate(to: language)
    }
    
    func updateUI() {
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

//
//  ViewController.swift
//  Pig Game (Dice)
//
//  Created by Denis Goloborodko on 10/8/20.
//

import UIKit

// Main screen view controller
class GameViewController: UIViewController, ViewControllerDelegate {
        
    // Dice faces
    let diceArray = [#imageLiteral(resourceName: "dice-1"), #imageLiteral(resourceName: "dice-2"), #imageLiteral(resourceName: "dice-3"), #imageLiteral(resourceName: "dice-4"), #imageLiteral(resourceName: "dice-5"), #imageLiteral(resourceName: "dice-6")]
    
    var game = Game()
    
    var dice1ImageView: UIImageView!
    // The second dice ImageView is programmatic, depending on game type
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
        optionsViewController.optionsVCDelegate = self
           
        // Create dice Views depending on the type of game
        createDice1ImageView()
        if Options.gameType == .pigGame2Dice {
            createDice2ImageView()
        }
        
        updateUI()
        localiseUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        game.newGame()

        if game.activePlayer.isAI {
            nextMoveAsAI()
        }
    }
    
    // Delegation func, to localise UI once the Options are saved
    func viewWillDimiss() {
        localiseUI()
    }

    func createDice1ImageView() {
        dice1ImageView = UIImageView()
        
        dice1ImageView.contentMode = .scaleAspectFit
        dice1ImageView.translatesAutoresizingMaskIntoConstraints = false
        
        DiceImagesStackView.addArrangedSubview(dice1ImageView)
    }

    func createDice2ImageView() {
        dice2ImageView = UIImageView()
        
        dice2ImageView!.contentMode = .scaleAspectFit
        dice2ImageView!.translatesAutoresizingMaskIntoConstraints = false

        DiceImagesStackView.addArrangedSubview(dice2ImageView!)
    }
    
    func removeDice2ImageView() {
        dice2ImageView?.removeFromSuperview()
        dice2ImageView = nil
    }

    func updateDiceImageViews() {
        if Options.gameType == .pigGame2Dice && dice2ImageView == nil {
            createDice2ImageView()
        }
        if Options.gameType == .pigGame1Dice && dice2ImageView != nil {
            removeDice2ImageView()
        }
    }
    
    @IBAction func NewGameButtonPressed(_ sender: UIButton) {
        // Reloads defaults in case there were changes
        Options.load()
        updateDiceImageViews()
        
        game.newGame()
        updateUI()
        localiseUI()

        showAlert(title: LocalisedUI.newGameTitle.translate(to: Options.language),
                  message: LocalisedUI.newGameMessage.translate(to: Options.language),
                  handler: {
                    if self.game.activePlayer.isAI {
                        self.nextMoveAsAI()
                    }
                  })
    }
    
    func nextMoveAsAI() {
        disableButtons()

        if game.activePlayer.isAI {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    let AIPlayer = self.game.activePlayer
                    
                    // Hold if previos thrown dice was 6
                    if AIPlayer.dice2 == nil && AIPlayer.roundHistory.last == 6 {
                        self.playHold()
                    }
                    
                    // Hold if already had won the game
                    if AIPlayer.roundScore + AIPlayer.totalScore >= Options.scoreLimit {
                        self.playHold()
                    }
                    
                    // Hold if above some random cap, otherwis throw
                    if AIPlayer.roundScore >= Int.random(in: 12...36) {
                        self.playHold()
                    } else {
                        self.playRoll()
                    }
                    
                    self.enableButtons()
                })
        }
    }
    
    @IBAction func OptionsButtonPressed(_ sender: Any) {
        self.present(optionsViewController, animated: true, completion: nil)
    }

    func showRollAlerts(_ dice: Int) {
        if dice == 1 {
            showAlert(title: LocalisedUI.threw1Title.translate(to: Options.language),
                      message: "\(game.activePlayer.name) \(LocalisedUI.threw1Message.translate(to: Options.language))",
                      handler: {
                        if self.game.activePlayer.isAI {
                            self.nextMoveAsAI()
                        }
                      })
        }
        
        if dice == 6 && game.activePlayer.roundHistory.last == 6 {
            showAlert(title: LocalisedUI.threw6TwiceTitle.translate(to: Options.language),
                      message: "\(game.activePlayer.name) \(LocalisedUI.threw6TwiceMessage.translate(to: Options.language))",
                      handler: {
                        if self.game.activePlayer.isAI {
                            self.nextMoveAsAI()
                        }
                      })
        }
    }
    
    func showRollAlerts(_ dice1: Int, _ dice2: Int) {
        if dice1 == 1 || dice2 == 1 {
            showAlert(title: LocalisedUI.threw1Title.translate(to: Options.language),
                      message: "\(game.activePlayer.name) \(LocalisedUI.threw1Message.translate(to: Options.language))",
                      handler: {
                        if self.game.activePlayer.isAI {
                            self.nextMoveAsAI()
                        }
                      })
        }
        
        if dice1 == 6 && dice2 == 6 {
            showAlert(title: LocalisedUI.threw6TwiceTitle.translate(to: Options.language),
                      message: "\(game.activePlayer.name) \(LocalisedUI.threw6TwiceMessage.translate(to: Options.language))",
                      handler: {
                        if self.game.activePlayer.isAI {
                            self.nextMoveAsAI()
                        }
                      })
        }
    }
    
    func playRoll() {
        // Game mechanics: roll, calculate scores, check conditions, display alerts
        let player = game.activePlayer
        player.rollTheDice()
        
        if Options.isSoundEnabled {
            playSound("dice_roll", type: "wav")
        }
        
        if game.gameType == .pigGame1Dice {
            guard let dice = game.activePlayer.dice1 else {
                print("Dice is nil")
                return
            }
            showRollAlerts(dice)
            game.pigGame(dice)
        }
        
        if game.gameType == .pigGame2Dice {
            guard let dice1 = game.activePlayer.dice1,
                  let dice2 = game.activePlayer.dice2 else {
                print("One of dice is nil")
                return
            }
            showRollAlerts(dice1, dice2)
            game.pigGame(dice1, dice2)
        }

        updateUI()
        
        // If the player did not change - consider a next move
        if player === game.activePlayer && game.activePlayer.isAI {
            nextMoveAsAI()
        }
    }
    
    @IBAction func RollButtonPressed(_ sender: UIButton) {
        playRoll()
    }
    
    func playHold() {
        // Hold current scores
        game.activePlayer.hold()

        // updateUI()
        
        if game.activePlayer.totalScore >= game.scoreLimit {
            showAlert(title: LocalisedUI.winnerTitle.translate(to: Options.language),
                      message: "\(game.activePlayer.name) \(LocalisedUI.winnerMessage.translate(to: Options.language)) \(game.activePlayer.totalScore)!",
                      handler: {
                        self.updateDiceImageViews()
                        self.game.newGame()
                      })
            return
        }
        
        game.nextPlayer()
        updateUI()
        
        if game.activePlayer.isAI {
            nextMoveAsAI()
        }
    }
    
    @IBAction func HoldButtonPressed(_ sender: UIButton) {
        playHold()
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
    func showAlert(title: String, message: String, handler: @escaping () -> Void) {
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
        CurrentScoreTitle.text = LocalisedUI.currentScoreTitle.translate(to: language)
        ScoreLimitTitle.text = LocalisedUI.scoreLimitTitle.translate(to: language)
        TotalScoresTitle.text = LocalisedUI.totalScoresTitle.translate(to: language)
        CurrentPlayerTitle.text = LocalisedUI.currentPlayerTitle.translate(to: language)
    }
        
    func updateUI() {
        // Show or Hide dice image at the beginning of each round or a new game
        if let dice1 = game.activePlayer.dice1 {
            dice1ImageView.image = diceArray[dice1 - 1]
        } else {
            dice1ImageView.image = nil
        }

        if game.gameType == .pigGame2Dice {
            if let dice2 = game.activePlayer.dice2 {
                dice2ImageView?.image = diceArray[dice2 - 1]
            } else {
                dice2ImageView?.image = nil
            }
        }
        
        ScoreLimitLabel.text = String(game.scoreLimit)
        CurrentPlayerLabel.text = game.activePlayer.name
        PlayerOneScoreLabel.text = "\(game.player1.name): \(game.player1.totalScore)"
        PlayerTwoScoreLabel.text = "\(game.player2.name): \(game.player2.totalScore)"
        CurrentScoreLabel.text = "\(game.activePlayer.roundScore)"
    }
}

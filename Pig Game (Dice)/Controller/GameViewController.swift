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
    // The second dice ImageView is instantiated depending on a type of game
    var dice2ImageView: UIImageView?
    
    var optionsViewController = OptionsViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // Save initial defaults if the game is launched for the first time
        Options.onFirstLaunch()
        Options.load()
        
        // Instantiate options for delegation
        optionsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "OptionsViewController")
        optionsViewController.optionsVCDelegate = self
           
        // Create dice Views depending on the type of game
        createDice1ImageView()
        if Options.gameType == .pigGame2Dice {
            createDice2ImageView()
        }
        
        game.newGame()
        localiseUI()
        updateUI()
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
    
    func removeSecondDiceImageView() {
        dice2ImageView?.removeFromSuperview()
        dice2ImageView = nil
    }
    
    @IBAction func NewGameButtonPressed(_ sender: UIButton) {
        // Reloads defaults in case there were changes
        Options.load()
        
        showAlert(title: LocalisedUI.newGameTitle.translate(to: Options.language),
                  message: LocalisedUI.newGameMessage.translate(to: Options.language))

        if Options.gameType == .pigGame2Dice && dice2ImageView == nil {
            createDice2ImageView()
        }
        
        if Options.gameType == .pigGame1Dice && dice2ImageView != nil {
            removeSecondDiceImageView()
        }
        
        game.newGame()
        localiseUI()
        updateUI()
    }
    
    @IBAction func OptionsButtonPressed(_ sender: Any) {
        self.present(optionsViewController, animated: true, completion: nil)
    }
    
    @IBAction func RollButtonPressed(_ sender: UIButton) {
        // Game mechanics: roll, calculate scores, check conditions, display alerts
        game.activePlayer.rollTheDice()
        
        if Options.isSoundEnabled {
                    playSound("dice_roll", type: "wav")
        }
        
        updateUI()
        
        if game.gameType == .pigGame1Dice {
            guard let dice = game.activePlayer.dice1 else {
                print("Dice is nil")
                return
            }
            
            if dice == 1 {
                showAlert(title: LocalisedUI.threw1Title.translate(to: Options.language),
                          message: "\(game.activePlayer.name) \(LocalisedUI.threw1Message.translate(to: Options.language))")
            }
            
            if dice == 6 && game.activePlayer.roundHistory.last == 6 {
                showAlert(title: LocalisedUI.threw6TwiceTitle.translate(to: Options.language),
                          message: "\(game.activePlayer.name) \(LocalisedUI.threw6TwiceMessage.translate(to: Options.language))")
            }
            game.pigGame(dice)
            
        } else if game.gameType == .pigGame2Dice {
            guard let dice1 = game.activePlayer.dice1,
                  let dice2 = game.activePlayer.dice2 else {
                print("One of dice is nil")
                return
            }
            
            if dice1 == 1 || dice2 == 1 {
                showAlert(title: LocalisedUI.threw1Title.translate(to: Options.language),
                          message: "\(game.activePlayer.name) \(LocalisedUI.threw1Message.translate(to: Options.language))")
            }
            
            if dice1 == 6 && dice2 == 6 {
                showAlert(title: LocalisedUI.threw6TwiceTitle.translate(to: Options.language),
                          message: "\(game.activePlayer.name) \(LocalisedUI.threw6TwiceMessage.translate(to: Options.language))")
            }
            game.pigGame(dice1, dice2)
        }
        updateUI()
    }
    
//    func ifAI() {
//        if game.activePlayer.isAI {
//            disableButtons()
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
//                game.playRound()
//                enableButtons()
//            }
//        }
//    }
    
    @IBAction func HoldButtonPressed(_ sender: UIButton) {
        // Hold current scores and change the active player
        game.activePlayer.hold()
        updateUI()
        
        if game.activePlayer.totalScore >= game.scoreLimit {
            showAlert(title: LocalisedUI.winnerTitle.translate(to: Options.language),
                      message: "\(game.activePlayer.name) \(LocalisedUI.winnerMessage.translate(to: Options.language)) \(game.activePlayer.totalScore)!")

            if Options.gameType == .pigGame2Dice && dice2ImageView == nil {
                createDice2ImageView()
            }
            
            if Options.gameType == .pigGame1Dice && dice2ImageView != nil {
                removeSecondDiceImageView()
            }

            game.newGame()
        }
                
        game.nextPlayer()
        updateUI()
    }
    
    @IBOutlet weak var NewGameButton: UIButton!
    @IBOutlet weak var RollButton: UIButton!
    @IBOutlet weak var HoldButton: UIButton!
    
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
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: LocalisedUI.alertActionTitle.translate(to: Options.language), style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }

//    func disableButton(_ button: UIButton) {
//        button.isEnabled = false
//        button.backgroundColor = .systemGray
//    }
//
//    func enableButton(_ button: UIButton) {
//        button.isEnabled = true
//        button.backgroundColor = Const.ButtonColor
//    }
//
//    func disableButtons() {
//        disableButton(RollButton)
//        disableButton(HoldButton)
//    }
//
//    func enableButtons() {
//        enableButton(RollButton)
//        enableButton(HoldButton)
//    }
            
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

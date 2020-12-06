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
        
    var optionsViewController = OptionsViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // Saves initial defaults if the game is launched for the first time
        Options.onFirstLaunch()
        Options.load()
        
        // Instantiate options VC in order for delegate to work
        optionsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "OptionsViewController")
        optionsViewController.optionsVCDelegate = self

        game.newGame()
        localiseUI()
        updateUI()
    }

    // Delegation func, to localise UI once the Options are saved
    func viewWillDimiss() {
        Options.load()
        localiseUI()
        print("Delegate method called")
    }
        
    @IBAction func NewGameButtonPressed(_ sender: UIButton) {
        // Reloads defaults in case there were changes
        Options.load()
        
        showAlert(title: LocalisedUI.newGameTitle.translate(to: Options.language),
                  message: LocalisedUI.newGameMessage.translate(to: Options.language))

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
        updateUI()
                    
        if game.activePlayer.dice == 1 {
            showAlert(title: LocalisedUI.threw1Title.translate(to: Options.language),
                      message: "\(game.activePlayer.name) \(LocalisedUI.threw1Message.translate(to: Options.language))")
        }
            
        if game.activePlayer.dice == 6 && game.activePlayer.roundHistory.last == 6 {
            showAlert(title: LocalisedUI.threw6TwiceTitle.translate(to: Options.language),
                      message: "\(game.activePlayer.name) \(LocalisedUI.threw6TwiceMessage.translate(to: Options.language))")
        }
        
        game.evalThrow()
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
        
        if game.activePlayer.totalScore >= Options.scoreLimit {
            updateUI()
            
            showAlert(title: LocalisedUI.winnerTitle.translate(to: Options.language),
                      message: "\(game.activePlayer.name) \(LocalisedUI.winnerMessage.translate(to: Options.language)) \(game.activePlayer.totalScore)!")
            game.newGame()
        }
                
        game.nextPlayer()
        updateUI()
    }
    
    @IBOutlet weak var NewGameButton: UIButton!
    @IBOutlet weak var RollButton: UIButton!
    @IBOutlet weak var HoldButton: UIButton!
    
    @IBOutlet weak var DiceImage: UIImageView!
    
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

    func disableButton(_ button: UIButton) {
        button.isEnabled = false
        button.backgroundColor = .systemGray
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
        // Localise buttons
        NewGameButton.setTitle(LocalisedUI.newGameButton.translate(to: Options.language), for: .normal)
        RollButton.setTitle(LocalisedUI.rollButton.translate(to: Options.language), for: .normal)
        HoldButton.setTitle(LocalisedUI.holdButton.translate(to: Options.language), for: .normal)
        
        // Localise text
        CurrentScoreTitle.text = LocalisedUI.currentScoreTitle.translate(to: Options.language)
        ScoreLimitTitle.text = LocalisedUI.scoreLimitTitle.translate(to: Options.language)
        TotalScoresTitle.text = LocalisedUI.totalScoresTitle.translate(to: Options.language)
        CurrentPlayerTitle.text = LocalisedUI.currentPlayerTitle.translate(to: Options.language)
    }
    
    func updateUI() {
        ScoreLimitLabel.text = String(game.scoreLimit)
        
        CurrentPlayerLabel.text = game.activePlayer.name
        PlayerOneScoreLabel.text = "\(game.player1.name): \(game.player1.totalScore)"
        PlayerTwoScoreLabel.text = "\(game.player2.name): \(game.player2.totalScore)"
        
        CurrentScoreLabel.text = "\(game.activePlayer.roundScore)"
        
        // Hide dice image at the beginning of each round or a new game
        if game.activePlayer.dice != nil {
            DiceImage.image = diceArray[game.activePlayer.dice! - 1]
        } else {
            DiceImage.image = nil
        }
    }
}

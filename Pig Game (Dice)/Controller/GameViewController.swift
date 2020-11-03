//
//  ViewController.swift
//  Pig Game (Dice)
//
//  Created by Denis Goloborodko on 10/8/20.
//

import UIKit

class GameViewController: UIViewController {
    
    let diceArray = [#imageLiteral(resourceName: "dice-1"), #imageLiteral(resourceName: "dice-2"), #imageLiteral(resourceName: "dice-3"), #imageLiteral(resourceName: "dice-4"), #imageLiteral(resourceName: "dice-5"), #imageLiteral(resourceName: "dice-6")]
    
    var game = Game()
    var options = Options()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                    
        game.newGame()
        updateUI()
    }
            
    @IBAction func NewGameButtonPressed(_ sender: UIButton) {
        showAlert(title: localization.newGameTitle, message: localization.newGameMessage)

        options.load()
        if options.localization == "En" {
            localization = Localization(locale: .En)
        } else if options.localization == "Ru" {
            localization = Localization(locale: .Ru)
        }

        game.newGame()
    }
    
    @IBAction func RollButtonPressed(_ sender: UIButton) {
        // Game mechanics: roll, calculate scores, check conditions, display alerts
        game.activePlayer.rollTheDice()
        game.calculateScores(game.activePlayer)
        
        updateUI()
        
        switch game.activePlayer.state {
        case .winner:
            showAlert(title: localization.winnerTitle, message: "\(game.activePlayer.name) \(localization.winnerMessage) \(game.activePlayer.totalScore + game.activePlayer.roundScore)!")
                game.newGame()
            
        case .threw1:
            showAlert(title: localization.threw1Title, message: "\(game.activePlayer.name) \(localization.threw1Message)")
            game.nextPlayer()
            game.activePlayer.newRound()
        
        case .threw6Twice:
            showAlert(title: localization.threw6TwiceTitle, message: "\(game.activePlayer.name) \(localization.threw6TwiceMessage)")
            game.nextPlayer()
            game.activePlayer.newRound()
        
        default:
            break
        }
    }
    
    @IBAction func HoldButtonPressed(_ sender: UIButton) {
        game.activePlayer.hold()
                
        game.nextPlayer()
        game.activePlayer.newRound()
        
        updateUI()
    }
    
    @IBOutlet weak var DiceImage: UIImageView!
    
    @IBOutlet weak var CurrentScoreLabel: UILabel!
    
    @IBOutlet weak var ScoreLimitLabel: UILabel!
    
    @IBOutlet weak var PlayerOneScoreLabel: UILabel!
    
    @IBOutlet weak var PlayerTwoScoreLabel: UILabel!
    
    @IBOutlet weak var CurrentPlayerLabel: UILabel!
        
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: localization.alertActionTitle, style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: updateUI)
    }
    
    func updateUI() {
        self.ScoreLimitLabel.text = String(game.scoreLimit)
        
        self.CurrentPlayerLabel.text = game.activePlayer.name
        self.PlayerOneScoreLabel.text = "\(game.player1.name): \(game.player1.totalScore)"
        self.PlayerTwoScoreLabel.text = "\(game.player2.name): \(game.player2.totalScore)"
        
        self.CurrentScoreLabel.text = "\(game.activePlayer.roundScore)"
        
        if game.activePlayer.dice != nil {
            self.DiceImage.image = diceArray[game.activePlayer.dice! - 1]
        } else {
            self.DiceImage.image = nil
        }
    }
}

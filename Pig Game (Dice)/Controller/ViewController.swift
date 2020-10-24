//
//  ViewController.swift
//  Pig Game (Dice)
//
//  Created by Denis Goloborodko on 10/8/20.
//

import UIKit

class ViewController: UIViewController {
    
    let diceArray = [#imageLiteral(resourceName: "dice-1"), #imageLiteral(resourceName: "dice-2"), #imageLiteral(resourceName: "dice-3"), #imageLiteral(resourceName: "dice-4"), #imageLiteral(resourceName: "dice-5"), #imageLiteral(resourceName: "dice-6")]
    
    var game = Game()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Call the func displaying a window where players can input their names
        showNameInputDialog(player1: game.player1, player2: game.player2)
    }
    
    @IBAction func RollButtonPressed(_ sender: UIButton) {
        // Game mechanics: roll, calculate scores, check conditions, display alerts
        game.activePlayer.rollTheDice()
        game.calculateScores(game.activePlayer)
        
        updateUI()
        
        switch game.activePlayer.state {
        case .winner:
            showAlert(title: "You have won!", message: "\(game.activePlayer.name) had won the game with total score \(game.activePlayer.totalScore + game.activePlayer.roundScore)!")
                game.newGame()
            
        case .threw1:
            showAlert(title: "You have lost this round!", message: "\(game.activePlayer.name) had thrown 1")
            game.nextPlayer()
            game.activePlayer.newRound()
        
        case .threw6Twice:
            showAlert(title: "Busted!", message: "\(game.activePlayer.name) had 6 thrown two times in a row, the total score is now zero")
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
    
    @IBOutlet weak var PlayerOneScoreLabel: UILabel!
    
    @IBOutlet weak var PlayerTwoScoreLabel: UILabel!
    
    @IBOutlet weak var CurrentPlayerLabel: UILabel!
    
    func showNameInputDialog(player1: Player, player2: Player) {
        let alertController = UIAlertController(title: "Players' Names?", message: "Enter your names:", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Enter", style: .default) {_ in 
            
            player1.name = alertController.textFields?[0].text ?? "Player 1"
            player2.name = alertController.textFields?[1].text ?? "Player 2"
            
            self.updateUI()
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Player One Name"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Player Two Name"
        }
        
        alertController.addAction(confirmAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: updateUI)
    }
    
    func updateUI() {
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

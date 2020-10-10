//
//  ViewController.swift
//  Pig Game (Dice)
//
//  Created by Denis Goloborodko on 10/8/20.
//

import UIKit

class ViewController: UIViewController {

    let diceArray = [#imageLiteral(resourceName: "dice1.png"), #imageLiteral(resourceName: "dice2"), #imageLiteral(resourceName: "dice3"), #imageLiteral(resourceName: "dice4"), #imageLiteral(resourceName: "dice5"), #imageLiteral(resourceName: "dice6")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        newGame()
        showNameInputDialog(players: players)
    }

    @IBAction func RollButtonPressed(_ sender: UIButton) {
        
        if activePlayer.totalScore >= K.scoreLimit {
            print("Player: \(activePlayer.name) wins!")
            
            showAlert(title: "You have won!", message: "\(activePlayer.name) had won the game with total score \(activePlayer.totalScore)!")
            newGame()
        }
        
        activePlayer.rollTheDice()
        activePlayer.calculateScores()
 
        updateUI()
        
        if activePlayer.score == 0 {
            if activePlayer.previousDice == 6 && activePlayer.currentDice == 6 {
                showAlert(title: "Busted!", message: "\(activePlayer.name) thrown 6 two times in a row, the total score is now zero.")
            } else if activePlayer.currentDice == 1 {
                showAlert(title: "You hove lost this round!", message: "\(activePlayer.name) has thrown 1.")
            }
            activePlayer = nextPlayer(players: players)
            activePlayer.newRound()
            
            updateUI()
        }
        
    }
    
    @IBAction func HoldButtonPressed(_ sender: UIButton) {
        activePlayer.hold()
        activePlayer = nextPlayer(players: players)
        activePlayer.newRound()
        
        updateUI()
    }
    
    @IBOutlet weak var DiceImage: UIImageView!
    
    @IBOutlet weak var CurrentScoreLabel: UILabel!
    
    @IBOutlet weak var TotalScoreLabel: UILabel!
    
    @IBOutlet weak var PlayerOneScoreLabel: UILabel!
    
    @IBOutlet weak var PlayerTwoScoreLabel: UILabel!
    
    @IBOutlet weak var CurrentPlayerLabel: UILabel!
    
    func showNameInputDialog(players: [Player]) {
        let alertController = UIAlertController(title: "Players' Names?", message: "Enter your names:", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
            
            players[0].name = alertController.textFields?[0].text ?? "Player 1"
            players[1].name = alertController.textFields?[1].text ?? "Player 2"
            
            self.updateUI()
        }
        
        //let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Player One Name"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Player Two Name"
        }
        
        alertController.addAction(confirmAction)
        
        //alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func updateUI() {
        self.CurrentPlayerLabel.text = activePlayer.name
        self.PlayerOneScoreLabel.text = "\(players[0].name): \(players[0].totalScore)"
        self.PlayerTwoScoreLabel.text = "\(players[1].name): \(players[1].totalScore)"
        
        self.CurrentScoreLabel.text = "Current Score: \(activePlayer.score)"
        
        if activePlayer.currentDice != nil {
            self.DiceImage.image = diceArray[activePlayer.currentDice! - 1]
        } else {
            self.DiceImage.image = nil
        }
    }
}


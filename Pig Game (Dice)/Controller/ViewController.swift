//
//  ViewController.swift
//  Pig Game (Dice)
//
//  Created by Denis Goloborodko on 10/8/20.
//

import UIKit

class ViewController: UIViewController {

    let diceArray = [#imageLiteral(resourceName: "dice1.png"), #imageLiteral(resourceName: "dice2"), #imageLiteral(resourceName: "dice3"), #imageLiteral(resourceName: "dice4"), #imageLiteral(resourceName: "dice5"), #imageLiteral(resourceName: "dice6")]
    let players = [Player(name: "Player1"), Player(name: "Player2")]
    
    lazy var activePlayer = chooseRandomPlayer(players: players)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }

    @IBAction func RollButtonPressed(_ sender: UIButton) {
        let rolledDice = activePlayer.rollTheDice()
        
        activePlayer.calculateScores(rolledDice)
        
        if activePlayer.totalScore == 0 {
            print("Вы выбросили 6x2 - все очки сгорели, переход хода")
        } else if activePlayer.currentScore == 0 {
            print("Вы выбросили 1 - текущие очки сгорели, переход хода")
        }
        
        activePlayer.previousDice = rolledDice
        updateUI()
    }
    
    @IBAction func HoldButtonPressed(_ sender: UIButton) {
        activePlayer.hold()
        activePlayer.previousDice = nil
        updateUI()
    }
    
    @IBOutlet weak var DiceImage: UIImageView!
    
    @IBOutlet weak var CurrentScoreLabel: UILabel!
    
    @IBOutlet weak var TotalScoreLabel: UILabel!
    
    @IBOutlet weak var CurrentPlayerLabel: UILabel!
    
    
    func updateUI() {
        self.CurrentPlayerLabel.text = activePlayer.name
        self.TotalScoreLabel.text = "Total Score: \(activePlayer.totalScore)"
        self.CurrentScoreLabel.text = "Current Score: \(activePlayer.currentScore)"
        if activePlayer.previousDice != nil {
            self.DiceImage.image = diceArray[activePlayer.previousDice! - 1]
        } else {
            self.DiceImage.image = nil
        }
    }
}


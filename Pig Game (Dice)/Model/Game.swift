//
//  DiceGameModel.swift
//  Pig Game (Dice)
//
//  Created by Denis Goloborodko on 10/8/20.
//

import Foundation

struct Game {
    var player1 = Player(name: Const.DefaultPlayer1Name, isAI: false)
    var player2 = Player(name: Const.DefaultPlayer2Name, isAI: true)
    lazy var activePlayer = randomPlayer()
    
    var scoreLimit = Const.DefaultScoreLimit
    
    // Returns a random player
    func randomPlayer() -> Player {
        if Int.random(in: 1...2) == 1  {
            return player1
        } else {
            return player2
        }
    }

    // Sets the next player
    mutating func nextPlayer() {
        // switch players
        if activePlayer === player1 {
            activePlayer = player2
        } else {
            activePlayer = player1
        }
        
        // Clear current score and round history
        activePlayer.newRound()
    }
 
    mutating func evalThrow() {
        guard let dice = activePlayer.dice else {
            print("Error - dice is nil")
            return
        }
        
        switch dice {
        case 1:
            nextPlayer()
        case 2, 3, 4, 5:
            activePlayer.roundHistory.append(dice)
            activePlayer.roundScore += dice
        case 6:
            if activePlayer.roundHistory.last == 6 {
                activePlayer.totalScore = 0
                nextPlayer()
            } else {
                activePlayer.roundHistory.append(6)
                activePlayer.roundScore += 6
            }
        default:
            print("Invalid dice score")
        }
    }

//    // Round played by AI
//    mutating func playRound() {
//        activePlayer.AINextMove()
//
//        // REMOVE:
//        print(activePlayer.dice)
//
//            activePlayer.setState(limit: scoreLimit)
//        }
//
//        if activePlayer.state != .winner {
//            activePlayer.newRound()
//            nextPlayer()
//        }
//    }
    
    // Init a new game with the player's names and score limit retreived from the defaults
    mutating func newGame() {
        player1 = Player(name: Options.player1Name, isAI: false)
        player2 = Player(name: Options.player2Name, isAI: true)
        
        scoreLimit = Options.scoreLimit

        activePlayer = randomPlayer()
    }
}

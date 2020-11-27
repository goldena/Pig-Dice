//
//  DiceGameModel.swift
//  Pig Game (Dice)
//
//  Created by Denis Goloborodko on 10/8/20.
//

import Foundation

struct Game {
    var player1 = Player(name: "Player1")
    var player2 = Player(name: "Player2")
    lazy var activePlayer = chooseRandomPlayer()
    
    // Defaut score limit of the game
    var scoreLimit = 100
    
    // Returns a random player
    func chooseRandomPlayer() -> Player {
        if Int.random(in: 1...2) == 1  {
            return player1
        } else {
            return player2
        }
    }
  
    // Calculate scores ans set game states
    func calculateScores(_ player: Player) {
        guard let dice = player.dice else {
            print("Error - die was not thrown")
            return
        }

        // Add scores on the dice to the current player scores
        player.roundScore += dice
        
        switch dice {
        // If one is thrown zero player's current round score, switch active player
        case 1:
            player.state = .threw1
            player.roundScore = 0
        case 2, 3, 4, 5:
            player.state = .playing
        case 6:
            // Zero player's current and total scores if 6 was thrown twice
            if player.state == .threw6 {
                player.state = .threw6Twice
                player.totalScore = 0
                player.roundScore = 0
            } else {
                // Set the state if 6 was thrown the first time
                player.state = .threw6
            }
        default:
            print("Invalid score on the dice to be evaluated")
        }
        
        // Check winning condition
        if player.roundScore + player.totalScore >= scoreLimit {
            player.state = .winner
        }
    }

    // Sets the next player
    mutating func nextPlayer() {
        if activePlayer === player1 {
            activePlayer = player2
        } else {
            activePlayer = player1
        }
    }
    
    // Init a new game with the player's names and score limit retreived from the defaults
    mutating func newGame() {
        player1 = Player(name: Options.player1Name)
        player2 = Player(name: Options.player2Name)
        scoreLimit = Options.scoreLimit

        activePlayer = chooseRandomPlayer()
    }
}

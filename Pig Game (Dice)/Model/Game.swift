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
  
    mutating func loadOptions() {
        Options.load()
        
        player1.name = Options.player1Name
        player2.name = Options.player2Name
        scoreLimit = Options.scoreLimit
    }

    // Calculate scores ans set corresponding states
    func calculateScores(_ player: Player) {
        // Zero player's current round score if 1 is thrown
        if player.dice == 1 {
            player.state = .threw1
            player.roundScore = 0
            return
        }

        // Zero player's total score if 6 was thrown twice
        if player.state == .threw6 && player.dice == 6 {
                player.state = .threw6Twice
                player.totalScore = 0
                player.roundScore = 0
                return
        }
        
        // Set the status if 6 was thrown first time
        if player.state == .playing && player.dice == 6 {
            player.state = .threw6
        }
                
        // Add the thrown dice to current score if neither of above
        player.roundScore += player.dice!
        
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
    
    // Reinitiates the game with the previous player's names
    mutating func newGame() {
        player1 = Player(name: Options.player1Name)
        player2 = Player(name: Options.player2Name)
        
        activePlayer = chooseRandomPlayer()
    }
}

//
//  DiceGameModel.swift
//  Pig Dice Game
//
//  Created by Denis Goloborodko on 10/8/20.
//

import Foundation

struct Game {
    
    // MARK: - Property(s)
    
    var player1 = Player(name: Options.player1Name, isAI: false)
    var player2 = Player(name: Options.player2Name, isAI: Options.is2ndPlayerAI)
    
    lazy var activePlayer = randomPlayer()
    
    var gameType = Options.gameType
    var scoreLimit = Options.scoreLimit
    
    // MARK: - Method(s)
    
    // Returns a random player
    func randomPlayer() -> Player {
        Bool.random() ? player1 : player2
    }
    
    // Clear state and switch to the next player
    mutating func nextPlayer() {
        activePlayer.clearStateAfterRound()
        
        if activePlayer === player1 {
            activePlayer = player2
        } else {
            activePlayer = player1
        }
    }
    
    // Score calculation for the Pig Game with one dice
    mutating func calculateScores(_ dice: Int) {
        let player = activePlayer
        
        switch dice {
        case 1:
            player.roundScore = 0

        case 6:
            if player.previousDice == 6 {
                player.roundScore = 0
                player.totalScore = 0
            } else {
                fallthrough
            }
            
        default:
            player.roundScore += dice
        }
    }
    
    // Score calculation for the Pig Game with two dice
    mutating func calculateScores(_ dice1: Int, _ dice2: Int) {
        let player = activePlayer
        
        switch (dice1, dice2) {
        case (1, _), (_, 1):
            player.roundScore = 0

        case (6, 6):
            player.roundScore = 0
            player.totalScore = 0

        default:
            player.roundScore += dice1 + dice2
        }
    }
    
    // Init a new game with the player's names and score limit retrieved from the defaults
    mutating func initNewGame() {
        player1         = Player(name: Options.player1Name, isAI: false)
        player2         = Player(name: Options.player2Name, isAI: Options.is2ndPlayerAI)
        activePlayer    = randomPlayer()
        
        gameType    = Options.gameType
        scoreLimit  = Options.scoreLimit
    }
}

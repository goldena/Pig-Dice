//
//  DiceGameModel.swift
//  Pig Game (Dice)
//
//  Created by Denis Goloborodko on 10/8/20.
//

import Foundation

struct Game {
    var player1 = Player(name: Const.DefaultPlayer1Name, isAI: false)
    var player2 = Player(name: Const.DefaultPlayer2Name, isAI: Const.Is2ndPlayerAI)
    lazy var activePlayer = randomPlayer()
    
    var gameType = Options.gameType
    var scoreLimit = Options.scoreLimit
    
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
        activePlayer.clearRound()
        
        // switch players
        if activePlayer === player1 {
            activePlayer = player2
        } else {
            activePlayer = player1
        }
    }
    
    // Rules of score calculation for the Pig Game with one dice
    mutating func pigGameCalculateScores(_ dice: Int) {
        let player = activePlayer
        
        switch dice {
        case 6:
            if player.previousDiceIs6 {
                player.totalScore = 0
                player.roundScore = 0
            } else {
                player.roundScore += 6
            }
        case 1:
            player.roundScore = 0
        default:
            player.roundScore += dice
        }
    }
    
    // Rules of score calculation for the Pig Game with two dice
    mutating func pigGameCalculateScores(_ dice1: Int, _ dice2: Int) {
        let player = activePlayer
        
        switch (dice1, dice2) {
        case (6, 6):
            player.totalScore = 0
            player.roundScore = 0
        case (1, _), (_, 1):
            player.roundScore = 0
        default:
            player.roundScore += dice1 + dice2
        }
    }
    
    // Init a new game with the player's names and score limit retreived from the defaults
    mutating func initNewGame() {
        player1 = Player(name: Options.player1Name, isAI: false)
        player2 = Player(name: Options.player2Name, isAI: Options.is2ndPlayerAI)
        
        gameType = Options.gameType
        scoreLimit = Options.scoreLimit
        
        activePlayer = randomPlayer()
    }
}

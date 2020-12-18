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
        // switch players
        if activePlayer === player1 {
            activePlayer = player2
        } else {
            activePlayer = player1
        }
        
        // Clear current score and round history
        activePlayer.newRound()
    }
 
    // Rules of score calculation for the Pig Game with one dice
    mutating func pigGame(_ dice: Int) {        
        switch dice {
        case 6:
            if activePlayer.roundHistory.last == 6 {
                activePlayer.totalScore = 0
                nextPlayer()
            } else {
                activePlayer.roundHistory.append(6)
                activePlayer.roundScore += 6
            }
        case 1:
            nextPlayer()
        default:
            activePlayer.roundHistory.append(dice)
            activePlayer.roundScore += dice
        }
    }
    
    // Rules of score calculation for the Pig Game with two dice
    mutating func pigGame(_ dice1: Int, _ dice2: Int) {
        switch (dice1, dice2) {
        case (1, _), (_, 1):
            nextPlayer()
        case (6, 6):
            activePlayer.totalScore = 0
            nextPlayer()
        default:
            // Round history is not used anywhere yet for this type of game
            activePlayer.roundHistory.append(dice1)
            activePlayer.roundHistory.append(dice2)
            activePlayer.roundScore += dice1 + dice2
        }
    }
           
    // Init a new game with the player's names and score limit retreived from the defaults
    mutating func newGame() {
        player1 = Player(name: Options.player1Name, isAI: false)
        player2 = Player(name: Options.player2Name, isAI: true)
        
        gameType = Options.gameType
        scoreLimit = Options.scoreLimit

        activePlayer = randomPlayer()
    }
}

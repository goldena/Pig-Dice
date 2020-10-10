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

    var scoreLimit = 10
    
    mutating func chooseRandomPlayer() -> Player {
        if Int.random(in: 1...2) == 1  {
            return player1
        } else {
            return player2
        }
    }
    
    mutating func nextPlayer() {
        if activePlayer === player1 {
            activePlayer = player2
        } else {
            activePlayer = player1
        }
    }
    
    mutating func newGame() {
        player1 = Player(name: "Player1")
        player2 = Player(name: "Player2")
        activePlayer = chooseRandomPlayer()
    }
}

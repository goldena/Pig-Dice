//
//  DiceGameModel.swift
//  Pig Game (Dice)
//
//  Created by Denis Goloborodko on 10/8/20.
//

import Foundation

struct Game {
//    var player1 = Player(name: "Player1")
//    var player2 = Player(name: "Player2")
//    lazy var activePlayer = player1
    var player1: Player
    var player2: Player
    lazy var activePlayer = player1

    var scoreLimit = 100
    
    mutating func chooseRandomPlayer() {
        if Int.random(in: 1...2) == 1  {
            activePlayer = player1
        } else {
            activePlayer = player2
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
        
        chooseRandomPlayer()
    }
}

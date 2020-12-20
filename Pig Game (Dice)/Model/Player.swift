//
//  Player.swift
//  Pig Game (Dice)
//
//  Created by Denis Goloborodko on 10/9/20.
//

import Foundation

class Player {
    var name: String
    var isAI: Bool

    var totalScore = 0
    var roundScore = 0
    var dice1: Int? = nil
    var dice2: Int? = nil
    var previousDiceIs6: Bool = false
    
    func rollDice() {
        dice1 = Int.random(in: 1...6)
        dice2 = Int.random(in: 1...6)
    }
        
    func holdRoundScore() {
        totalScore += roundScore
    }
    
    func clearRound() {
        roundScore = 0
        previousDiceIs6 = false
        dice1 = nil
        dice2 = nil
    }
         
    init(name: String, isAI: Bool) {
        self.name = name
        self.isAI = isAI
    }
}

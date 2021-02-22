//
//  Player.swift
//  Pig Dice Game
//
//  Created by Denis Goloborodko on 10/9/20.
//

import Foundation

class Player {

    // MARK: - Property(s)
    
    var name: String
    var isAI: Bool

    var totalScore = 0
    var roundScore = 0
    
    var dice1: Int? = nil
    var dice2: Int? = nil
    var previousDice: Int? = nil
    
    // MARK: - Method(s)
    
    func rollDice() {
        previousDice = dice1
            
        dice1 = Int.random(in: 1...6)
        dice2 = Int.random(in: 1...6)
    }
        
    func holdRoundScore() {
        totalScore += roundScore
        
        clearStateAfterRound()
    }
    
    func clearStateAfterRound() {
        roundScore = 0
        dice1 = nil
        dice2 = nil
        previousDice = nil
    }

    init(name: String, isAI: Bool) {
        self.name = name
        self.isAI = isAI
    }
}

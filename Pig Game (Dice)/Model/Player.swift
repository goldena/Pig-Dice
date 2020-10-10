//
//  Player.swift
//  Pig Game (Dice)
//
//  Created by Denis Goloborodko on 10/9/20.
//

import Foundation

class Player {
    var name: String
    
    var score = 0
    var totalScore = 0
    var previousDice: Int? = nil
    var currentDice: Int? = nil
    
    func rollTheDice() {
        if currentDice != nil {
            previousDice = currentDice
        }
        currentDice = Int.random(in: 1...6)
    }

    func calculateScores() {
        if previousDice != nil {
            if previousDice == 6 && currentDice == 6 {
                totalScore = 0
                score = 0
                return
            }
        }
        
        if currentDice == 1 {
            score = 0
            return
        }
        
        score += currentDice!
    }
    
    func hold() {
        totalScore += score
    }
    
    func newRound() {
        score = 0
        previousDice = nil
        currentDice = nil
    }
    
    init(name: String) {
        self.name = name
    }
}

//
//  DiceGameModel.swift
//  Pig Game (Dice)
//
//  Created by Denis Goloborodko on 10/8/20.
//

import Foundation

struct K {
    let scoreLimit = 100
}

class Player {
    var name: String
    
    var currentScore = 0
    var totalScore = 0
    var previousDice: Int? = nil
    
    func rollTheDice() -> Int {
        return Int.random(in: 1...6)
    }

    func calculateScores(_ currentDice: Int) {
        if previousDice != nil {
            if previousDice == 6 && currentDice == 6 {
                totalScore = 0
                currentScore = 0
                return
            }
        }
        
        if currentDice == 1 {
            totalScore += currentScore
            currentScore = 0
            return
        }
        
        currentScore += currentDice
    }
    
    func hold() {
        totalScore += currentScore
        currentScore = 0
    }
    
    init(name: String) {
        self.name = name
    }
}

func chooseRandomPlayer(players: [Player]) -> Player {
    let randomIndex = Int.random(in: 0...players.count - 1)
    return players[randomIndex]
}

    

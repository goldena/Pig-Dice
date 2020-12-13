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
    var roundHistory: [Int] = []
    
    func rollTheDice() {
        dice1 = Int.random(in: 1...6)
        dice2 = Int.random(in: 1...6)
    }
        
    func hold() {
        totalScore += roundScore
    }
    
    func newRound() {
        roundScore = 0
        roundHistory = []
        dice1 = nil
        dice2 = nil
    }
 
    // Used when the second player is played by computer
    func AINextMove() -> () {
        if roundHistory.last == 6 {
            return hold()
        }
        
        if roundScore + totalScore >= Options.scoreLimit {
            return hold()
        }
        
        if roundScore <= Int.random(in: 12...24) {
            return rollTheDice()
        } else {
            return self.hold()
        }
    }
    
    init(name: String, isAI: Bool) {
        self.name = name
        self.isAI = isAI
    }
}

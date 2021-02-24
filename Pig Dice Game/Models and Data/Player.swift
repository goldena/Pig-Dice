//
//  Player.swift
//  Pig Dice Game
//
//  Created by Denis Goloborodko on 10/9/20.
//

import Foundation

final class Player {

    // MARK: - Property(s)
    
    private(set) var name: String
    private(set) var isAI: Bool

    private(set) var totalScore = 0
    private(set) var roundScore = 0
    
    private(set) var dice1: Int?
    private(set) var dice2: Int?
    private(set) var previousDice: Int?
    
    // MARK: - Method(s)
    
    func rollDice() {
        previousDice = dice1
            
        dice1 = Int.random(in: 1...6)
        dice2 = Int.random(in: 1...6)
    }
       
    func addRoundScore(_ score: Int) {
        roundScore += score
    }
    
    func holdRoundScore() {
        totalScore += roundScore
        clearRoundScore()
    }
    
    func clearRoundScore() {
        roundScore = 0
    }
    
    func clearTotalScore() {
        totalScore = 0
    }
    
    func clearStateAfterRound() {
        dice1 = nil
        dice2 = nil
        previousDice = nil
        
        clearRoundScore()
    }

    init(name: String, isAI: Bool) {
        self.name = name
        self.isAI = isAI
    }
}

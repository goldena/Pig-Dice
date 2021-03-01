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

    func rollOrHold(if otherPlayerRoundScore: Int) -> Bool {
        // Hold if already had won the game
        if roundScore + totalScore >= Options.scoreLimit {
            return false
        }
        
        // Hold if the throw was 6 (for a one dice game), total score and round score above 10
        if Options.gameType == .PigGame1Dice && dice1 == 6 {
            if roundScore <= 10 && totalScore <= 10 {
                return true
            } else {
                return false
            }
        }
             
        // If other player is close to winning the game, risk more
        var minAcceptableRisk: Int {
            if Options.scoreLimit - otherPlayerRoundScore <= 25 {
                return Options.scoreLimit - otherPlayerRoundScore
            } else {
                return 16
            }
        }
        
        // If 50+ points ahead of other player - don't risk
        var maxAcceptableRisk: Int {
            if otherPlayerRoundScore - roundScore > 50 {
                return Int(Double(minAcceptableRisk) * 1.1)
            } else {
                return Int(Double(minAcceptableRisk) * 1.5)
            }
        }
        
        // Add minimal randomization to AI
        if roundScore >= Int.random(in: minAcceptableRisk...maxAcceptableRisk) {
            return false
        } else {
            return true
        }
    }
      
    // MARK: - Initializer(s)
    
    init(name: String, isAI: Bool) {
        self.name = name
        self.isAI = isAI
    }
}

//
//  Player.swift
//  Pig Game (Dice)
//
//  Created by Denis Goloborodko on 10/9/20.
//

import Foundation

enum PlayerState {
    case playing
    case threw1
    case threw6
    case threw6Twice
    case winner
}

class Player {
    var name: String

    var totalScore = 0
    var roundScore = 0
    var dice: Int? = nil
    var state = PlayerState.playing
    
    func rollTheDice() {
        dice = Int.random(in: 1...6)
    }
    
    func hold() {
        totalScore += roundScore
    }
    
    func newRound() {
        roundScore = 0
        dice = nil
        state = .playing
    }
    
    init(name: String) {
        self.name = name
    }
}

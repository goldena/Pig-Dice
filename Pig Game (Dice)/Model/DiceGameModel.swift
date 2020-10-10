//
//  DiceGameModel.swift
//  Pig Game (Dice)
//
//  Created by Denis Goloborodko on 10/8/20.
//

import Foundation

struct K {
    static let scoreLimit = 100
    static let numberOfPlayers = 2
}

var players = [Player(name: "Player1"), Player(name: "Player2")]
var activePlayer = chooseRandomPlayer(players: players)

func newGame() {
    players = [Player(name: "Player1"), Player(name: "Player2")]    
    activePlayer = chooseRandomPlayer(players: players)
}

func endGame() {
    
}

func chooseRandomPlayer(players: [Player]) -> Player {
    let randomIndex = Int.random(in: 0...players.count - 1)
    players[randomIndex].isActive = true
    return players[randomIndex]
}

func nextPlayer(players: [Player]) -> Player {
    var i = 0
    
    while players[i].isActive != true {
        i += 1
    }

    players[i].isActive = false

    if i == players.count - 1 {
        players[0].isActive = true
        return players[0]
    } else {
        players[i + 1].isActive = true
        return players[i + 1]
    }
}

    

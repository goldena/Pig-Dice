//
//  PlistInterface.swift
//  Pig Game (Dice)
//
//  Created by Denis Goloborodko on 11/1/20.
//

import Foundation

class Options {
    let options = UserDefaults.standard
        
    var player1Name: String = "Player1"
    var player2Name: String = "Player2"
    var scoreLimit: Int = 100
    
    var localization: String = "En"
    
    func load() {
        if let localization = options.string(forKey: "Localization") {
            self.localization = localization
        }
        
        if let player1Name = options.string(forKey: "Player1Name") {
            self.player1Name = player1Name
        }
        
        if let player2Name = options.string(forKey: "Player2Name") {
            self.player2Name = player2Name
        }
        
        self.scoreLimit = options.integer(forKey: "ScoreLimit")
    }
    
    func save() {
        self.options.set(self.localization, forKey: "Localization")
        self.options.set(self.player1Name, forKey: "Player1Name")
        self.options.set(self.player2Name, forKey: "Player2Name")
        self.options.set(self.scoreLimit, forKey: "ScoreLimit")
    }
}

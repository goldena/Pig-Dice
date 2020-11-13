//
//  PlistInterface.swift
//  Pig Game (Dice)
//
//  Created by Denis Goloborodko on 11/1/20.
//

import Foundation

class Options {
    static let userDefaults = UserDefaults.standard
        
    static var player1Name: String = "Player1"
    static var player2Name: String = "Player2"
    static var scoreLimit: Int = 100
    
    static var localization: String = "En"
    
    static func load() {
        if let localization = userDefaults.string(forKey: "Localization") {
            Options.localization = localization
        }
        
        if let player1Name = userDefaults.string(forKey: "Player1Name") {
            Options.player1Name = player1Name
        }
        
        if let player2Name = userDefaults.string(forKey: "Player2Name") {
            Options.player2Name = player2Name
        }
        
        Options.scoreLimit = userDefaults.integer(forKey: "ScoreLimit")
    }
    
    static func save() {
        Options.userDefaults.set(Options.localization, forKey: "Localization")
        Options.userDefaults.set(Options.player1Name, forKey: "Player1Name")
        Options.userDefaults.set(Options.player2Name, forKey: "Player2Name")
        Options.userDefaults.set(Options.scoreLimit, forKey: "ScoreLimit")
    }
}

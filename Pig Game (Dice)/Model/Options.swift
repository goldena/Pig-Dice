//
//  PlistInterface.swift
//  Pig Game (Dice)
//
//  Created by Denis Goloborodko on 11/1/20.
//

import Foundation

class Options {
    static let userDefaults = UserDefaults.standard
    
    // Default values for the first launch of the game
    static var player1Name: String = "Player1"
    static var player2Name: String = "Player2"
    static var scoreLimit: Int = 100
    static var language: Language = .En
    
    // If the app is launched for the first time, then save defaults
    static func onFirstLaunch() {
        if userDefaults.bool(forKey: "FirstLaunch") == false {
            Options.save()
        }
    }
    
    // Loads defaults
    static func load() {
        if let language = userDefaults.string(forKey: "Language") {
            Options.language = Language.init(rawValue: language) ?? .En
        }
        
        if let player1Name = userDefaults.string(forKey: "Player1Name") {
            Options.player1Name = player1Name
        }
        
        if let player2Name = userDefaults.string(forKey: "Player2Name") {
            Options.player2Name = player2Name
        }
        
        Options.scoreLimit = userDefaults.integer(forKey: "ScoreLimit")
    }
    
    // Saves defaults
    static func save() {
        Options.userDefaults.set(true, forKey: "FirstLaunch")
        Options.userDefaults.set(Options.language.rawValue, forKey: "Language")
        Options.userDefaults.set(Options.player1Name, forKey: "Player1Name")
        Options.userDefaults.set(Options.player2Name, forKey: "Player2Name")
        Options.userDefaults.set(Options.scoreLimit, forKey: "ScoreLimit")
    }
}

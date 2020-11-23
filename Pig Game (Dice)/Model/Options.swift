//
//  PlistInterface.swift
//  Pig Game (Dice)
//
//  Created by Denis Goloborodko on 11/1/20.
//

import Foundation

class Options {
    static let userDefaults = UserDefaults.standard
        
    static var firstLaunch: Bool = false
    
    static var player1Name: String = "Player1"
    static var player2Name: String = "Player2"
    static var scoreLimit: Int = 100
    
    static var language: String = "En"
    
    static func onFirstLaunch() {
        if userDefaults.bool(forKey: "FirstLaunch") == false {
            Options.save()
        }
    }
    
    static func load() {
        
        if let language = userDefaults.string(forKey: "Language") {
            Options.language = language
            currentLanguage = Language.init(rawValue: language) ?? .En
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
        Options.userDefaults.set(true, forKey: "FirstLaunch")
        Options.userDefaults.set(Options.language, forKey: "Language")
        Options.userDefaults.set(Options.player1Name, forKey: "Player1Name")
        Options.userDefaults.set(Options.player2Name, forKey: "Player2Name")
        Options.userDefaults.set(Options.scoreLimit, forKey: "ScoreLimit")
    }
}

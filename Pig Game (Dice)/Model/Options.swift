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
    static var player1Name: String = Const.DefaultPlayer1Name
    static var player2Name: String = Const.DefaultPlayer2Name
    static var typeOfGame: TypeOfGame = Const.DefaultTypeOfGame
    static var scoreLimit: Int = Const.DefaultScoreLimit
    static var language: Language = Const.DefaultLanguage
    
    // If the app is launched for the first time, then save defaults
    static func onFirstLaunch() {
        if userDefaults.bool(forKey: "DefaultsSaved") == false {
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
        
        // NOTE: Bring back 1 dice game default
        if let typeOfGame = userDefaults.string(forKey: "TypeOfGame") {
            Options.typeOfGame = TypeOfGame.init(rawValue: typeOfGame) ?? .pigGame1Dice
        }
                
        Options.scoreLimit = userDefaults.integer(forKey: "ScoreLimit")
    }
    
    // Saves defaults
    static func save() {
        Options.userDefaults.set(true, forKey: "DefaultsSaved")
        Options.userDefaults.set(Options.language.rawValue, forKey: "Language")
        Options.userDefaults.set(Options.player1Name, forKey: "Player1Name")
        Options.userDefaults.set(Options.player2Name, forKey: "Player2Name")
        Options.userDefaults.set(Options.typeOfGame.rawValue, forKey: "TypeOfGame")
        Options.userDefaults.set(Options.scoreLimit, forKey: "ScoreLimit")
    }
}

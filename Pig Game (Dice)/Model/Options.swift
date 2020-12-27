//
//  PlistInterface.swift
//  Pig Game (Dice)
//
//  Created by Denis Goloborodko on 11/1/20.
//

import Foundation

class Options {
    private static let userDefaults = UserDefaults.standard
    
    // Default values for the first launch of the game
    static var language: Language       = Const.DefaultLanguage
    static var isSoundEnabled: Bool     = Const.DefaultIsSoundEnabled
    static var isVibrationEnabled: Bool = Const.DefaultIsSoundEnabled
    static var colorMode: ColorMode     = Const.DefaultColorMode

    static var player1Name: String  = Const.DefaultPlayer1Name
    static var player2Name: String  = Const.DefaultPlayer2Name
    static var is2ndPlayerAI: Bool  = Const.Is2ndPlayerAI

    static var gameType: GameType   = Const.DefaultTypeOfGame
    static var scoreLimit: Int      = Const.DefaultScoreLimit
    
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
        if let colorMode = userDefaults.string(forKey: "ColorMode") {
            Options.colorMode = ColorMode.init(rawValue: colorMode) ?? .System
        }
        Options.isSoundEnabled = userDefaults.bool(forKey: "IsSoundEnabled")
        Options.isVibrationEnabled = userDefaults.bool(forKey: "IsVibrationEnabled")
        
        if let player1Name = userDefaults.string(forKey: "Player1Name") {
            Options.player1Name = player1Name
        }
        if let player2Name = userDefaults.string(forKey: "Player2Name") {
            Options.player2Name = player2Name
        }

        Options.is2ndPlayerAI = userDefaults.bool(forKey: "Is2ndPlayerAI")
        
        if let typeOfGame = userDefaults.string(forKey: "GameType") {
            Options.gameType = GameType.init(rawValue: typeOfGame) ?? .PigGame1Dice
        }
        Options.scoreLimit = userDefaults.integer(forKey: "ScoreLimit")
    }
    
    // Saves defaults
    static func save() {
        Options.userDefaults.set(true, forKey: "DefaultsSaved")

        Options.userDefaults.set(Options.language.rawValue,     forKey: "Language")
        Options.userDefaults.set(Options.isSoundEnabled,        forKey: "IsSoundEnabled")
        Options.userDefaults.set(Options.isVibrationEnabled,    forKey: "IsVibrationEnabled")
        Options.userDefaults.set(Options.colorMode.rawValue,    forKey: "ColorMode")

        Options.userDefaults.set(Options.player1Name,   forKey: "Player1Name")
        Options.userDefaults.set(Options.player2Name,   forKey: "Player2Name")
        Options.userDefaults.set(Options.is2ndPlayerAI, forKey: "Is2ndPlayerAI")

        Options.userDefaults.set(Options.gameType.rawValue, forKey: "GameType")
        Options.userDefaults.set(Options.scoreLimit,        forKey: "ScoreLimit")
    }
}

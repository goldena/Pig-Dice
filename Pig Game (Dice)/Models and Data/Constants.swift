//
//  Constants.swift
//  Pig Game (Dice)
//
//  Created by Denis Goloborodko on 30.11.20.
//

import UIKit

enum GameType: String {
    case PigGame1Dice = "PigGame1Dice"
    case PigGame2Dice = "PigGame2Dice"
}

enum ColorMode: String {
    case Light  = "Light"
    case Dark   = "Dark"
    case System = "System"
}

struct Const {
    // Assets
    static let DiceFaces = [#imageLiteral(resourceName: "dice-1"), #imageLiteral(resourceName: "dice-2"), #imageLiteral(resourceName: "dice-3"), #imageLiteral(resourceName: "dice-4"), #imageLiteral(resourceName: "dice-5"), #imageLiteral(resourceName: "dice-6")]
    
    // Game
    static let DefaultScoreLimit        = 100
    static let DelayForCompPlayerMove   = 2.0
    
    // Interface
    static let DefaultPlayer1Name           = "Player1"
    static let DefaultPlayer2Name           = "Player2"
    static let Is2ndPlayerAI                = true
    static let DefaultTypeOfGame: GameType  = .PigGame2Dice
    static let ButtonColor                  = UIColor(red: 0.603,
                                                      green: 0.106,
                                                      blue: 0.112,
                                                      alpha: 1.0)
    static let DefaultLanguage              = Language.En
    static let DefaultIsSoundEnabled        = true
    static let DefaultIsVibrationEnabled    = false
    static let DefaultColorMode: ColorMode  = .System
}
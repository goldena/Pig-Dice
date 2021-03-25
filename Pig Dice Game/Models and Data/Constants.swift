//
//  Constants.swift
//  Pig Dice Game
//
//  Created by Denis Goloborodko on 30.11.20.
//

import UIKit

// MARK: - Constants

enum GameType: String {
    case PigGame1Dice
    case PigGame2Dice
}

enum ColorMode: String {
    case Light
    case Dark
    case System
}

struct Const {
    // Assets
    static let DiceFaces = [#imageLiteral(resourceName: "dice-1"), #imageLiteral(resourceName: "dice-2"), #imageLiteral(resourceName: "dice-3"), #imageLiteral(resourceName: "dice-4"), #imageLiteral(resourceName: "dice-5"), #imageLiteral(resourceName: "dice-6")]
    static let DiceSize = 100
    
    static let DiceRollSoundFileNames = ["dice_collision1", "dice_collision2", "dice_collision3", "dice_collision4"]
    static let SoundFileType = "wav"
    static let MusicFiles: [String] = ["Short Casual Loop #1", "Short Casual Loop #2"]
    static let MusicFileType = "mp3"

    // Game
    static let DefaultScoreLimit = 100
    
    // Interface
    static let DefaultPlayer1Name = "Han"
    static let DefaultPlayer2Name = "Solo"
    static let Is2ndPlayerAI = true
    static let DefaultGameType: GameType = .PigGame2Dice
    
    static let font = "Lato-Regular"
    static let cornerRadius = CGFloat(8)
    
    static let delay = 2.0
    
    static let Player1Color = UIColor(red: 0.603, green: 0.106, blue: 0.112, alpha: 1.0)
    static let Player2Color = UIColor(red: 0.24, green: 0.47, blue: 0.85, alpha: 1.0)

    static let DefaultLanguage = Language.En
    static let DefaultColorMode: ColorMode = .System
    static let DefaultIsBackgroundImageEnabled = true
    static let DefaultBackgroundImage: String = "back"
    
    static let DefaultIsSoundEnabled = true
    static let DefaultIsMusicEnabled = true
    static let DefaultIsVibrationEnabled = false
}

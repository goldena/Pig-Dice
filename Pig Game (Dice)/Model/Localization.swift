//
//  LocalizationEN.swift
//  Pig Game (Dice)
//
//  Created by Denis Goloborodko on 11/3/20.
//

import Foundation

enum Language {
    case En
    case Ru
}

class Localization {
    static var newGameTitle = ""
    static var newGameMessage = ""
    
    static var winnerTitle = ""
    static var winnerMessage = ""
    
    static var threw1Title = ""
    static var threw1Message = ""
    
    static var threw6TwiceTitle = ""
    static var threw6TwiceMessage = ""
    
    static var alertActionTitle = ""
    
    static func setLanguage(to language: Language) {
        switch language {
        case .En:
            Localization.newGameTitle = "New Game"
            Localization.newGameMessage = "You have started a new game!"
            
            Localization.winnerTitle = "You have won!"
            Localization.winnerMessage = "had won the game with total score"
            
            Localization.threw1Title = "You have lost this round!"
            Localization.threw1Message = "had thrown 1"
            
            Localization.threw6TwiceTitle = "Busted!"
            Localization.threw6TwiceMessage = "had 6 thrown two times in a row, the total score is now zero"
            
            Localization.alertActionTitle = "Okay"
            
        case .Ru:
            Localization.newGameTitle = "Новая игра"
            Localization.newGameMessage = "Вы начали новую игру!"
            
            Localization.winnerTitle = "Вы выиграли!"
            Localization.winnerMessage = "выиграл игру, набрав"
            
            Localization.threw1Title = "Вы проиграли этот раунд!"
            Localization.threw1Message = "выбросил 1"
            
            Localization.threw6TwiceTitle = "Сгорел!"
            Localization.threw6TwiceMessage = "выбросил 6 два раза подряд, общие очки теперь ноль"
            
            Localization.alertActionTitle = "Ок"
        }
    }
    
    init(to language: Language) {
        Localization.setLanguage(to: language)
    }
}

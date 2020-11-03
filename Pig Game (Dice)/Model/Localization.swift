//
//  LocalizationEN.swift
//  Pig Game (Dice)
//
//  Created by Denis Goloborodko on 11/3/20.
//

import Foundation

enum locale {
    case En
    case Ru
}

class Localization {
    var newGameTitle = ""
    var newGameMessage = ""
    
    var winnerTitle = ""
    var winnerMessage = ""
    
    var threw1Title = ""
    var threw1Message = ""
    
    var threw6TwiceTitle = ""
    var threw6TwiceMessage = ""

    var alertActionTitle = ""
    
    init(locale: locale) {
        switch locale {

        case .En:
            self.newGameTitle = "New Game"
            self.newGameMessage = "You have started a new game!"
            
            self.winnerTitle = "You have won!"
            self.winnerMessage = "had won the game with total score"
            
            self.threw1Title = "You have lost this round!"
            self.threw1Message = "had thrown 1"
            
            self.threw6TwiceTitle = "Busted!"
            self.threw6TwiceMessage = "had 6 thrown two times in a row, the total score is now zero"

            self.alertActionTitle = "Okay"
            
        case .Ru:
            self.newGameTitle = "Новая игра"
            self.newGameMessage = "Вы начали новую игру!"
            
            self.winnerTitle = "Вы выиграли!"
            self.winnerMessage = "выиграл игру, набрав"
            
            self.threw1Title = "Вы проиграли этот раунд!"
            self.threw1Message = "выбросил 1"
            
            self.threw6TwiceTitle = "Сгорел!"
            self.threw6TwiceMessage = "выбросил 6 два раза подряд, общие очки теперь ноль"

            self.alertActionTitle = "Ок"
        }
    }
}

var localization = Localization(locale: .Ru)

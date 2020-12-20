//
//  LocalizationEN.swift
//  Pig Game (Dice)
//
//  Created by Denis Goloborodko on 11/3/20.
//

import Foundation

// Available localization languages
enum Language: String {
    case En = "En"
    case Ru = "Ru"
}

// Enum of all the app's UI text elements and alerts
enum LocalisedUI {
    // Global - Alerts
    case alertActionTitle

    // Game View - Alerts
    case newGameMessage
    case newGameTitle

    case winnerTitle
    case victoryMessage
    
    case threw1Title
    case threw1Message
    
    case threw6TwiceTitle
    case threw6TwiceMessage
    
    // Game View - Text
    case currentScoreTitle
    case scoreLimitTitle
    case totalScoresTitle
    case currentPlayerTitle

    // Game View - Buttons
    case newGameButton
    case holdButton
    case rollButton
    
    // Options View - Text
    case player1NameTitle
    case player2NameTitle
    // case scoreLimitTitle - reuse of the same one from the Game View
    case noteLabel
    case with1or2DiceTitle

    // Options View - Buttons and controls
    case soundEnabledSwitch
    case saveButton
    case cancelButton
    case with1DiceSegmentedControlLabel
    case with2DiceSegmentedControlLabel
    case is2ndPlayerAITitle

    // Help View - Text
    case gameRulesTextView

    // Help View - Buttons
    case backButton
    
    // Provides translation of IU elements to a given language
    func translate(to language: Language) -> String {
        return LocalisationDictionary[self]?[language] ?? "Localization error"
    }
}

// Dictionary used for storing localizations
let LocalisationDictionary: [LocalisedUI: [Language: String]] = [
    
    // Global - Alerts
    .alertActionTitle: [.En: "Okay",
                        .Ru: "Ок"],
    
    // Game View - Alerts
    .newGameTitle: [.En: "New Game",
                    .Ru: "Новая игра"],
    .newGameMessage: [.En: "You have started a new game!",
                      .Ru: "Вы начали новую игру!"],
    
    .winnerTitle: [.En: "You have won!",
                   .Ru: "Вы выиграли!"],
    .victoryMessage: [.En: "had won the game with total score",
                     .Ru: "- вы выиграли игру, набрав"],
    
    .threw1Title: [.En: "You have lost this round",
                   .Ru: "Вы проиграли этот раунд"],
    .threw1Message: [.En: "You threw one, your current score goes to zero",
                     .Ru: "- вы выбросили единицу, очки сгорают"],
   
    .threw6TwiceTitle: [.En: "Busted!",
                        .Ru: "Сгорел!"],
    .threw6TwiceMessage: [.En: "had 6 thrown two times in a row, the total score goes to zero",
                          .Ru: "- выбросил 6 два раза подряд, общие очки теперь ноль"],
    
    // Game View - Text
    .scoreLimitTitle: [.En: "Score Limit:",
                       .Ru: "Лимит очков:"],

    .currentScoreTitle: [.En: "Score:",
                        .Ru: "Очки:"],

    .totalScoresTitle: [.En: "Total Scores",
                        .Ru: "Всего очков"],
    
    .currentPlayerTitle: [.En: "Player:",
                          .Ru: "Игрок:"],

    
    // Game View - Buttons
    .newGameButton: [.En: "NEW GAME",
                     .Ru: "НОВАЯ ИГРА"],
    
    .holdButton: [.En: "HOLD",
                  .Ru: "ПАС"],
    
    .rollButton: [.En: "ROLL",
                  .Ru: "БРОСОК"],
    
    // Options View - text
    .soundEnabledSwitch: [.En: "Sound Enabled",
                          .Ru: "Звук включён"],
    
    .player1NameTitle: [.En: "1st Player's Name",
                        .Ru: "Имя игрока 1"],
    
    .player2NameTitle: [.En: "2nd Player'a Name",
                        .Ru: "Имя игрока 2"],
    
    .is2ndPlayerAITitle: [.En: "2nd Player is AI",
                          .Ru: "2-ой игрок - ИИ"],
    
    // Reuse of the same one from the Options View
    // .scoreLimitTitle: [.En: "Score Limit",
    //                    .Ru: "Лимит очков"],
 
    .with1or2DiceTitle: [.En: "Play with",
                             .Ru: "Играть с"],
    
    .noteLabel: [.En:
                    """
                    Note: Game-related options will take effect after pressing NEW GAME button at the top of the game's main screen, after one of the players wins the current game in progress, or after restarting the app.
                    """,
                 .Ru:
                    """
                    Примечание: изменения относящиеся к правилам игры вступят в силу после нажания кнопки НОВАЯ ИГРА вверху главного экрана игры, выигрыша любого из игроков в текущей игре, либо после перезапуска приложения.
                    """],

    // Options View - buttons and contols
    .saveButton: [.En: "SAVE",
                  .Ru: "СОХРАНИТЬ"],
    
    .cancelButton: [.En: "CANCEL",
                    .Ru: "ОТМЕНА"],
    
    .with1DiceSegmentedControlLabel: [.En: "1 Dice",
                                          .Ru: "1 кубик"],
    
    .with2DiceSegmentedControlLabel: [.En: "2 Dice",
                                          .Ru: "2 кубика"],
    
    // Help View - Text
    .gameRulesTextView: [.En:
                            """
                            GAME RULES:
                            - The game has 2 players, playing in rounds. The first player to play the first round is determined randomly
                            - In each turn, a player rolls a dice as many times as he whishes. Each result get added to his ROUND score
                            - BUT, if the player rolls a 1, all his ROUND score gets lost. After that, it's the next player's turn
                            - A player looses his ENTIRE score when he rolls two 6 in a row. After that, it's the next player's turn.
                            - The player can choose to 'Hold', which means that his ROUND score gets added to his TOTAL score. After that, it's the next player's turn
                            - The first player to reach 100 (the number can be changed in the options) points in total - wins the game.
                            """,
                         .Ru:
                            """
                            ПРАВИЛА ИГРЫ:
                            - В игре участвуют два игрока, играющие по очередию. Первый игрок первого раунда определятеся случайно;
                            - В течение своего хода игрок может бросать кость неограниченное число раз. Каждый результат броска добавляется к его очкам за раунд.
                            - Но, если игрок выбросит 1, то все очки набранные в текущем раунде сгорают и ход переходит к другому икроку;
                            - Игрок теряет ВСЕ набранные очки когда выбрасывает две 6 подряд. После этого ход переходит к другому игроку;
                            - Игрок может выбрать "ПАС", что означает сохранение очков набранных в текущем раунде в общем счёте. Ход переходит к другому игроку.
                            - Первый из игроков, который наберёт всего 100 очков (лимит можно изменить в настройках) - побеждает.
                            """],

    // Help View - Buttons
    .backButton: [.En: "BACK",
                  .Ru: "НАЗАД"]
]

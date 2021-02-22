//
//  Localization.swift
//  Pig Dice Game
//
//  Created by Denis Goloborodko on 11/3/20.
//

import Foundation

// MARK: - Available localization languages

enum Language: String {
    case En = "En"
    case Ru = "Ru"
}

// MARK: - Enum of all the app's UI text elements and alerts

enum LocalizedUI {
    // Global - Alerts
    case alertActionTitle
    
    // Game View - Alerts
    case newGameTitle
    case newGameMessage
    
    case winnerTitle
    case victoryMessage
    
    case threw1Title
    case threw1Message
    
    case threw6TwiceTitle
    // For one dice game type
    case threw6TwiceMessage
    // For two dice game type
    case threwTwo6Message
    
    // Game View - Text
    case currentScoreLabel
    case scoreLimitLabel
    case totalScoresLabel
    case currentPlayerLabel
    
    // Game View - Buttons
    case newGameButton
    case holdButton
    case rollButton
    
    // Options View - Text
    case player1NameLabel
    case player2NameLabel
    // case scoreLimitLabel - reuse of the same one from the Game View
    case scoreLimitRangeLabel
    case noteLabel
    case gameTypeLabel
    case colorModeSelectionLabel
    case colorSysModeSegmentedControlLabel
    case colorLightModeSegmentedControlLabel
    case colorDarkModeSegmentedControlLabel
    
    // Options View - Buttons and controls
    case soundEnabledSwitch
    case vibrationEnabledSwitch
    case saveButton
    case cancelButton
    case with1DiceSegmentedControlLabel
    case with2DiceSegmentedControlLabel
    case is2ndPlayerAILabel
    
    // Help View - Text
    case gameRulesTextView
    
    // Help View - Buttons
    case backButton
    
    // Provides translation of IU elements to a given language
    func translate(to language: Language) -> String {
        return LocalizationDictionary[self]?[language] ?? "Localization error"        
    }
    
    // Provides translation of IU elements to a given language
    func translate(name: String?, to language: Language) -> String {
        let name = name ?? ""
        let localizedString = LocalizationDictionary[self]?[language] ?? "Localization error"
        
        // @NAME is the placeholder for the passed in argument name: String?
        return localizedString.replacingOccurrences(of: "@NAME", with: "\(name)")
    }
}

// MARK: - Dictionary used for storing localizations

let LocalizationDictionary: [LocalizedUI: [Language: String]] = [
    
    // Global - Alerts
    .alertActionTitle: [
        .En: "Okay",
        .Ru: "Ок"
    ],
    
    // Game View - Alerts
    .newGameTitle: [
        .En: "New Game",
        .Ru: "Новая игра"
    ],
    
    .newGameMessage: [
        .En: "New game started!",
        .Ru: "Начата новая игра!"
    ],
    
    .winnerTitle: [
        .En: "@NAME has won!",
        .Ru: "Победитель @NAME!"
    ],
    .victoryMessage: [
        .En: "@NAME has won the game with the total score ",
        .Ru: "Игрок @NAME победил в игре, набрав "
    ],
    
    .threw1Title: [
        .En: "@NAME has lost this round",
        .Ru: "@NAME проиграл(а) раунд"
    ],
    .threw1Message: [
        .En: "@NAME threw one - round score goes to zero",
        .Ru: "@NAME выбросил(а) единицу, очки сгорают"
    ],
    
    .threw6TwiceTitle: [
        .En: "Busted!",
        .Ru: "Сгорел!"
    ],
    .threwTwo6Message: [
        .En: "@NAME has thrown two 6, the total score goes to zero",
        .Ru: "@NAME выбросил(а) 6 два раза подряд, все очки сгорают"
    ],
    .threw6TwiceMessage: [
        .En: "@NAME has thrown 6 two times in a row, the total score goes to zero",
        .Ru: "@NAME выбросил(а) 6 два раза подряд, все очки сгорают"
    ],
    
    // Game View - Text
    .scoreLimitLabel: [
        .En: "Score Limit:",
        .Ru: "Лимит очков:"
    ],
    .currentScoreLabel: [
        .En: "Score:",
        .Ru: "Очки:"
    ],
    .totalScoresLabel: [
        .En: "Total Scores",
        .Ru: "Всего очков"
    ],
    
    .currentPlayerLabel: [
        .En: "Player:",
        .Ru: "Игрок:"
    ],
    
    // Game View - Buttons
    .newGameButton: [
        .En: "NEW GAME",
        .Ru: "НОВАЯ ИГРА"
    ],
    .holdButton: [
        .En: "HOLD",
        .Ru: "ПАС"
    ],
    .rollButton: [
        .En: "ROLL",
        .Ru: "БРОСОК"
    ],
    
    // Options View - text
    .soundEnabledSwitch: [
        .En: "Sound",
        .Ru: "Звук"
    ],
    .vibrationEnabledSwitch: [
        .En: "Vibration",
        .Ru: "Вибрация"
    ],
    
    .colorModeSelectionLabel: [
        .En: "Color Mode",
        .Ru: "Цветовая схема"
    ],
    .colorSysModeSegmentedControlLabel: [
        .En: "System",
        .Ru: "Системы"
    ],
    .colorLightModeSegmentedControlLabel: [
        .En: "Light",
        .Ru: "Светлая"
    ],
    .colorDarkModeSegmentedControlLabel: [
        .En: "Dark",
        .Ru: "Тёмная"
    ],
    
    .player1NameLabel: [
        .En: "1st Player's Name",
        .Ru: "Имя игрока 1"
    ],
    .player2NameLabel: [
        .En: "2nd Player'a Name",
        .Ru: "Имя игрока 2"
    ],
    .is2ndPlayerAILabel: [
        .En: "2nd Player is AI",
        .Ru: "2-ой игрок - ИИ"
    ],
    
    // Reuse of the same one from the Options View
    // .scoreLimitLabel: [.En: "Score Limit",
    //                    .Ru: "Лимит очков"],
    
    .scoreLimitRangeLabel: [
        .En: "* in range from 10 to 1000",
        .Ru: "* в пределах от 10 до 1000"
    ],
    
    .gameTypeLabel: [
        .En: "Play with",
        .Ru: "Играть с"
    ],
    
    .noteLabel: [
        .En:
            """
            Note: Game-related options will take effect after pressing NEW GAME button at the top of the game's main screen, after one of the players wins the current game in progress, or after restarting the app.
            """,
        .Ru:
            """
            Примечание: изменения относящиеся к правилам игры вступят в силу после нажатия кнопки НОВАЯ ИГРА вверху главного экрана игры, выигрыша любого из игроков в текущей игре, либо после перезапуска приложения.
            """
    ],
    
    // Options View - buttons and controls
    .saveButton: [
        .En: "SAVE",
        .Ru: "СОХРАНИТЬ"
    ],
    .cancelButton: [
        .En: "CANCEL",
        .Ru: "ОТМЕНА"
    ],
    
    .with1DiceSegmentedControlLabel: [
        .En: "1 Dice",
        .Ru: "1 кубик"
    ],
    .with2DiceSegmentedControlLabel: [
        .En: "2 Dice",
        .Ru: "2 кубика"
    ],
    
    // Help View - Text
    .gameRulesTextView: [
        .En:
            """
            GAME RULES:

            - The game has 2 players, playing in rounds. The first player to play the first round is determined randomly.

            - In each turn, a player rolls a dice as many times as he wishes. Each result get added to his ROUND score.

            - BUT, if the player rolls a 1, all his ROUND score gets lost. After that, it's the next player's turn.

            - A player looses his ENTIRE score when he rolls two 6 in a row. After that, it's the next player's turn.

            - The player can choose to 'Hold', which means that his ROUND score gets added to his TOTAL score. After that, it's the next player's turn.

            - The first player to reach 100 (the number can be changed in the options) points in total - wins the game.
            """,
        .Ru:
            """
            ПРАВИЛА ИГРЫ:

            - В игре участвуют два игрока, играющие по очереди. Первый игрок первого раунда определяется случайно;

            - В течение своего хода игрок может бросать кость неограниченное число раз. Каждый результат броска добавляется к его очкам за раунд;

            - Но, если игрок выбросит 1, то все очки набранные в текущем раунде сгорают и ход переходит к другому игроку;

            - Игрок теряет ВСЕ набранные очки когда выбрасывает две 6 подряд. После этого ход переходит к другому игроку;

            - Игрок может выбрать "ПАС", что означает сохранение очков набранных в текущем раунде в общем счёте. Ход переходит к другому игроку;

            - Первый из игроков, который наберёт всего 100 очков (лимит можно изменить в настройках) - побеждает.
            """
    ],
    
    // Help View - Buttons
    .backButton: [
        .En: "BACK",
        .Ru: "НАЗАД"
    ]
]
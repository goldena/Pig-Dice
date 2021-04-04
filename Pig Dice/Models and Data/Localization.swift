//
//  Localization.swift
//  Pig Dice
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
    case looserTitle
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
    case colorModeSectionTitle
    
    case colorSysModeSegmentedControlLabel
    case colorLightModeSegmentedControlLabel
    case colorDarkModeSegmentedControlLabel
    
    case pigsBackgroundImageSegmentedControlLabel
    case blackboardBackgroundImageSegmentedControlLabel
    case noBackgroundImageSegmentedControlLabel
    
    // Options View - Buttons and controls
    case languageSectionTitle
    case backgroundImageSectionTitle
    case soundAndVibrationSectionTitle
    case soundEnabledSwitch
    case musicEnabledSwitch
    case vibrationEnabledSwitch
    case saveButton
    case cancelButton
    case with1DiceSegmentedControlLabel
    case with2DiceSegmentedControlLabel
    case playersSegmentTitle
    case is2ndPlayerAILabel
    case noteSegmentTitle
    
    // Help View - Text
    case gameRulesTextView
    
    // Help View - Buttons
    case backButton
        
    // Provides translation of IU elements to a given language
    func translate(name: String = "", to language: Language) -> String {
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
        .En: "The Winner!",
        .Ru: "Победитель!"
    ],
    .looserTitle: [
        .En: "You have lost!",
        .Ru: "Вы проиграли!"
    ],
    .victoryMessage: [
        .En: "@NAME has won the game with the total score ",
        .Ru: "Игрок @NAME победил в игре, набрав "
    ],
    
    .threw1Title: [
        .En: "Player looses round",
        .Ru: "Игрок проиграл раунд"
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
        .En: "@NAME has thrown two six, the total score goes to zero",
        .Ru: "@NAME выбросил(а) две шесть, все очки сгорают"
    ],
    .threw6TwiceMessage: [
        .En: "@NAME has thrown six two times in a row, the total score goes to zero",
        .Ru: "@NAME выбросил(а) шесть два раза подряд, все очки сгорают"
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
        .En: "Active Player:",
        .Ru: "Ходит игрок:"
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
    .languageSectionTitle: [
        .En: "Language / Язык",
        .Ru: "Язык / Language"
    ],
    
    .backgroundImageSectionTitle: [
        .En: "Background Image",
        .Ru: "Фоновое изображение"
    ],
    
    .pigsBackgroundImageSegmentedControlLabel: [
        .En: "Piggies",
        .Ru: "Свинки"
    ],
    
    .blackboardBackgroundImageSegmentedControlLabel: [
        .En: "Blackboard",
        .Ru: "Доска"
    ],
    
    .noBackgroundImageSegmentedControlLabel: [
        .En: "None",
        .Ru: "Нет"
    ],
    
    .soundAndVibrationSectionTitle: [
        .En: "Sound and Vibration",
        .Ru: "Звук и вибрация"],
    
    .soundEnabledSwitch: [
        .En: "Sound",
        .Ru: "Звук"
    ],
    .musicEnabledSwitch: [
        .En: "Music",
        .Ru: "Музыка"
    ],
    .vibrationEnabledSwitch: [
        .En: "Vibration",
        .Ru: "Вибрация"
    ],
    
    .colorModeSectionTitle: [
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
    
    .playersSegmentTitle: [
        .En: "Players",
        .Ru: "Игроки"
    ],
    
    .player1NameLabel: [
        .En: "1st Player's Name",
        .Ru: "Имя игрока 1"
    ],
    .player2NameLabel: [
        .En: "2nd Player's Name",
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
        .En: "Game Rules",
        .Ru: "Правила игры"
    ],
    
    .noteSegmentTitle: [
        .En: "Note",
        .Ru: "Примечание"
    ],
    
    .noteLabel: [
        .En:
            """
            Game-related options will take effect after pressing NEW GAME button at the top of the game's main screen, after completing a game in progress, or after restarting the app.
            """,
        .Ru:
            """
            Изменения, относящиеся к правилам игры, вступят в силу после нажатия кнопки НОВАЯ ИГРА вверху главного экрана игры, окончания текущей игры, либо после перезапуска приложения.
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

            The game has two players playing in rounds. The player who plays the first round is determined randomly.

            Each turn, a player rolls dice as many times as he wants. After each roll, the result added to his ROUND score.

            If the player rolls one, all his ROUND score becomes zero, and the turn goes to the next player.

            Note: A player loses his ENTIRE score when he rolls two sixes in a row, and the turn goes to the next player.

            For each roll, the player has an option to HOLD, which means that his ROUND score is added to his TOTAL score, and the turn goes to the next player.

            The first player who reaches 100 points in total wins the game.

            Note: Target score can be changed in the options.
            """,
        .Ru:
            """
            ПРАВИЛА ИГРЫ:

            В игре участвуют два игрока, бросая кубики по очереди. Очередность, определяется случайным образом, например, младший по возрасту игрок начинает первым.
            
            Каждый РАУНД игрок может бросать  кубики неограниченное количество раз. После каждого броска сумма выпавших значений добавляется к его общему счету.
            
            Если игрок выбросит ЕДЕНИЦУ, то все очки набранные в текущем раунде сгорают и ход переходит к другому игроку.

            Игрок теряет ВСЕ набранные очки когда выбрасывает две ШЕСТЕРКИ подряд и ход переходит к другому игроку.

            Игрок сам решает, когда остановится, выбрав ПАС, что позволяет ему сохранить набранные очки в текущем РАУНДЕ и добавить их общему количеству набранных очков. В случае ПАСА ход переходит к другому игроку.

            Первый из игроков, который наберёт 100 или более очков побеждает в игре (количество очков, необходимых для победы можно изменить в настройках).
            """
    ],
    
    // Help View - Buttons
    .backButton: [
        .En: "BACK",
        .Ru: "НАЗАД"
    ]
]

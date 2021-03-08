//
//  ViewController.swift
//  Pig Dice Game
//
//  Created by Denis Goloborodko on 10/8/20.
//

import UIKit

// Main screen view controller
class GameViewController: UIViewController, ViewControllerDelegate {
 
    // MARK: - Properties
    
    // Dice ImageView are programmatically added or remover, depending on a game type
    private var dice1ImageView: UIImageView!
    private var dice2ImageView: UIImageView!
    
    // For delegation needs, to dynamically update some of the options on the main game screen
    private var optionsViewController: OptionsViewController!
    
    var game = Game()
    
    // Check for changing buttons' color of the second human player (for hot-seat game)
    var is2ndPlayer: Bool {
        game.activePlayer === game.player2 ? true : false
    }
    
    // MARK: - Properties - IBOutlet(s)
    
    @IBOutlet var ButtonsCollection: [UIButton]!
    @IBOutlet private weak var NewGameButton: UIButton!
    @IBOutlet private weak var RollButton: UIButton!
    @IBOutlet private weak var HoldButton: UIButton!
    
    // StackView for programmatically adding/removing Dice
    @IBOutlet private weak var DiceImagesStackView: UIStackView!
    
    @IBOutlet private weak var CurrentScoreLabel: UILabel!
    @IBOutlet private weak var CurrentScoreValue: UILabel!
    
    @IBOutlet private weak var ScoreLimitLabel: UILabel!
    @IBOutlet private weak var ScoreLimitValue: UILabel!
    
    @IBOutlet private weak var TotalScoresLabel: UILabel!
    @IBOutlet private weak var PlayerOneScoreValue: UILabel!
    @IBOutlet private weak var PlayerTwoScoreValue: UILabel!
    
    @IBOutlet private weak var CurrentPlayerLabel: UILabel!
    @IBOutlet private weak var CurrentPlayerName: UILabel!
     
    // MARK: - View Lifecycle
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Save initial defaults if the game is launched for the first time
        Options.onFirstLaunch()
        
        // Instantiate Options ViewController for delegation
        optionsViewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(identifier: "OptionsViewController")
        
        optionsViewController.delegate = self
    }
 
    private func addDiceImageView( _ diceImageView: inout UIImageView!) {
        // Create Dice ImageView and add it to the StackView
        diceImageView = UIImageView()
        diceImageView.translatesAutoresizingMaskIntoConstraints = false
        diceImageView.contentMode = .scaleAspectFit
        DiceImagesStackView.addArrangedSubview(diceImageView)
    }
    
    // Show or hide the second dice ImageView
    private func updateDiceImageViews() {
        switch game.gameType {
        case .PigGame1Dice:
            dice2ImageView.isHidden = true
        case .PigGame2Dice:
            dice2ImageView.isHidden = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        addDiceImageView(&dice1ImageView)
        addDiceImageView(&dice2ImageView)
        
        startNewGame()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        alertThenHandleNewGame()
    }
    
    // Delegation func, to localize UI once the Options are saved
    func viewWillDimiss() {
        updateColorMode()
        localizeUI()
    }
      
    // Pass data about color of buttons to Help ViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ShowHelpSegue" else { return }
        
        if let helpViewController = segue.destination as? HelpViewController {
            helpViewController.is2ndPlayer = is2ndPlayer
        }
    }
    
    // MARK: - Methods - Actions
    
    @IBAction private func RollButtonPressed(_ sender: UIButton) { roll() }
    @IBAction private func HoldButtonPressed(_ sender: UIButton) { hold() }
    
    @IBAction private func OptionsButtonPressed(_ sender: Any) {
        optionsViewController.is2ndPlayer = is2ndPlayer

        present(optionsViewController, animated: true, completion: nil)
    }
    
    @IBAction private func NewGameButtonPressed(_ sender: UIButton) {
        startNewGame()
        alertThenHandleNewGame()
    }

    // MARK: - Methods
    
    private func alertThenHandleNewGame() {
        alertThenHandleEvent(
            color: Const.Player1Color,
            title: LocalizedUI.newGameTitle.translate(to: Options.language),
            message: LocalizedUI.newGameMessage.translate(to: Options.language),
            handler: {
                self.updateUI()
                self.nextMoveIfAI()
            })
    }
    
    private func startNewGame() {
        Options.load()
        game.initNewGame()
        
        updateDiceImageViews()
        localizeUI()
        updateUI()
    }
    
    private func nextMoveIfAI() {
        guard game.activePlayer.isAI else { return }

        disableButtons(ButtonsCollection)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { [weak self] in
            guard let self = self else { return }
            
            let AIPlayer = self.game.activePlayer
            
            var otherPlayerRoundScore: Int {
                AIPlayer === self.game.player1 ? self.game.player2.roundScore : self.game.player1.roundScore
            }
            
            AIPlayer.rollOrHold(if: otherPlayerRoundScore) ? self.roll() : self.hold()

            self.enableButtons(self.ButtonsCollection)
        }
    }
     
    // Handle switching to the next player
    func switchToNextPlayer() {
        game.nextPlayer()
        
        updateUI()
        nextMoveIfAI()
    }
    
    private func alertThenHandleRollResult(_ dice: Int) {
        let player = game.activePlayer
        let language = Options.language
        
        switch (dice, player.previousDice) {
        case (1, _):
            alertThenHandleEvent(
                color: Const.Player1Color,
                title: LocalizedUI.threw1Title.translate(name: player.name, to: language),
                message: LocalizedUI.threw1Message.translate(name: player.name, to: language),
                handler: { self.switchToNextPlayer() })
        case (6, 6):
            alertThenHandleEvent(
                color: Const.Player1Color,
                title: LocalizedUI.threw6TwiceTitle.translate(name: player.name, to: language),
                message: LocalizedUI.threw6TwiceMessage.translate(name: player.name, to: language),
                handler: { self.switchToNextPlayer() })
        default:
            nextMoveIfAI()
        }
    }
    
    private func alertThenHandleRollResult(_ dice1: Int, _ dice2: Int) {
        let player = game.activePlayer
        let language = Options.language
                
        switch (dice1, dice2) {
        case (_, 1), (1, _):
            alertThenHandleEvent(
                color: Const.Player1Color,
                title: LocalizedUI.threw1Title.translate(name: player.name, to: language),
                message: LocalizedUI.threw1Message.translate(name: player.name, to: language),
                handler: { self.switchToNextPlayer() })
        case (6, 6):
            alertThenHandleEvent(
                color: Const.Player1Color,
                title: LocalizedUI.threw6TwiceTitle.translate(name: player.name, to: language),
                message: LocalizedUI.threwTwo6Message.translate(name: player.name, to: language),
                handler: { self.switchToNextPlayer() })
        default:
            nextMoveIfAI()
        }
    }
            
    private func alertThenHandleVictory() {
        let player = game.activePlayer
        let language = Options.language
        
        alertThenHandleEvent(
            color: Const.Player1Color,
            title: LocalizedUI.winnerTitle.translate(name: player.name, to: language),
            message: LocalizedUI.victoryMessage.translate(name: player.name, to: language)
                + String(player.totalScore),
            handler: {
                self.startNewGame()
                self.alertThenHandleNewGame()
            })
    }
    
    private func roll() {
        // Game mechanics: roll, calculate scores, check conditions, display alerts
        let player = game.activePlayer

        player.rollDice()
        
        SoundAndHapticController.playHaptic()
        
        if Options.isSoundEnabled {
            SoundAndHapticController.playSound(Const.DiceRollSoundFileName, type: Const.DiceRollSoundFileType)
        }
        
        switch game.gameType {
        case .PigGame1Dice:
            guard let dice = player.dice1 else { return }
            
            game.calculateScores(dice)
            updateUI()
            alertThenHandleRollResult(dice)
        case .PigGame2Dice:
            guard let dice1 = player.dice1, let dice2 = player.dice2 else { return }
            
            game.calculateScores(dice1, dice2)
            updateUI()
            alertThenHandleRollResult(dice1, dice2)
        }
    }

    
    private func hold() {
        let player = game.activePlayer
        
        // Hold current scores
        player.holdRoundScore()
        
        if player.totalScore >= game.scoreLimit {
            updateUI()
            alertThenHandleVictory()
            
            return
        }
        
        switchToNextPlayer()
    }
        
    private func localizeUI() {
        let language = Options.language
        
        // Localize buttons
        NewGameButton.setTitle(LocalizedUI.newGameButton.translate(to: language), for: .normal)
        RollButton.setTitle(LocalizedUI.rollButton.translate(to: language), for: .normal)
        HoldButton.setTitle(LocalizedUI.holdButton.translate(to: language), for: .normal)
        
        // Localize text
        CurrentScoreLabel.text  = LocalizedUI.currentScoreLabel.translate(to: language)
        ScoreLimitLabel.text    = LocalizedUI.scoreLimitLabel.translate(to: language)
        TotalScoresLabel.text   = LocalizedUI.totalScoresLabel.translate(to: language)
        CurrentPlayerLabel.text = LocalizedUI.currentPlayerLabel.translate(to: language)
    }
    
    private func updateUI() {
        let player = game.activePlayer
        
        // Show or Hide dice 1 image at the beginning of each round or a new game
        if let dice1 = player.dice1 {
            dice1ImageView.image = Const.DiceFaces[dice1 - 1]
        } else {
            dice1ImageView.image = nil
        }

        // Show or Hide dice 2 image at the beginning of each round or a new game
        if game.gameType == .PigGame2Dice {
            if let dice2 = player.dice2 {
                dice2ImageView?.image = Const.DiceFaces[dice2 - 1]
            } else {
                dice2ImageView?.image = nil
            }
        }
        
        // Change color of buttons for the second player, when it is not AI
        if player === game.player2 && game.activePlayer.isAI == false {
            changeColorOfButtons(ButtonsCollection, to: Const.Player2Color)
        } else {
            changeColorOfButtons(ButtonsCollection, to: Const.Player1Color)
        }
        
        ScoreLimitValue.text     = String(game.scoreLimit)
        CurrentPlayerName.text   = player.name
        PlayerOneScoreValue.text = "\(game.player1.name): \(game.player1.totalScore)"
        PlayerTwoScoreValue.text = "\(game.player2.name): \(game.player2.totalScore)"
        CurrentScoreValue.text   = "\(player.roundScore)"
    }
}

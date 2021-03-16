//
//  ViewController.swift
//  Pig Dice Game
//
//  Created by Denis Goloborodko on 10/8/20.
//

import UIKit
import CoreMotion

// Main screen view controller
class GameViewController: UIViewController, ViewControllerDelegate {
 
    // MARK: - Properties
    
    // Dice ImageView are programmatically added or remover, depending on a game type
    private var dice1ImageView: UIImageView!
    private var dice2ImageView: UIImageView!
    
    private var dynamicAnimator: UIDynamicAnimator!
    private var collisionBehavior: UICollisionBehavior!
    private var bouncingBehavior: UIDynamicItemBehavior!
    private var gravityBehavior: UIGravityBehavior!
    private var motionManager: CMMotionManager!
    private var accelerometerUpdatesOperationQueue: OperationQueue!
    
    // For delegation needs, to dynamically update some of the options on the main game screen
    private var optionsViewController: OptionsViewController!
    
    var game = Game()
    
    // Check for changing buttons' color of the second human player (for hot-seat game)
    private var is2ndPlayer: Bool {
        game.activePlayer === game.player2 ? true : false
    }
    
    // MARK: - Properties - IBOutlet(s)
    
    @IBOutlet var ButtonsCollection: [UIButton]!
    @IBOutlet private weak var NewGameButton: UIButton!
    @IBOutlet private weak var RollButton: UIButton!
    @IBOutlet private weak var HoldButton: UIButton!
        
    @IBOutlet weak var DiceAnimationView: UIView!
    
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
     
    // Delegation func, to localize UI once the Options are saved
    func optionsViewControllerWillDismiss() {
        updateColorMode()
        localizeUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        configDiceImageView(&dice1ImageView)
        configDiceImageView(&dice2ImageView)
        
        configAnimation()
        configMotionManager()
        
        startNewGame()
    }
    
    private func configDiceImageView( _ diceImageView: inout UIImageView!) {
        diceImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: Const.DiceSize, height: Const.DiceSize))
        diceImageView.contentMode = .scaleAspectFill
        diceImageView.alpha = 0.0
    }
    
    func configAnimation() {
        dynamicAnimator = UIDynamicAnimator(referenceView: DiceAnimationView)
        
        gravityBehavior = UIGravityBehavior()
        dynamicAnimator.addBehavior(gravityBehavior)

        collisionBehavior = UICollisionBehavior()
        collisionBehavior.collisionDelegate = self
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        dynamicAnimator.addBehavior(collisionBehavior)
        
        bouncingBehavior = UIDynamicItemBehavior()
        bouncingBehavior.elasticity = 0.5
        bouncingBehavior.density = 0.9
        bouncingBehavior.friction = 0.3
        dynamicAnimator.addBehavior(bouncingBehavior)
    }
    
    func configMotionManager() {
        motionManager = CMMotionManager()
        
        guard motionManager.isAccelerometerAvailable else { return }

        // Setup Operations Queue for Accelerometer updates
        accelerometerUpdatesOperationQueue = OperationQueue()
        accelerometerUpdatesOperationQueue.maxConcurrentOperationCount = 1
        accelerometerUpdatesOperationQueue.qualityOfService = .background
        
        motionManager.accelerometerUpdateInterval = 0.1
        
        motionManager.startAccelerometerUpdates(to: accelerometerUpdatesOperationQueue) { [weak self] (accelerometerData, error) in
            guard let self = self else { return }
            
            if let error = error {
                NSLog("Failed to fetch data from accelerometer with an error: \(error)")
                return
            }
            
            guard let accelerometerData = accelerometerData else { return }
            
            DispatchQueue.main.async {
                self.gravityBehavior.gravityDirection = CGVector(
                    dx: accelerometerData.acceleration.x,
                    dy: accelerometerData.acceleration.y * -1
                )
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        alertThenHandleNewGame()
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
            color: is2ndPlayer ? Const.Player2Color : Const.Player1Color,
            title: LocalizedUI.newGameTitle.translate(to: Options.language),
            message: LocalizedUI.newGameMessage.translate(to: Options.language),
            handler: {
                self.updateUI()
                self.nextMoveIfAI()
            })
    }
    
    private func startNewGame() {
        dice1ImageView.alpha = 0.0
        dice2ImageView.alpha = 0.0
        
        removeBehaviours(from: dice1ImageView)
        removeBehaviours(from: dice2ImageView)
        
        dice1ImageView.removeFromSuperview()
        dice2ImageView.removeFromSuperview()
        
        Options.load()
        game.initNewGame()
                
        localizeUI()
        updateUI()
    }
    
    private func nextMoveIfAI() {
        guard game.activePlayer.isAI else { return }

        disableButtons(ButtonsCollection)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Const.delay) { [weak self] in
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
        let playerColor = is2ndPlayer ? Const.Player2Color : Const.Player1Color
        
        switch (dice, player.previousDice) {
        case (1, _):
            alertThenHandleEvent(
                color: playerColor,
                title: LocalizedUI.threw1Title.translate(name: player.name, to: language),
                message: LocalizedUI.threw1Message.translate(name: player.name, to: language),
                handler: { self.switchToNextPlayer() })
        case (6, 6):
            alertThenHandleEvent(
                color: playerColor,
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
        let playerColor = is2ndPlayer ? Const.Player2Color : Const.Player1Color
                
        switch (dice1, dice2) {
        case (_, 1), (1, _):
            alertThenHandleEvent(
                color: playerColor,
                title: LocalizedUI.threw1Title.translate(name: player.name, to: language),
                message: LocalizedUI.threw1Message.translate(name: player.name, to: language),
                handler: { self.switchToNextPlayer() })
        case (6, 6):
            alertThenHandleEvent(
                color: playerColor,
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
            color: is2ndPlayer ? Const.Player2Color : Const.Player1Color,
            title: LocalizedUI.winnerTitle.translate(name: player.name, to: language),
            message: LocalizedUI.victoryMessage.translate(name: player.name, to: language)
                + String(player.totalScore),
            handler: {
                self.startNewGame()
                self.alertThenHandleNewGame()
            })
    }
    
    private func animateDiceImageView(_ diceImageView: UIImageView) {
        var randomMidX: CGFloat {
            DiceAnimationView.frame.midX + CGFloat.random(in: -50...50)
        }
        var minY: CGFloat {
            diceImageView.frame.height / 2
        }
        
        removeBehaviours(from: diceImageView)
        
        // Fadeout and reappear at the top of the view
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.2,
            delay: 0.0,
            options: .curveEaseInOut,
            animations: { diceImageView.alpha = 0.0 }
        ) { _ in
            diceImageView.center = CGPoint(x: randomMidX, y: minY)
            diceImageView.alpha = 1.0
            self.DiceAnimationView.layoutIfNeeded()
            
            self.addBehaviours(to: diceImageView)
            self.bouncingBehavior.addAngularVelocity(CGFloat.random(in: -20...20), for: diceImageView)
        }
    }
    
    // Remove animation behaviours
    private func removeBehaviours(from diceImageView: UIImageView) {
        collisionBehavior.removeItem(diceImageView)
        bouncingBehavior.removeItem(diceImageView)
        gravityBehavior.removeItem(diceImageView)
    }
    
    // Add animation behaviours
    private func addBehaviours(to diceImageView: UIImageView) {
        self.collisionBehavior.addItem(diceImageView)
        self.bouncingBehavior.addItem(diceImageView)
        self.gravityBehavior.addItem(diceImageView)
    }
    
    private func roll() {
        // Game mechanics: roll, calculate scores, check conditions, display alerts
        let player = game.activePlayer
        
        player.rollDice()
                
        DiceAnimationView.addSubview(dice1ImageView)
        animateDiceImageView(dice1ImageView)
        
        if game.gameType == .PigGame2Dice {
            DiceAnimationView.addSubview(dice2ImageView)
            animateDiceImageView(dice2ImageView)
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

        if let dice1 = player.dice1 {
            dice1ImageView.image = Const.DiceFaces[dice1 - 1]
        }

        if game.gameType == .PigGame2Dice, let dice2 = player.dice2 {
            dice2ImageView?.image = Const.DiceFaces[dice2 - 1]
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

extension GameViewController: UICollisionBehaviorDelegate {
    
    func collisionBehavior(
        _ behavior: UICollisionBehavior,
        beganContactFor item: UIDynamicItem,
        withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint
    ) {
        
        // Play vibration
        if Options.isVibrationEnabled {
            SoundAndHapticController.playHaptic()
        }
            
        // Play sound
        if Options.isSoundEnabled {
            SoundAndHapticController.playSound(
                Const.DiceRollSoundFileName.randomElement() ?? "",
                type: Const.DiceRollSoundFileType
            )}
    }
}

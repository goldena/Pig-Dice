//
//  GameViewController.swift
//  Pig Dice
//
//  Created by Denis Goloborodko on 10/8/20.
//

import UIKit
import AVFoundation

// Main screen view controller
class GameViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: - Properties
    
    // Dice ImageView are programmatically added or remover, depending on a game type
    private var dice1ImageView: UIImageView!
    private var dice2ImageView: UIImageView!
    
    private var dynamicAnimator: UIDynamicAnimator!
    
    private var collisionBehavior: UICollisionBehavior!
    private var bouncingBehavior: UIDynamicItemBehavior!
    private var gravityBehavior: UIGravityBehavior!
    private var pushBehaviourDice1: UIPushBehavior!
    private var pushBehaviourDice2: UIPushBehavior!
    
    private var panGestureDice1: UIPanGestureRecognizer!
    private var panGestureDice2: UIPanGestureRecognizer!
    
    // For delegation needs, to dynamically update some of the options on the main game screen
    private var optionsViewController: OptionsViewController!
    
    private var motionManager: MotionManager!
    
    var game = Game()
    
    // Check for changing buttons' color of the second human player (for hot-seat game)
    private var is2ndPlayer: Bool { game.activePlayer === game.player2 }
    
    // MARK: - Properties - IBOutlet(s)
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var gameViewBackground: UIView!
    
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
        
        // Instantiate Options ViewController for delegation and assign delegate to self
        optionsViewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(identifier: "OptionsViewController")
        optionsViewController.delegate = self
                
        // Init panGestureRecognizers
        panGestureDice1 = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        panGestureDice2 = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        
        // If the init fails - the accelerometer won't be used for updating animation
        if let motionManager = MotionManager() { motionManager.delegate = self }
        
        SoundAndHapticController.cacheSounds(soundNames: Const.DiceRollSoundFileNames, fileType: Const.SoundFileType)
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        configDiceImageView(&dice1ImageView)
        configDiceImageView(&dice2ImageView)
        
        DiceAnimationView.addSubview(dice1ImageView)
        DiceAnimationView.addSubview(dice2ImageView)
        
        dice1ImageView.addGestureRecognizer(panGestureDice1)
        dice2ImageView.addGestureRecognizer(panGestureDice2)
        
        configAnimation()
        
        makeViewsRounded(ButtonsCollection, withRadius: Const.cornerRadius)
        makeViewRounded(gameViewBackground, withRadius: Const.cornerRadius)
        
        startNewGame()
    }
        
    private func configDiceImageView( _ diceImageView: inout UIImageView!) {
        diceImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: Const.DiceSize, height: Const.DiceSize))
        diceImageView.contentMode = .scaleAspectFill
        diceImageView.alpha = 0.0
        
        diceImageView.layer.cornerRadius = 8
        diceImageView.layer.borderColor = .init(gray: 0.5, alpha: 0.3)
        diceImageView.layer.borderWidth = 1
        diceImageView.layer.masksToBounds = true
        
        diceImageView.isUserInteractionEnabled = true
    }
    
    @objc private func handlePan(_ sender: UIPanGestureRecognizer) {
        guard sender.state == .ended else { return }
        
        var pushBehaviour: UIPushBehavior {
            sender === panGestureDice1 ? pushBehaviourDice1 : pushBehaviourDice2
        }
        
        pushBehaviour.pushDirection = CGVector(
            dx: sender.translation(in: DiceAnimationView).x * 0.05,
            dy: sender.translation(in: DiceAnimationView).y * 0.05
        )

        pushBehaviour.active = true
    }
    
    func configAnimation() {
        dynamicAnimator = UIDynamicAnimator(referenceView: DiceAnimationView)
        
        gravityBehavior = UIGravityBehavior()
        gravityBehavior.magnitude = 1.4
        dynamicAnimator.addBehavior(gravityBehavior)
        
        collisionBehavior = UICollisionBehavior()
        collisionBehavior.collisionDelegate = self
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        dynamicAnimator.addBehavior(collisionBehavior)
        
        bouncingBehavior = UIDynamicItemBehavior()
        bouncingBehavior.elasticity = 0.6
        bouncingBehavior.density = 0.9
        bouncingBehavior.friction = 0.4
        dynamicAnimator.addBehavior(bouncingBehavior)
        
        pushBehaviourDice1 = UIPushBehavior(items: [dice1ImageView], mode: .instantaneous)
        dynamicAnimator.addBehavior(pushBehaviourDice1)
        
        pushBehaviourDice2 = UIPushBehavior(items: [dice2ImageView], mode: .instantaneous)
        dynamicAnimator.addBehavior(pushBehaviourDice2)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        alertThenHandleNewGame()
    }
    
    // Pass data about color of buttons to Help ViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ShowHelpSegue" else { return }
        
        if let helpViewController = segue.destination as? HelpViewController {
            helpViewController.updateColorMode()
            // helpViewController.updateBackgroundImage()
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
        
        // removeBehaviours(from: dice1ImageView)
        // removeBehaviours(from: dice2ImageView)
        
        // dice1ImageView.removeFromSuperview()
        // dice2ImageView.removeFromSuperview()
        
        Options.load()
        game.initNewGame()
        
        updateColorMode()
        updateBackgroundImage()
        localizeUI()
        updateUI()
                
        if Options.isMusicEnabled {
            SoundAndHapticController.playNext()
        } else {
            SoundAndHapticController.stopMusic()
        }
    }
    
    private func nextMoveIfAI() {
        guard game.activePlayer.isAI else { return }
        
        disableButtons(ButtonsCollection)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Const.delay) { [weak self] in
            guard let self = self else { return }
            
            let AIPlayer = self.game.activePlayer
            
            // Score of another player for AI to decide to roll or to hold
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
                title: LocalizedUI.threw1Title.translate(to: language),
                message: LocalizedUI.threw1Message.translate(name: player.name, to: language),
                handler: { self.switchToNextPlayer() })
        case (6, 6):
            alertThenHandleEvent(
                color: playerColor,
                title: LocalizedUI.threw6TwiceTitle.translate(to: language),
                message: LocalizedUI.threwTwo6Message.translate(name: player.name, to: language),
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
                title: LocalizedUI.threw1Title.translate(to: language),
                message: LocalizedUI.threw1Message.translate(name: player.name, to: language),
                handler: { self.switchToNextPlayer() })
        case (6, 6):
            alertThenHandleEvent(
                color: playerColor,
                title: LocalizedUI.threw6TwiceTitle.translate(to: language),
                message: LocalizedUI.threwTwo6Message.translate(name: player.name, to: language),
                handler: { self.switchToNextPlayer() })
        default:
            nextMoveIfAI()
        }
    }
    
    private func alertThenHandleVictory() {
        let player = game.activePlayer
        let language = Options.language
        
        let confetti = is2ndPlayer ? defeatConfetti() : victoryConfetti()
        self.view.layer.addSublayer(confetti)
                      
        // Title for lost game when the second player is AI
        var alertTitle: String
        if is2ndPlayer && Options.is2ndPlayerAI {
            alertTitle = LocalizedUI.looserTitle.translate(to: language)
        } else {
            alertTitle = LocalizedUI.winnerTitle.translate(to: language)
        }
        
        alertThenHandleEvent(
            color: is2ndPlayer ? Const.Player2Color : Const.Player1Color,
            title: alertTitle,
            message: LocalizedUI.victoryMessage.translate(name: player.name, to: language)
                + String(player.totalScore),
            handler: {
                confetti.birthRate = 0
                confetti.removeFromSuperlayer()
                
                self.startNewGame()
                self.alertThenHandleNewGame()
            })
    }
    
    private func animateDiceImageView(_ diceImageView: UIImageView, diceFace dice: Int) {
        removeBehaviours(from: diceImageView)
        
        var randomMidX: CGFloat {
            DiceAnimationView.frame.midX + CGFloat.random(in: -50...50)
        }
        var minY: CGFloat {
            diceImageView.frame.height * 0.85 // to be in the bounds (0.75 of a dice height + a bit more)
        }
                
        // Fadeout and reappear at the top of the view
        UIViewPropertyAnimator.runningPropertyAnimator(
            // Make the previous dice disappear
            withDuration: 0.2,
            delay: 0.0,
            options: .curveEaseInOut,
            animations: {
                diceImageView.alpha = 0.0
            }
        ) {_ in
            // Move to the top of the view, add acceleration, appear
            diceImageView.center = CGPoint(x: randomMidX, y: minY)
            diceImageView.image = Const.DiceFaces[dice - 1]
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
        
        diceImageView === dice1ImageView ? pushBehaviourDice1.removeItem(diceImageView) : pushBehaviourDice2.removeItem(diceImageView)
    }
    
    // Add animation behaviours
    private func addBehaviours(to diceImageView: UIImageView) {
        collisionBehavior.addItem(diceImageView)
        bouncingBehavior.addItem(diceImageView)
        gravityBehavior.addItem(diceImageView)
        
        diceImageView === dice1ImageView ? pushBehaviourDice1.addItem(diceImageView): pushBehaviourDice2.addItem(diceImageView)
        
    }
    
    private func roll() {
        // Game mechanics: roll, calculate scores, check conditions, display alerts
        let player = game.activePlayer
        
        player.rollDice()
        
        if let dice1 = player.dice1 {
            animateDiceImageView(dice1ImageView, diceFace: dice1)
        }
        
        if game.gameType == .PigGame2Dice,
           let dice2 = player.dice2 {
            animateDiceImageView(dice2ImageView, diceFace: dice2)
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
    
    private func updateBackgroundImage() {
        backgroundImageView.image = UIImage(named: Options.backgroundImage.rawValue)
    }
    
    private func updateUI() {
        let player = game.activePlayer
        
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

// MARK: Extensions - Methods - Delegated

extension GameViewController: ViewControllerDelegate {
    // Delegation func, to localize UI once the Options are saved
    func optionsViewControllerWillDismiss() {
        updateColorMode()
        updateBackgroundImage()
        localizeUI()
    }
}

extension GameViewController: MotionManagerDelegate {
    // Update gravity direction for dice animation
    func acceleratorDataUpdated(gravityDirection: CGVector) {
        gravityBehavior.gravityDirection = gravityDirection
    }
}

extension GameViewController: UICollisionBehaviorDelegate {
    // Play sound and haptic feedback for dice collisions animation
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
            SoundAndHapticController.playRandomCachedSound()
        }
    }
}

//
//  HelpViewController.swift
//  Pig Dice Game
//
//  Created by Denis Goloborodko on 10/26/20.
//

import UIKit

class HelpViewController: UIViewController {

    // MARK: - Property(s)
    var is2ndPlayer: Bool?
    
    // MARK: - Outlet(s)
    
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var backgroundHelpView: UIView!
    
    @IBOutlet private weak var GameRulesTextView: UITextView!
    @IBOutlet private weak var BackButton: UIButton!
    
    // MARK: - Action(s)
    
    @IBAction private func BackButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeViewRounded(BackButton, withRadius: Const.cornerRadius)
        makeViewRounded(backgroundHelpView, withRadius: Const.cornerRadius)
        
        Options.load()
        updateBackgroundImage()
        localizeUI()
        updateUI()
    }

    // MARK: - Method(s)
    
    private func localizeUI() {
        let language = Options.language
        
        BackButton.setTitle(LocalizedUI.backButton.translate(to: language), for: .normal)
        GameRulesTextView.text = LocalizedUI.gameRulesTextView.translate(to: language)
        GameRulesTextView.textAlignment = .natural
    }
    
    func updateBackgroundImage() {
        backgroundImageView.image = UIImage(named: Options.backgroundImage.rawValue)
    }
    
    private func updateUI() {
        guard let is2ndPlayer = is2ndPlayer else { return }
        let playerColor = is2ndPlayer ? Const.Player2Color : Const.Player1Color
        
        changeColorOfButton(BackButton, to: playerColor)
    }
}

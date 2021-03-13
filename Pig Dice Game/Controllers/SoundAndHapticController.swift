//
//  SoundController.swift
//  Pig Dice Game
//
//  Created by Denis Goloborodko on 14.12.20.
//

import UIKit
import AVFoundation

class SoundAndHapticController {
 
    // MARK: - Property(s)
    
    static private var audioPlayer: AVAudioPlayer?
    static private var hapticGenerator: UIImpactFeedbackGenerator?

    // MARK: - Method(s)
    
    static func playHaptic() {
        hapticGenerator = UIImpactFeedbackGenerator(style: .light)
        hapticGenerator?.impactOccurred()
    }

    static func playSound(_ soundName: String, type: String) {
        guard let soundPath = Bundle.main.path(forResource: soundName, ofType: type) else {
            NSLog("Could not find sound file")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundPath))
            audioPlayer?.play()
        } catch {
            NSLog("Could not play sound, \(error)")
        }
    }
}

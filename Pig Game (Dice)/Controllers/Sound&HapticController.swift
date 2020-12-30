//
//  SoundController.swift
//  Pig Game (Dice)
//
//  Created by Denis Goloborodko on 14.12.20.
//

import UIKit
import AVFoundation

private var audioPlayer: AVAudioPlayer?
//private var hapticGenerator: UINotificationFeedbackGenerator?
private var hapticGenerator: UIImpactFeedbackGenerator?

// TODO: Remove the commented lines
func playHaptic() {
    if Options.isVibrationEnabled {
        //hapticGenerator = UINotificationFeedbackGenerator()
        hapticGenerator = UIImpactFeedbackGenerator(style: .light)
    
        //hapticGenerator?.notificationOccurred(.success)
        //hapticGenerator?.notificationOccurred(.warning)
    
        hapticGenerator?.impactOccurred()
    }
}

func playSound(_ soundName: String, type: String) {
    guard let soundPath = Bundle.main.path(forResource: soundName, ofType: type) else {
        print("Could not find sound file")
        return
    }
    
    do {
        audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundPath))
        audioPlayer?.play()
    } catch {
        print("Could not play sound")
        print(error)
    }
}

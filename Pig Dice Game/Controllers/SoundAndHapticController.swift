//
//  SoundController.swift
//  Pig Dice Game
//
//  Created by Denis Goloborodko on 14.12.20.
//

import UIKit
import AudioToolbox

class SoundAndHapticController {
 
    // MARK: - Property(s)
        
    static private var hapticGenerator: UIImpactFeedbackGenerator?

    static private var cachedSounds: [Sound] = []
    
    private class Sound {
        var soundID: SystemSoundID
        var soundURL: URL
        
        init(soundID: SystemSoundID, soundURL: URL) {
            self.soundID = soundID
            self.soundURL = soundURL
        }
    }
    
    // MARK: - Method(s)
        
    static func playHaptic() {
        hapticGenerator = UIImpactFeedbackGenerator(style: .light)
        hapticGenerator?.impactOccurred()
    }
    
    static func cacheSounds(soundNames: [String], fileType: String) {
        for index in 0..<soundNames.count {
            guard let soundURL = Bundle.main.url(
                    forResource: soundNames[index],
                    withExtension: fileType
            ) else {
                NSLog("Could not find sound file")
                return
            }
            
            let newSound = Sound(soundID: SystemSoundID(index), soundURL: soundURL)
            cachedSounds.append(newSound)
        }
    }
    
    static func playRandomCachedSound() {
        guard let randomCachedSound = cachedSounds.randomElement() else { return }
        
        AudioServicesCreateSystemSoundID(randomCachedSound.soundURL as CFURL, &randomCachedSound.soundID)
        AudioServicesPlaySystemSound(randomCachedSound.soundID)
    }
}

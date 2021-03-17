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

    // MARK: - Method(s)
    
    static func playHaptic() {
        hapticGenerator = UIImpactFeedbackGenerator(style: .light)
        hapticGenerator?.impactOccurred()
    }
    
    #warning("refactor using dictionary and find out something about volume level")
    static func playRandomSound(_ soundNames: [String], type: String) {
        var soundIDs: [SystemSoundID] = []
        var soundURLs: [URL] = []
        
        for index in 0..<soundNames.count {
            guard let soundURL = Bundle.main.url(
                    forResource: soundNames[index],
                    withExtension: Const.SoundFileType
            ) else {
                NSLog("Could not find sound file")
                return
            }
            soundIDs.append(SystemSoundID(index))
            soundURLs.append(soundURL)
        }
        
        let randomSound = Int.random(in: 0..<soundNames.count)
        
        AudioServicesCreateSystemSoundID(soundURLs[randomSound] as CFURL, &soundIDs[randomSound])
        AudioServicesPlaySystemSound(soundIDs[randomSound])
    }
}

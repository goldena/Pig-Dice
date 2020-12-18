//
//  SoundController.swift
//  Pig Game (Dice)
//
//  Created by Denis Goloborodko on 14.12.20.
//

import Foundation
import AVFoundation

var audioPlayer: AVAudioPlayer?

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

//
//  SoundController.swift
//  Pig Dice Game
//
//  Created by Denis Goloborodko on 14.12.20.
//

import UIKit
import AVFoundation
import AudioToolbox

class SoundAndHapticController {

    private class Sound {
        var soundID: SystemSoundID
        var soundURL: URL
        
        init(soundID: SystemSoundID, soundURL: URL) {
            self.soundID = soundID
            self.soundURL = soundURL
        }
    }
    
    // MARK: - Property(s)
    
    static private var hapticGenerator: UIImpactFeedbackGenerator?

    static var musicPlayer: AVAudioPlayer?
    
    static private var musicTrackIndex = 0
    
    static private var cachedSounds: [Sound] = []
        
    // MARK: - Method(s)
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag { SoundAndHapticController.playNext() }
        print("Called delegate")
    }
    
    static private func playMusic(fileName: String, fileType: String) {
        guard let path = Bundle.main.path(forResource: fileName, ofType: fileType) else {
            NSLog("Unable to locate a music file")
            return
        }
        
        do {
            let url = URL(fileURLWithPath: path)
            musicPlayer = try AVAudioPlayer(contentsOf: url)
            
            musicPlayer?.numberOfLoops = -1 // Infinite number of loops
            musicPlayer?.play()
        } catch {
            NSLog("Failed to load file and play music file \(fileName + "." + fileType)")
        }
    }
    
    static func playNext() {
        guard Const.MusicFiles.count > 0 else { return }
        
        musicTrackIndex += 1
        if musicTrackIndex == Const.MusicFiles.count { musicTrackIndex = 0 }
        
        stopMusic()
        playMusic(fileName: Const.MusicFiles[musicTrackIndex], fileType: Const.MusicFileType)
    }
    
    static func stopMusic() {
        guard let musicPlayer = musicPlayer else { return }
        
        if musicPlayer.isPlaying { musicPlayer.stop() }
    }
    
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

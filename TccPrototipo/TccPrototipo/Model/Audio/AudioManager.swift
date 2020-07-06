//
//  AudioManager.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 03/07/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import AVFoundation

class AudioManager {
    private var matchFormSound: AVAudioPlayer!
    private var addSound: AVAudioPlayer!
    private var countDownSound: AVAudioPlayer!
    private var finishedSound: AVAudioPlayer!
    private var gameMusicSound: AVAudioPlayer!
    private var removeSound: AVAudioPlayer!
    private var sandboxMusicSound: AVAudioPlayer!
    private var swapSound: AVAudioPlayer!
    private var wrongAddSound: AVAudioPlayer!
    
    init() {
        DispatchQueue.main.async {
            self.setUpMatchFormSound()
            self.setUpAddSound()
            self.setUpCountDownSound()
            self.setUpFinishedSound()
            self.setUpGameMusicSound()
            self.setUpRemoveSound()
            self.setUpSandboxMusicSound()
            self.setUpSwapSound()
            self.setUpWrongAddSound()
        }
    }
    
    private func setUpMatchFormSound() {
        let soundPath = Bundle.main.path(forResource: "matchForms.mp3", ofType: nil)!
        let soundUrl = URL(fileURLWithPath: soundPath)
        
        matchFormSound = try! AVAudioPlayer(contentsOf: soundUrl)
        matchFormSound.prepareToPlay()
    }
    
    private func setUpAddSound() {
        let soundPath = Bundle.main.path(forResource: "add.mp3", ofType: nil)!
        let soundURL = URL(fileURLWithPath: soundPath)
        
        addSound = try! AVAudioPlayer(contentsOf: soundURL)
        addSound.prepareToPlay()
    }
    
    private func setUpCountDownSound() {
        let soundPath = Bundle.main.path(forResource: "countDown.mp3", ofType: nil)!
        let soundURL = URL(fileURLWithPath: soundPath)
        
        countDownSound = try! AVAudioPlayer(contentsOf: soundURL)
        countDownSound.prepareToPlay()
    }
    
    private func setUpFinishedSound() {
        let soundPath = Bundle.main.path(forResource: "finished.mp3", ofType: nil)!
        let soundURL = URL(fileURLWithPath: soundPath)
        
        finishedSound = try! AVAudioPlayer(contentsOf: soundURL)
        finishedSound.prepareToPlay()
    }
    
    private func setUpGameMusicSound() {
        let soundPath = Bundle.main.path(forResource: "gameMusic.mp3", ofType: nil)!
        let soundURL = URL(fileURLWithPath: soundPath)
        
        gameMusicSound = try! AVAudioPlayer(contentsOf: soundURL)
        gameMusicSound.numberOfLoops = -1
        gameMusicSound.volume = 0.1
        gameMusicSound.prepareToPlay()
    }
    
    private func setUpRemoveSound() {
        let soundPath = Bundle.main.path(forResource: "remove.mp3", ofType: nil)!
        let soundURL = URL(fileURLWithPath: soundPath)
        
        removeSound = try! AVAudioPlayer(contentsOf: soundURL)
        removeSound.prepareToPlay()
    }
    
    private func setUpSandboxMusicSound() {
        let soundPath = Bundle.main.path(forResource: "sandboxMusic.mp3", ofType: nil)!
        let soundURL = URL(fileURLWithPath: soundPath)
        
        sandboxMusicSound = try! AVAudioPlayer(contentsOf: soundURL)
        sandboxMusicSound.numberOfLoops = -1
        sandboxMusicSound.volume = 0.1
        sandboxMusicSound.prepareToPlay()
    }
    
    private func setUpSwapSound() {
        let soundPath = Bundle.main.path(forResource: "swap.mp3", ofType: nil)!
        let soundURL = URL(fileURLWithPath: soundPath)
        
        swapSound = try! AVAudioPlayer(contentsOf: soundURL)
        swapSound.prepareToPlay()
    }
    
    private func setUpWrongAddSound() {
        let soundPath = Bundle.main.path(forResource: "wrongAdd.mp3", ofType: nil)!
        let soundURL = URL(fileURLWithPath: soundPath)
        
        wrongAddSound = try! AVAudioPlayer(contentsOf: soundURL)
        wrongAddSound.prepareToPlay()
    }
    
    
    func playMatchForm() {
        matchFormSound.play()
    }
    
    
    func playAdd() {
        addSound.play()
    }
    
    func playCountDown() {
        countDownSound.play()
    }
    
    func playFinished() {
        finishedSound.play()
        stopGameMusic()
    }
    
    func playGameMusic() {
        gameMusicSound.play()
    }
    
    func playRemove() {
        removeSound.play()
    }
    
    func playSandboxMusic() {
        sandboxMusicSound.play()
    }
    
    func playSwap() {
        swapSound.play()
    }
    
    func playWrongAdd() {
        wrongAddSound.play()
    }
    
    func stopGameMusic() {
        gameMusicSound.stop()
    }
    
    func stopSandboxMusic() {
        sandboxMusicSound.stop()
    }
    
}

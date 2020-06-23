//
//  Game.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 22/06/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import Foundation

class Game {
    
    enum Step {
        case waiting
        case placing
        case starting
        case counting
        case randomizing
        case playing
        case finished
    }
    
    var current: Step!
    var duration: Int = 2 // seconds
    var viewController: GameViewController!
    
    init(viewController: GameViewController) {
        self.current = .waiting
        self.viewController = viewController
    }
    
    func change(to next: Step) {
        switch (current, next) {
        case (.waiting, .waiting):
            print("gave up")
            viewController.waitingToWaiting()
        case (.waiting, .placing):
            print("waited -> placing")
            viewController.waitingToPlacing()
        case (.placing, .starting):
            print("placed -> starting")
            viewController.placingToStarting()
        case (.starting, .counting):
            print("started -> counting")
            viewController.startingToCounting()
        case (.counting, .playing):
            print("counted -> playing")
            viewController.countingToPlaying()
        case (.playing, .finished):
            print("played -> finished")
            viewController.playingToFinished()
        case (.finished, .starting):
            print("finished -> starting")
            viewController.finishedToStarting()
        case (.finished, .waiting):
            print("finished -> waiting")
            viewController.finishedToWaiting()
        default:
            fatalError("Went from  \(current!) to \(next)")
        }
        current = next
    }
}

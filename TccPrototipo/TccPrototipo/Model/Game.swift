//
//  Game.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 22/06/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import UIKit
import RealityKit

class GameManager: Manager {
    
    enum Step {
        case waiting
        case placing
        case starting
        case counting
        case playing
        case finished
    }
    
    static let shared = GameManager()
    
    var board: GameBoard!
    
    var current: Step!
    
    var duration: Int = 60 // seconds
        
    var highScore: Int = 0
    
    private var score: Int = 0
    
    private var pointsPerCombination: Int = 10
    
    var moveDuration: TimeInterval!
    
    var moveDistance: Float!

    var minimumArea: Double = 0.05
            
    private override init() {
        self.current = .waiting
    }
    
    func createBoard(viewController: GameViewController, view: ARView) {
        board = GameBoard(view: view,
                      entitieTypes: EntityProperties.shared.entitieTypes,
                      colors: EntityProperties.shared.colors,
                      mapMatches: EntityProperties.shared.mapMatches)
        
        board.delegate = viewController
    }
    
    func change(viewController: GameViewController, to next: Step) {
        switch (current, next) {
        case (.waiting, .waiting):
            print("gave up")
            viewController.waitingToWaiting()
        case (.waiting, .placing):
            print("waited -> placing")
            viewController.waitingToPlacing()
        case (.placing, .waiting):
            print("placed -> waiting")
            viewController.placingToWaiting()
        case (.placing, .starting):
            print("placed -> starting")
            viewController.placingToStarting()
        case (.starting, .counting):
            print("started -> counting")
            viewController.startingToCounting()
        case (.starting, .waiting):
            print("started -> waiting")
            viewController.startingToWaiting()
        case (.counting, .playing):
            print("counted -> playing")
            viewController.countingToPlaying()
            configureMoveSpeed()
        case (.playing, .finished):
            print("played -> finished")
            countScores(viewController: viewController)
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
    
    func newCombination() -> Int {
        score += pointsPerCombination
        
        return score
    }
    
    func resetPoints() -> Int {
        score = 0
        
        return score
    }
    
    private func countScores(viewController: GameViewController) {
        if score > highScore {
            highScore = score
        }
        
        viewController.updateScores(score: score, highScore: highScore)
    }
    
    private func configureMoveSpeed() {
        let size = board.getGeometriesSize()
        
        moveDistance = Float(200 * size)
        moveDuration = TimeInterval(3 * moveDistance)
    }
}

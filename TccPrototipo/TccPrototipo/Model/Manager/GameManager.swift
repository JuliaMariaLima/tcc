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
    
    weak var delegate: GameDelegate?
    
    private var score: Int = 0
    
    private var pointsPerCombination: Int = 10
    
    var minimumArea: Double = 0.05
            
    private override init() {
        super.init()
        self.current = .waiting
    }
    
    func createBoard(delegate: GameDelegate?, view: ARView) {
        board = GameBoard(view: view,
                      entitieTypes: EntityProperties.shared.entitieTypes,
                      colors: EntityProperties.shared.colors,
                      mapMatches: EntityProperties.shared.mapMatches)
        
        
        board.delegate = delegate
    }
    
    func change(to next: Step) {
        switch (current, next) {
        case (.waiting, .waiting):
            delegate?.waitingToWaiting()
        case (.waiting, .placing):
            delegate?.waitingToPlacing()
        case (.placing, .waiting):
            delegate?.placingToWaiting()
        case (.placing, .starting):
            delegate?.placingToStarting()
        case (.starting, .counting):
            delegate?.startingToCounting()
        case (.starting, .waiting):
            delegate?.startingToWaiting()
        case (.counting, .playing):
            delegate?.countingToPlaying()
            configureMoveSpeed()
        case (.playing, .finished):
            countScores()
            delegate?.playingToFinished()
        case (.finished, .starting):
            delegate?.finishedToStarting()
        case (.finished, .waiting):
            delegate?.finishedToWaiting()
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
    
    private func countScores() {
        if score > highScore {
            highScore = score
        }
        
        delegate?.updateScores(score: score, highScore: highScore)
    }
    
    private func configureMoveSpeed() {
        let size = board.getGeometriesSize()
        
        set(moveDistance: Float(200 * size))
    }
}

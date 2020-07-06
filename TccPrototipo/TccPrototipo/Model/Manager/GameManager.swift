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
    
    var level: Int! = 1
    
    var matchesNeeded: Int {
        return level
    }
    
    var currentMatches: Int = 0 {
        didSet {
            if currentMatches == matchesNeeded {
                nextLevel()
            }
        }
    }
    
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
        case (.finished, .counting):
            delegate?.finishedToCounting()
        case (.finished, .waiting):
            delegate?.finishedToWaiting()
        default:
            fatalError("Went from  \(current!) to \(next)")
        }
        current = next
    }
    
    func newCombination() -> Int {
        score += pointsPerCombination
        currentMatches += 1
        
        return score
    }
    
    func addMore(points: Int) {
        score += points
    }
    
    func resetPoints() -> Int {
        restartGame()
        
        score = 0
        
        return score
    }
    
    private func restartGame() {
        level = 1
        currentMatches = 0
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
    
    private func nextLevel() {
        delegate?.nextLevel(level)
        level += 1
        currentMatches = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.board.createNewBoard()
        }
    }
}

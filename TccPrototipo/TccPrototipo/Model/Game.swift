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
        case playing
        case finished
    }
    
    var current: Step!
    
    var viewController: GameViewController!

    var duration: Int = 60 // seconds
        
    var highScore: Int = 0
    
    var moveDuration: TimeInterval = 30
    
    var moveDistance: Float = 10

    var entitieTypes: [GeometryType] = []
    
    var mapMatches: [GeometryType:[GeometryType]] = [:]
    
    var minimumArea: Double = 0.05
    
    init(viewController: GameViewController) {
        self.current = .waiting
        self.viewController = viewController
        
        setUpEntitiesTypes()
        setUpMatches()
    }
    
    func change(to next: Step) {
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
    
    func updateHighScore(_ newHighScore: Int) {
        highScore = newHighScore
    }
    
    private func setUpEntitiesTypes() {
        entitieTypes.append(.Cube)
        entitieTypes.append(.QuadrilateralPyramid)
        entitieTypes.append(.TriangularPrism)
        entitieTypes.append(.SemiSphere)
        entitieTypes.append(.Cylinder)
        entitieTypes.append(.PentagonalPrism)
        entitieTypes.append(.Tetrahedron)
        entitieTypes.append(.Cone)
        entitieTypes.append(.PentagonalPyramid)
    }
    
    private func setUpMatches() {
        mapMatches[.Cube] = [.Cube]
        mapMatches[.QuadrilateralPyramid] = [.Cube]
        mapMatches[.TriangularPrism] = [.TriangularPrism]
        mapMatches[.SemiSphere] = [.Cylinder]
        mapMatches[.Cylinder] = [.Cylinder]
        mapMatches[.PentagonalPrism] = [.PentagonalPrism]
        mapMatches[.Tetrahedron] = [.TriangularPrism]
        mapMatches[.Cone] = [.Cylinder]
        mapMatches[.PentagonalPyramid] = [.PentagonalPrism]
    }
}

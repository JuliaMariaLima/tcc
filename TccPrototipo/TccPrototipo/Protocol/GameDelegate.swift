//
//  GameDelegate.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 22/06/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import RealityKit

protocol GameDelegate: class {
    func waitingToWaiting()
    
    func waitingToPlacing()
    
    func placingToWaiting()
    
    func placingToStarting()
    
    func startingToCounting()
    
    func startingToWaiting()
    
    func countingToPlaying()
    
    func playingToFinished()
    
    func finishedToCounting()
    
    func finishedToWaiting()
    
    func placed(area: Double)
    
    func counted()
        
    func updatedEntities(_ entities: [GeometryEntity])
        
    func updateScores(score: Int, highScore: Int)
    
    func played()
}

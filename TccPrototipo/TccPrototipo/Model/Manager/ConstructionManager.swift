//
//  ConstructionManager.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 30/06/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import RealityKit

class ConstructionManager: Manager {
    
    enum Step {
        case initializing
        case placing
        case adding
        case classifying
        case constructing
        case looking
        case leaving
    }
    
    static let shared = ConstructionManager()
    
    var board: ConstructionBoard!
    
    var current: Step!
    
    weak var delegate: ConstructionDelegate?
    
    private override init() {
        super.init()
        self.current = .initializing
        set(moveDistance: 40)
    }
    
    func createBoard(delegate: ConstructionDelegate?, view: ARView) {
        board = ConstructionBoard(view: view,
                      entitieTypes: EntityProperties.shared.entitieTypes,
                      colors: EntityProperties.shared.colors,
                      mapMatches: EntityProperties.shared.mapMatches)
        
        board.delegate = delegate
    }
    
    func change(to next: Step) {
        switch (current, next) {
        case (.initializing, .placing):
            print("initializing -> placing")
            delegate?.initializingToPlacing()
        case (.initializing, .initializing):
            print("initializing -> waiting")
            delegate?.initializingToInitializing()
        case (.placing, .looking):
            print("placing -> looking")
            delegate?.placingToLooking()
        case (.looking, .adding):
            print("looking -> adding")
            delegate?.lookingToAdding()
        case (.looking, .constructing):
            print("looking -> constructing")
            delegate?.lookingToConstructing()
        case (.looking, .leaving):
            print("looking -> leaving")
            delegate?.lookingToLeaving()
        case (.adding, .looking):
            print("adding -> looking")
            delegate?.addingToLooking()
        case (.adding, .classifying):
            print("adding -> classifying")
            delegate?.addingToClassifying()
        case (.constructing, .looking):
            print("constructing -> looking")
            delegate?.constructingToLooking()
        case (.constructing, .leaving):
            print("constructing -> leaving")
            delegate?.constructingToLeaving()
        case (.classifying, .constructing):
            print("classifying -> constructing")
            delegate?.classifyingToConstructing()
        case (.classifying, .adding):
            print("classifying -> adding")
            delegate?.classifyingToAdding()
        case (.leaving, .initializing):
            print("leaving -> initializing")
            delegate?.leavingToInitializing()
        case (.leaving, .looking):
            print("leaving -> looking")
            delegate?.leavingToLooking()
        default:
            fatalError("Went from  \(current!) to \(next)")
        }
        
        current = next
    }
}

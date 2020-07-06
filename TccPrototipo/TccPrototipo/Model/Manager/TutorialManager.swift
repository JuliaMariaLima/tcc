//
//  TutorialManager.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 05/07/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import RealityKit

class TutorialManager: Manager {
    
    static let shared = TutorialManager()
    
    var board: Board!
    
    var isFirstTime: Bool = true
    
    private override init() {
        super.init()
        
        set(moveDistance: 40)
    }
    
    
    func createBoard(view: ARView) {
        board = ConstructionBoard(view: view,
                      entitieTypes: EntityProperties.shared.entitieTypes,
                      colors: EntityProperties.shared.colors,
                      mapMatches: EntityProperties.shared.mapMatches)
        
        board.set(geometriesSize: 0.2)
    }
}

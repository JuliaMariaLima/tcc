//
//  Manager.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 30/06/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import Foundation
import RealityKit

class Manager {
    private var moveDuration: TimeInterval!
    
    private var moveDistance: Float! {
        didSet {
            moveDuration = TimeInterval(3 * moveDistance)
        }
    }
        
    func set(moveDistance: Float) {
        self.moveDistance = moveDistance
    }
    
    func getMoveDistance() -> Float {
        return moveDistance
    }
    
    func getMoveDuration() -> TimeInterval {
        return moveDuration
    }
}

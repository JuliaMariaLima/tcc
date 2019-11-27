//
//  Cube.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 10/11/19.
//  Copyright © 2019 Julia Maria Santos. All rights reserved.
//

import Foundation
import RealityKit
import Combine

class CubeEntity: Entity, HasModel, HasCollision, HasPhysics {
    var collisionSubs: [Cancellable] = []
    
    required init(color: SimpleMaterial.Color) {
        super.init()
        let size: SIMD3<Float> = [0.5, 0.5, 0.5]
        self.model = ModelComponent(
            mesh: .generateBox(size: size),
            materials: [SimpleMaterial(
                color: color,
                isMetallic: false)
            ]
        )
        self.generateCollisionShapes(recursive: true)
        
        self.physicsBody = PhysicsBodyComponent(shapes: [.generateBox(size: size)], density: 2)
//        self.physicsBody?.isTranslationLocked = (false, true, false)
        self.physicsBody?.mode = .kinematic
//        self.physicsBody?.isContinuousCollisionDetectionEnabled = true
        self.physicsBody?.isRotationLocked = (true, true, true)
    }
    required init() {
        fatalError("init() has not been implemented")
    }
}

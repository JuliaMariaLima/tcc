//
//  Floor.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 03/12/19.
//  Copyright © 2019 Julia Maria Santos. All rights reserved.
//

import Foundation
import RealityKit
import Combine

class FloorEntity: Entity, HasModel, HasCollision, HasPhysics {
    var collisionSubs: [Cancellable] = []
    
    required init(color: SimpleMaterial.Color) {
        super.init()
        self.model = ModelComponent(
            mesh: .generatePlane(width: 10, depth: 10),
            materials: [SimpleMaterial(
                color: color,
                isMetallic: false)
            ]
        )
        self.generateCollisionShapes(recursive: false)
        
        self.physicsBody = PhysicsBodyComponent()
        self.physicsBody?.isTranslationLocked = (false, true, false)
        self.physicsBody?.mode = .kinematic
        self.physicsBody?.isContinuousCollisionDetectionEnabled = true
        self.physicsBody?.isRotationLocked = (true, true, true)
    }
    required init() {
        fatalError("init() has not been implemented")
    }
    
    func addCollision() {
        guard let scene = scene else { return }

        collisionSubs.append(scene.subscribe(to: CollisionEvents.Began.self, on: self) { event in
            self.physicsBody?.mode = .dynamic
        })
        
        collisionSubs.append(scene.subscribe(to: CollisionEvents.Ended.self, on: self) { event in
            self.physicsBody?.mode = .kinematic
        })
    }
}

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
        let side: Float = 0.2
        let size: SIMD3<Float> = [side, side, side]
        self.model = ModelComponent(
            mesh: .generateBox(size: size),
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
        
        collisionSubs.append(scene.subscribe(to: CollisionEvents.Updated.self, on: self) { event in
            self.physicsBody?.mode = .dynamic
        })
        
        collisionSubs.append(scene.subscribe(to: CollisionEvents.Ended.self, on: self) { event in
            self.physicsBody?.mode = .kinematic
        })
    }
    
    func cancelCollision() {        
        for collision in collisionSubs {
            collision.cancel()
        }
        self.physicsBody?.mode = .kinematic
    }
}

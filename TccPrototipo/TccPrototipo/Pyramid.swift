//
//  Pyramid.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 30/11/19.
//  Copyright © 2019 Julia Maria Santos. All rights reserved.
//

import Foundation
import RealityKit
import Combine

class PyramidEntity: Entity, HasModel, HasCollision, HasPhysics {
    var collisionSubs: [Cancellable] = []
    
    required init(color: SimpleMaterial.Color) {
        super.init()
        let modelHolder = try! ModelEntity.loadModel(named: "pyramid.obj")
        let modelSize = 19.525
        let wantedSize = 0.2
        let scale: Float = Float(1 / (modelSize / wantedSize))

        self.setScale(SIMD3<Float>.init(scale, scale, scale), relativeTo: self)

        self.model = modelHolder.model
        self.model?.materials = [SimpleMaterial(color: color, isMetallic: false)]
        
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

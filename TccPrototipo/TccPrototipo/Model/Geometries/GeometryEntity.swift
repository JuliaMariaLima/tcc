//
//  GeometryEntity.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 23/03/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import Foundation
import RealityKit
import Combine


class GeometryEntity: Entity, HasModel, HasCollision, HasPhysics {
    var collisionSubs: [Cancellable] = []
    var type: GeometryType!
    
    required init(type: GeometryType) {
        super.init()
        
        self.type = type
        
        self.generateCollisionShapes(recursive: false)
        
        self.physicsBody = PhysicsBodyComponent()
        self.physicsBody?.isTranslationLocked = (false, true, false)
        self.physicsBody?.mode = .kinematic
//        self.physicsBody?.isContinuousCollisionDetectionEnabled = true
        self.physicsBody?.isRotationLocked = (true, true, true)
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    func addCollision() {
//        guard let scene = scene else { return }

//        collisionSubs.append(scene.subscribe(to: CollisionEvents.Began.self, on: self) { event in
////            self.stopAllAnimations()
////            self.physicsBody?.mode = .dynamic //testar sem mudar
//        })
//
//        collisionSubs.append(scene.subscribe(to: CollisionEvents.Updated.self, on: self) { event in
////            self.stopAllAnimations()
////            self.physicsBody?.mode = .kinematic
//        })
//
//        collisionSubs.append(scene.subscribe(to: CollisionEvents.Ended.self, on: self) { event in
//            self.physicsBody?.mode = .kinematic
//        })
    }
    
    func cancelCollision() {
        for collision in collisionSubs {
            collision.cancel()
        }
        self.physicsBody?.mode = .kinematic
    }
}

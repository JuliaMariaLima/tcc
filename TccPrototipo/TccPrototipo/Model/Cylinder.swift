//
//  Cylinder.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 20/03/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import Foundation
import RealityKit
import Combine

class CylinderEntity: GeometryEntity {
    
    required init(color: SimpleMaterial.Color) {
        super.init(type: .Cylinder)
        let modelHolder = try! ModelEntity.loadModel(named: "cylinder.obj")
        let modelSize = 1.0
        let wantedSize = 0.2
        let scale: Float = Float(1 / (modelSize / wantedSize))

        self.setScale(SIMD3<Float>.init(scale, scale, scale), relativeTo: self)


        self.model = modelHolder.model
        self.model?.materials = [SimpleMaterial(color: color, isMetallic: false)]
    }
    required init() {
        fatalError("init() has not been implemented")
    }
    
    required init(type: GeometryType) {
        fatalError("init(type:) has not been implemented")
    }
}

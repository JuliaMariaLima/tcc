//
//  Octahedron.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 20/03/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import Foundation
import RealityKit
import Combine

class OctahedronEntity: GeometryEntity {
    
    required init(color: SimpleMaterial.Color, size: Double) {
        super.init(type: .Octahedron)
        let modelHolder = try! ModelEntity.loadModel(named: "octahedron.obj")
        let modelSize = 1.0
        let wantedSize = size
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

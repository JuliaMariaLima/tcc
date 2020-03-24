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

class CubeEntity: GeometryEntity {
    
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
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
}

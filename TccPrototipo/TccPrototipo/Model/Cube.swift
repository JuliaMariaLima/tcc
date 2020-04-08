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
        super.init(type: .Cube)
        let modelHolder = try! ModelEntity.loadModel(named: "cube.obj")
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

//
//  Cone.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 20/03/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import Foundation
import RealityKit
import Combine

class ConeEntity: GeometryEntity {
    
    required init(color: SimpleMaterial.Color, size: Double) {
        super.init(type: .Cone)
        let modelHolder = try! ModelEntity.loadModel(named: "cone.obj")
        let modelWidthSize = 1.0
        let modelHeightSize = 1.0
        let modelDepthSize = 0.998
        let wantedSize = size
        
        self.setScale(SIMD3<Float>.init(
            Float(wantedSize / modelWidthSize),
            Float(wantedSize / modelHeightSize),
            Float(wantedSize / modelDepthSize)),
                      relativeTo: self)

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

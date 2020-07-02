//
//  Tetrahedron.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 20/03/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import Foundation
import RealityKit
import Combine

class TetrahedronEntity: GeometryEntity {
    
    required init(color: SimpleMaterial.Color, size: Double) {
        super.init(type: .Tetrahedron)
        let modelHolder = try! ModelEntity.loadModel(named: "tetrahedron.obj")
        let modelWidthSize = 0.966
        let modelHeightSize = 1.0
        let modelDepthSize = 0.966
        let wantedSizeWD = size * modelWidthSize
        let wantedSizeH = size
        
        self.setScale(SIMD3<Float>.init(
            Float(wantedSizeWD / modelWidthSize),
            Float(wantedSizeH / modelHeightSize),
            Float(wantedSizeWD / modelDepthSize)),
                      relativeTo: self)

//        self.setOrientation(simd_quatf.init(angle: Float.pi / 2.4, axis: [0, 1, 0]), relativeTo: self)
        
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

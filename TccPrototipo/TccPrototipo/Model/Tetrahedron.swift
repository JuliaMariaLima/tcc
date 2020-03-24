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
    
    required init(color: SimpleMaterial.Color) {
        super.init()
        let modelHolder = try! ModelEntity.loadModel(named: "tetrahedron.obj")
        let modelWidthSize = 0.966
        let modelHeightSize = 1.0
        let modelDepthSize = 0.966
        let wantedSizeWD = 0.2
        let wantedSizeH = 0.2309401077 // all sides equal
        self.setScale(SIMD3<Float>.init(
            Float(1 / (modelWidthSize / wantedSizeWD)),
            Float(1 / (modelHeightSize / wantedSizeH)),
            Float(1 / (modelDepthSize / wantedSizeWD))),
                      relativeTo: self)

        self.model = modelHolder.model
        self.model?.materials = [SimpleMaterial(color: color, isMetallic: false)]
    }
    required init() {
        fatalError("init() has not been implemented")
    }
}

//
//  TriangularPrism.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 20/03/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import Foundation
import RealityKit
import Combine

class TriangularPrismEntity: GeometryEntity {    
    
    required init(color: SimpleMaterial.Color) {
        super.init()
        let modelHolder = try! ModelEntity.loadModel(named: "triangularPrism.obj")
        let modelWidthSize = 9.195
        let modelHeightSize = 9.697
        let modelDepthSize = 7.963
        let wantedSize = 0.2

        self.setScale(SIMD3<Float>.init(
            Float(1 / (modelWidthSize / wantedSize)),
            Float(1 / (modelHeightSize / wantedSize)),
            Float(1 / (modelDepthSize / wantedSize))),
                      relativeTo: self)

        self.model = modelHolder.model
        self.model?.materials = [SimpleMaterial(color: color, isMetallic: false)]
    }
    required init() {
        fatalError("init() has not been implemented")
    }
}
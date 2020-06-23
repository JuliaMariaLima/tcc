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
    
    required init(color: SimpleMaterial.Color, size: Double) {
        super.init(type: .TriangularPrism)
        let modelHolder = try! ModelEntity.loadModel(named: "triangularPrism.obj")
        let modelWidthSize = 9.195
        let modelHeightSize = 9.697
        let modelDepthSize = 7.963
        let wantedSizeWH = size
        let wantedSizeD = size * 0.866025404

        self.setScale(SIMD3<Float>.init(
            Float(1 / (modelWidthSize / wantedSizeWH)),
            Float(1 / (modelHeightSize / wantedSizeWH)),
            Float(1 / (modelDepthSize / wantedSizeD))),
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

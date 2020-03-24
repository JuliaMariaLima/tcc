//
//  QuadrilateralPyramid.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 30/11/19.
//  Copyright © 2019 Julia Maria Santos. All rights reserved.
//

import Foundation
import RealityKit
import Combine

class QuadrilateralPyramidEntity: GeometryEntity {
    
    required init(color: SimpleMaterial.Color) {
        super.init()
        let modelHolder = try! ModelEntity.loadModel(named: "quadrilateralPyramid.obj")
        let modelSize = 19.525
        let wantedSize = 0.2
        let scale: Float = Float(1 / (modelSize / wantedSize))

        self.setScale(SIMD3<Float>.init(scale, scale, scale), relativeTo: self)

        self.model = modelHolder.model
        self.model?.materials = [SimpleMaterial(color: color, isMetallic: false)]
    }
    required init() {
        fatalError("init() has not been implemented")
    }
}

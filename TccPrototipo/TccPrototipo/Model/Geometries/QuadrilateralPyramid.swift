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
    
    required init(color: SimpleMaterial.Color, size: Double) {
        super.init(type: .QuadrilateralPyramid)
        let modelHolder = try! ModelEntity.loadModel(named: "quadrilateralPyramid.obj")
        let modelSize = 19.525
        let wantedSize = size
        let scale: Float = Float(wantedSize / modelSize)

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

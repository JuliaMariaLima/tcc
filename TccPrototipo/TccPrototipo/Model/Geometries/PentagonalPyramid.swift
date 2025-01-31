//
//  PentagonalPyramid.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 20/03/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import Foundation
import RealityKit
import Combine

class PentagonalPyramidEntity: GeometryEntity {
    
    required init(color: SimpleMaterial.Color, size: Double) {
        super.init(type: .PentagonalPyramid)
        let modelHolder = try! ModelEntity.loadModel(named: "pentagonalPyramid.obj")
        let modelWidthSize = 0.095
        let modelHeightSize = 0.05
        let modelDepthSize = 0.09
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

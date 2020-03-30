//
//  PentagonalPrism.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 20/03/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import Foundation
import RealityKit
import Combine

class PentagonalPrismEntity: GeometryEntity {
    
    required init(color: SimpleMaterial.Color) {
        super.init(type: .PentagonalPrism)
        let modelHolder = try! ModelEntity.loadModel(named: "pentagonalPrism.obj")
        let modelWidthSize = 1.618
        let modelHeightSize = 1.0
        let modelDepthSize = 1.539
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
    
    required init(type: GeometryType) {
        fatalError("init(type:) has not been implemented")
    }
}

//
//  OrientationEntity.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 26/06/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import RealityKit

class OrientationEntity:  Entity, HasModel {
    required init(size: Double) {
        super.init()
        let modelHolder = try! ModelEntity.loadModel(named: "arrows.obj")
        let modelWidthSize = 20.0
        let modelHeightSize = 20.0
        let modelDepthSize = 0.998
        let wantedSize = size
        
        self.setScale(SIMD3<Float>.init(
            Float(wantedSize / modelWidthSize),
            Float(wantedSize / modelHeightSize),
            Float((wantedSize / 20) / modelDepthSize)),
                      relativeTo: self)

        self.model = modelHolder.model
        self.model?.materials = [SimpleMaterial(color: .lightGreen, isMetallic: false)]
    }
    required init() {
        fatalError("init() has not been implemented")
    }
}

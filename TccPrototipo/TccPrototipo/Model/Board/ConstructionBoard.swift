//
//  ConstructionBoard.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 29/06/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import UIKit
import RealityKit
import ARKit

class ConstructionBoard: Board {
    weak var delegate: ConstructionDelegate?
    
    override init(view: ARView,
                  entitieTypes: [GeometryType],
                  colors: [UIColor],
                  mapMatches: [GeometryType : [GeometryType]]) {
        
        super.init(view: view, entitieTypes: entitieTypes, colors: colors, mapMatches: mapMatches)
        set(geometriesSize: 0.2)
    }
    
    func encode() -> [SIMD3<Float>:GeometryType] {
        var map: [SIMD3<Float>:GeometryType] = [:]
        let reference = getReference()
        
        for entity in entities {
            let position = entity.position(relativeTo: reference)
            map[position] = entity.type
        }
        
        return map
    }
    
    func decode(map: [SIMD3<Float>:GeometryType], reference: AnchorEntity) {
        set(reference: reference)
        
        for (position, entityType) in map {
            createEntity(in: position, entityType)
        }
    }
}

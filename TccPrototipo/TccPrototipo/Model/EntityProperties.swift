//
//  EntityProperties.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 29/06/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import UIKit

class EntityProperties {
    static let shared = EntityProperties()
    
    private var _entitieTypes: [GeometryType] = []
    private var _mapMatches: [GeometryType:[GeometryType]] = [:]
    private var _colors: [UIColor] = []
    private var _mapFaceToTypes: [String:[GeometryType]] = [:]
    
    var entitieTypes: [GeometryType] {
        return _entitieTypes
    }
    
    var mapMatches: [GeometryType:[GeometryType]] {
        return _mapMatches
    }
    
    var colors: [UIColor] {
        return _colors
    }
    
    var mapFaceToTypes: [String:[GeometryType]] {
        return _mapFaceToTypes
    }

    private init() {
        _entitieTypes = setUpEntitiesTypes()
        _mapMatches = setUpMatches()
        _colors = setUpColors()
        _mapFaceToTypes = setUpFaceToTypes()
    }
    
    func randomGeometry(by name: String) -> GeometryType? {
        switch name {
        case "circle":
            break
        case "square":
            break
        case "triangle":
            break
        case "pentagon":
            break
        default:
            return nil
        }
        
        return .Cone
    }
    
    private func setUpEntitiesTypes() -> [GeometryType] {
        var types: [GeometryType] = []
        
        types.append(.Cube)
        types.append(.QuadrilateralPyramid)
        types.append(.TriangularPrism)
        types.append(.SemiSphere)
        types.append(.Cylinder)
        types.append(.PentagonalPrism)
        types.append(.Tetrahedron)
        types.append(.Cone)
        types.append(.PentagonalPyramid)
        
        return types
    }
    
    private func setUpMatches() -> [GeometryType:[GeometryType]] {
        var matches: [GeometryType:[GeometryType]] = [:]
        
        matches[.Cube] = [.Cube]
        matches[.QuadrilateralPyramid] = [.Cube]
        matches[.TriangularPrism] = [.TriangularPrism]
        matches[.SemiSphere] = [.Cylinder]
        matches[.Cylinder] = [.Cylinder]
        matches[.PentagonalPrism] = [.PentagonalPrism]
        matches[.Tetrahedron] = [.TriangularPrism]
        matches[.Cone] = [.Cylinder]
        matches[.PentagonalPyramid] = [.PentagonalPrism]
        
        return matches
    }
    
    private func setUpColors() -> [UIColor] {
        var c: [UIColor] = []
        
        c.append(.blue)
        c.append(.borderRed)
        c.append(.labelYellow)
        
        return c
    }
    
    private func setUpFaceToTypes() -> [String:[GeometryType]] {
        var map: [String:[GeometryType]] = [:]
        
        map["circle"] = [.SemiSphere, .Cylinder, .Cone]
        map["square"] = [.Cube, .QuadrilateralPyramid]
        map["triangle"] = [.TriangularPrism, .Tetrahedron]
        map["pentagon"] = [.PentagonalPrism, .PentagonalPyramid]
        
        return map
    }
}

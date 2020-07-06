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
    private var _mapTypeToFace: [GeometryType:String] = [:]
    
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
    
    var mapTypeToFace: [GeometryType:String] {
        return _mapTypeToFace
    }

    private init() {
        _entitieTypes = setUpEntitiesTypes()
        _mapMatches = setUpMatches()
        _colors = setUpColors()
        _mapFaceToTypes = setUpFaceToTypes()
        _mapTypeToFace = setUpTypeToFace()
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
        
        c.append(.circleBlue)
        c.append(.squareRed)
        c.append(.triangleYellow)
        
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
    
    private func setUpTypeToFace() -> [GeometryType:String] {
        var map: [GeometryType:String] = [:]
        
        map[.Cube] = "square"
        map[.QuadrilateralPyramid] = "square"
        map[.TriangularPrism] = "triangle"
        map[.SemiSphere] = "circle"
        map[.Cylinder] = "circle"
        map[.PentagonalPrism] = "pentagon"
        map[.Tetrahedron] = "triangle"
        map[.Cone] = "circle"
        map[.PentagonalPyramid] = "pentagon"
        
        return map
    }
    
}

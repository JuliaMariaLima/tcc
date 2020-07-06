//
//  Board.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 29/06/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import RealityKit
import UIKit
import ARKit

class Board {
    var arView: ARView!
    var entitieTypes: [GeometryType] = []
    var mapMatches: [GeometryType:[GeometryType]] = [:]
    var entities: [GeometryEntity] = []
    
    private var colors: [UIColor] = []
    private var reference: AnchorEntity?
    private var geometriesSize: Double = 0
    private var mapEntitiesCount: [GeometryType:Int] = [:]
    
    init(view: ARView,
         entitieTypes: [GeometryType],
         colors: [UIColor],
         mapMatches: [GeometryType:[GeometryType]]) {
        
        self.arView = view
        self.entitieTypes = entitieTypes
        self.colors = colors
        self.mapMatches = mapMatches
    }
    
    func set(geometriesSize: Double) {
        self.geometriesSize = geometriesSize
    }
    
    func set(reference: AnchorEntity) {
        self.reference = reference
    }
    
    func haveReference() -> Bool {
        guard let _ = reference else { return false }
        
        return true
    }
    
    func getGeometriesSize() -> Double {
        return geometriesSize
    }
    
    func getReference() -> AnchorEntity? {
        return reference
    }
    
    func createEntity(in position: SIMD2<Float>, _ type: GeometryType? = nil) {
        guard let reference = reference else { return }
        
        let position3D = SIMD3<Float>(position.x, reference.position.y, position.y)
        createEntity(in: position3D, type)
    }
    
    func createEntity(in position: SIMD3<Float>, _ type: GeometryType? = nil) {
        let anchorEntity = AnchorEntity()
        anchorEntity.setPosition(position, relativeTo: reference)
        
        let _ = createEntity(in: anchorEntity, type)
    }
    
    func createEntity(from arAnchor: ARAnchor, _ type: GeometryType? = nil) {
        let anchorEntity = AnchorEntity(world: arAnchor.transform)
        
        let _ = createEntity(in: anchorEntity, type)
    }
    
    func createEntity(in anchorEntity: AnchorEntity, _ type: GeometryType? = nil) -> GeometryEntity {
        let randomColor = Int.random(in: 0..<colors.count)
        let randomType = Int.random(in: 0..<entitieTypes.count)
        
        let entity = constructEntity(color: colors[randomColor], size: geometriesSize, type: type ?? entitieTypes[randomType])
        entity.generateCollisionShapes(recursive: false)
        
        arView.scene.addAnchor(anchorEntity)
        anchorEntity.addChild(entity)
        
        entities.append(entity)
        entity.addCollision()
        
        if let reference = reference {
            entity.setOrientation(reference.orientation(relativeTo: reference), relativeTo: reference)

            if entity.type == .Tetrahedron {
                entity.setOrientation(simd_quatf.init(angle: Float.pi / 2.4, axis: [0, 1, 0]), relativeTo: entity)
            }
        }
        
        updateMap(type: entity.type, isAdding: true)
        
        return entity
    }
    
    func removeEntity(_ entity: GeometryEntity) {
        entity.anchor?.removeFromParent()
        
        guard let index = entities.firstIndex(of: entity) else { return }
        
        entities.remove(at: index)
        
        updateMap(type: entity.type, isAdding: false)
    }
    
    
    func didCombine(movingEntity: GeometryEntity, staticEntity: GeometryEntity) -> Bool {
        let staticPosition = staticEntity.position(relativeTo: nil)
        let movingPosition = movingEntity.position(relativeTo: nil)
        
        var goalPosition = staticPosition
        goalPosition.y += Float(geometriesSize)
        
        let dist = distance(staticPosition, movingPosition)
        
        let delta: Float = Float(geometriesSize + geometriesSize * 0.1)
        
        if dist < delta &&
            movingPosition.y > staticPosition.y + Float(geometriesSize - geometriesSize * 0.1) { // encaixou
            
            movingEntity.setPosition(goalPosition, relativeTo: nil)
            
            movingEntity.cancelCollision()
            staticEntity.cancelCollision()
            
            return true
        }
        
        return false
    }
    
    func clearBoard() {
        for entity in entities {
            entity.anchor?.removeFromParent()
        }
        entities.removeAll()
        mapEntitiesCount.removeAll()
    }
    
    func restart() {
        clearBoard()
        reference = nil
    }
    
    func haveACombination() -> Bool {
        for entity in entities {
            if haveAPair(entity) {
                print("have a combination")
                return true
            }
        }
        print("dont have a combination")
        return false
    }
    
    private func haveAPair(_ entity: GeometryEntity) -> Bool {
        let matches = mapMatches[entity.type]!
        
        for match in matches {
            var needed = 1
            if entity.type == match {
                needed = 2
            }
            
            if mapEntitiesCount[match] ?? 0 >= needed {
                return true
            }
        }
        
        return false
    }
    
    private func constructEntity(color: UIColor, size: Double, type: GeometryType) -> GeometryEntity {
        switch type {
        case .Cube:
            return CubeEntity(color: color, size: size)
        case .QuadrilateralPyramid:
            return QuadrilateralPyramidEntity(color: color, size: size)
        case .TriangularPrism:
            return TriangularPrismEntity(color: color, size: size)
        case .SemiSphere:
            return SemiSphereEntity(color: color, size: size)
        case .Cylinder:
            return CylinderEntity(color: color, size: size)
        case .PentagonalPrism:
            return PentagonalPrismEntity(color: color, size: size)
        case .Octahedron:
            return OctahedronEntity(color: color, size: size)
        case .Tetrahedron:
            return TetrahedronEntity(color: color, size: size)
        case .Cone:
            return ConeEntity(color: color, size: size)
        case .PentagonalPyramid:
            return PentagonalPyramidEntity(color: color, size: size)
        }
    }
    
    private func updateMap(type: GeometryType, isAdding: Bool) {
        var count: Int = 0
        if mapEntitiesCount[type] != nil {
            count = mapEntitiesCount[type]!
        }
            
        if isAdding {
            count += 1
        } else {
            count -= 1
        }
        mapEntitiesCount.updateValue(count, forKey: type)
    }
}

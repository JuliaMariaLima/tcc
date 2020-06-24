//
//  Board.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 22/06/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import RealityKit
import ARKit

class Board {
    private var arView: ARView!
    private var entitieTypes: [GeometryType] = []
    private var colors: [UIColor] = []
    private var isAddingPoins = true
    private var anchors: [AnchorEntity] = [] {
        didSet {
            guard case anchors.count = 4 else { return }
            finishInitialPointsPlacement()
        }
    }
    
    private var first: AnchorEntity?
    private var cameraAnchor: AnchorEntity?
    private var geometriesSize: Double = 0 {
        didSet {
            delegate?.updateGeometriesSize(geometriesSize)
        }
    }
    
    private var initialGamePoints: [SIMD2<Float>] = []
    private var backupGamePoints: [SIMD2<Float>] = []
    private var availablePoints: [SIMD2<Float>] = []
    private var entities: [GeometryEntity] = [] {
        didSet {
            delegate?.updatedEntities(entities)
        }
    }
    
    private var area: Double!
    private var vertices: [SIMD2<Float>] = []
    
    weak var delegate: GameDelegate?
    
    private var rot60: simd_float2x2 {
        simd_float2x2(SIMD2(cos(.pi/3), -sin(.pi/3)),
                      SIMD2(sin(.pi/3), cos(.pi/3)))
    }
    
    init(view: ARView, entitieTypes: [GeometryType], colors: [UIColor]) {
        self.arView = view
        self.entitieTypes = entitieTypes
        self.colors = colors
        
        getCameraAnchor()
    }
    
    private func getCameraAnchor() {
        for a in arView.scene.anchors {
            if a.name == "cameraAnchor" {
                cameraAnchor = a as? AnchorEntity
                return
            }
        }
    }
    
    func addPoint(to anchor: ARAnchor) {
        if (!isAddingPoins) { return }
        // Set up anchor entity
        let anchorEntity = AnchorEntity(world: anchor.transform)
        
        DispatchQueue.main.async {
            let cubeEntity = CubeEntity(color: .red, size: 0.1)
            
            self.arView.scene.addAnchor(anchorEntity)
            anchorEntity.addChild(cubeEntity)
                        
            self.anchors.append(anchorEntity)
            
            if self.first == nil { self.first = anchorEntity }
        }
    }
    
    private func finishInitialPointsPlacement() {
        isAddingPoins = false
        area = calculateArea()
        print("AREA: \(area!)")
        delegate?.placed(area: area)
    }
    
    func randomizeInitialBoard() {
        setGeometriesSize(area: area)
        removeInitialCubes()
        
        (initialGamePoints, backupGamePoints) = calculatePoints(in: vertices)
        availablePoints = backupGamePoints
        
        for position in initialGamePoints {
           createEntity(in: position)
        }
    }
    
    func clearBoard() {
        for entity in entities {
            entity.anchor?.removeFromParent()
        }
        entities.removeAll()
        removeInitialCubes()
    }
    
    func restart() {
        clearBoard()
        anchors.removeAll()
        first = nil
        isAddingPoins = true
        vertices.removeAll()
    }
    
    func addNewPair() {
        guard availablePoints.count >= 2 else { return }
        
        addEntity()
        addEntity()
    }
    
    private func addEntity() {
        let index = Int.random(in: 0..<availablePoints.count)
        let position = availablePoints.remove(at: index)
        
        createEntity(in: position)
    }
    
    func removePair(firstEntity: GeometryEntity, secondEntity: GeometryEntity) {
        removeEntity(firstEntity)
        removeEntity(secondEntity)
    }
    
    private func removeEntity(_ entity: GeometryEntity) {
        entity.anchor?.removeFromParent()
        
        guard let index = entities.firstIndex(of: entity) else { return }
        
        entities.remove(at: index)
    }
    
    private func createEntity(in position: SIMD2<Float>) {
        guard let first = first else { return }

        let position3D = SIMD3<Float>(position.x, first.position.y, position.y)
        let anchorEntity = AnchorEntity()
        anchorEntity.setPosition(position3D, relativeTo: first)
        
        let randomColor = Int.random(in: 0..<colors.count)
        let randomType = Int.random(in: 0..<entitieTypes.count)
        
        let entity = constructEntity(color: colors[randomColor], size: geometriesSize, type: entitieTypes[randomType])
        entity.generateCollisionShapes(recursive: false)
        
        arView.scene.addAnchor(anchorEntity)
        anchorEntity.addChild(entity)
        
        entities.append(entity)
        entity.addCollision()
    }
    
    private func calculateArea() -> Double {
        guard anchors.count == 4, let first = first else { return 0 }
        
        for a in anchors {
            vertices.append(SIMD2<Float>(a.position(relativeTo: first).x, a.position(relativeTo: first).z))
        }
        
        return calculateInitialQuadrilateralArea(vertices: vertices)
    }
    
    private func calculatePoints(in vertices: [SIMD2<Float>]) -> ([SIMD2<Float>], [SIMD2<Float>]){
        let points = calculateDistances(vertices: vertices, distancePins: Float(1.5 * geometriesSize))
        
        return dividePoints(points: points)
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
    
    private func dividePoints(points: [SIMD2<Float>]) -> ([SIMD2<Float>], [SIMD2<Float>]) {
        var points1: [SIMD2<Float>] = []
        var points2: [SIMD2<Float>] = []
        
        for i in 0 ..< points.count {
            if (i % 2 == 0) {
                points1.append(points[i])
            } else {
                points2.append(points[i])
            }
        }
        
        return (points1, points2)
    }
    
    private func calculateInitialQuadrilateralArea(vertices: [SIMD2<Float>]) -> Double {
        guard vertices.count == 4 else { return 0 }
        let v0: SIMD2<Float> = vertices[0]
        let v1: SIMD2<Float> = vertices[1]
        let v2: SIMD2<Float> = vertices[2]
        let v3: SIMD2<Float> = vertices[3]
        
        let t1: [SIMD2<Float>] = [v0, v1, v2]
        let t2: [SIMD2<Float>] = [v0, v2, v3]
        
        return calculateInitialTriangleArea(vertices: t1) + calculateInitialTriangleArea(vertices: t2)
    }
    
    private func calculateInitialTriangleArea(vertices: [SIMD2<Float>]) -> Double {
        guard vertices.count == 3 else { return 0 }
        
        let A = vertices[0]
        let B = vertices[1]
        let C = vertices[2]
        
        let ab = distance(A, B)
        let ac = distance(A, C)
        let bc = distance(B, C)
        
        let p = (ab + ac + bc) / 2
        let a = p * (p - ab) * (p - ac) * (p - bc)
        
        return Double(sqrt(a))
    }
    
    private func setGeometriesSize(area: Double) {
        let a = 0.05015012 //0.02
        let b = 2.646978 //1.743192
        let c = 3.594851 //1.836294
        let d = 1.021068 //0.5250122
        let x = area / c
        let size = d + ((a - d) / (1 + pow(x, b)))
        
        geometriesSize = size
        print("SIZEE: \(geometriesSize)")
    }
    
    private func removeInitialCubes() {
        for a in anchors {
            a.removeFromParent()
        }
    }
    
    private func calculateDistances(vertices: [SIMD2<Float>], distancePins: Float) -> [SIMD2<Float>]{
        guard vertices.count == 4 else { return [] }
        
        var retArray: [SIMD2<Float>] = []
        
        retArray.append(vertices[0])
        
        var currentPoint = vertices[0]
        
        while(abs(distance(currentPoint, vertices[1])) >= distancePins){
            
            currentPoint = newPointInLine(currentPoint, vertices[1], distance: distancePins)
            
            retArray.append(currentPoint)
        }
        
        
        var trianglePoints: [SIMD2<Float>] = calculateTriangles(points: retArray, distancePins: distancePins, rotation: rot60)
        
        trianglePoints += calculateTriangles(points: retArray, distancePins: distancePins, rotation: -rot60)
        
        trianglePoints = trianglePoints.filter({ contains(polygon: vertices, test: $0) })
        
        retArray = retArray + trianglePoints
        
        return retArray.removeDuplicates()
    }
    
    private func newPointInLine(_ a: SIMD2<Float>,_ b: SIMD2<Float>, distance: Float) -> SIMD2<Float> {
        let biggestPoint = b
        let smallestPoint = a
        
        let normalizedPoint = getNormalizedVector(biggestPoint, smallestPoint)
        let distanceVector = distance * normalizedPoint
        
        return smallestPoint + distanceVector
    }
    
    private func calculateTriangles( points: [SIMD2<Float>], distancePins: Float, rotation: simd_float2x2) -> [SIMD2<Float>]{
        
        var currentPoints = points
        var totalPoints: [SIMD2<Float>] = []
        
        for _ in 1...15{
            
            let triangleArray = currentPoints.dropLast()
            
            var trianglePoints: [SIMD2<Float>] = []
            var count = 0
            
            for point in triangleArray {
                let point = calculateTriangleTop(point, currentPoints[count + 1], distance: distancePins, rotationMatrix: rotation)
                
                
                trianglePoints.append(point)
                count += 1
            }
            
            let countPointsParameter = currentPoints.count
            if(countPointsParameter - 3 >= 0){
                let lastPoint = currentPoints[countPointsParameter - 1]
                let secondLastPoint = currentPoints[countPointsParameter - 2]
                
                let pointTop = calculateTriangleBottom(secondLastPoint, lastPoint, distance: distancePins, rotationMatrix: rotation)
                trianglePoints.append(pointTop)
                for times in 2...10 {
                    let newPointLine = newPointInLine(secondLastPoint, lastPoint, distance: Float(times)*distancePins)
                    
                    totalPoints.append(newPointLine)
                    
                    let newPoint = newPointInLine(currentPoints[0], currentPoints[1], distance: -Float(times - 1)*distancePins)
                    
                    totalPoints.append(newPoint)
                }
            }
            
            currentPoints = trianglePoints
            totalPoints += currentPoints
            
        }
        
        return totalPoints
    }
    
    private func calculateTriangleBottom(_ a: SIMD2<Float>,_ b: SIMD2<Float>, distance: Float, rotationMatrix: simd_float2x2) -> SIMD2<Float> {
        
        let normalizedVectorP = getNormalizedVector(b, a)
        let vector = normalizedVectorP * distance
        let rotatedVector = rotationMatrix * vector
        
        return rotatedVector + b
    }
    
    
    private func calculateTriangleTop(_ a: SIMD2<Float>,_ b: SIMD2<Float>, distance: Float, rotationMatrix: simd_float2x2) -> SIMD2<Float> {
        
        let normalizedVectorP = getNormalizedVector(b, a)
        
        let vector = normalizedVectorP * distance
        let rotatedVector = rotationMatrix * vector
        
        return rotatedVector + a
    }
    
    
    private func contains(polygon: [SIMD2<Float>], test: SIMD2<Float>) -> Bool {
        if polygon.count <= 1 { return false }
        
        let p = UIBezierPath()
        let firstPoint = polygon[0]
        
        p.move(to: CGPoint(x: CGFloat(firstPoint.x), y: CGFloat(firstPoint.y)))
        
        for index in 1...polygon.count-1 {
            p.addLine(to: CGPoint(x: CGFloat(polygon[index].x), y: CGFloat(polygon[index].y)))
        }
        
        p.close()
        
        return p.contains(CGPoint(x: CGFloat(test.x), y: CGFloat(test.y)))
    }
    
    private func getNormalizedVector(_ a: SIMD2<Float>,_ b: SIMD2<Float>) -> SIMD2<Float> {
        return simd_normalize(a - b)
    }
}

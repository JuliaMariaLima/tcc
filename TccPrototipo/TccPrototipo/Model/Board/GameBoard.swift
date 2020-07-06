//
//  GameBoard.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 22/06/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import RealityKit
import ARKit

class GameBoard: Board {
    private var isAddingPositions = true
    private var anchors: [AnchorEntity] = [] {
        didSet {
            guard case anchors.count = 4 else { return }
            finishInitialPointsPlacement()
        }
    }
    
    private var initialGamePositions: [SIMD2<Float>] = []
    private var backupGamePositions: [SIMD2<Float>] = []
    private var availablePositions: [SIMD2<Float>] = []
    
    private var area: Double!
    private var vertices: [SIMD2<Float>] = []
    
    weak var delegate: GameDelegate?
    
    private var rot60: simd_float2x2 {
        simd_float2x2(SIMD2(cos(.pi/3), -sin(.pi/3)),
                      SIMD2(sin(.pi/3), cos(.pi/3)))
    }
    
    func addPoint(to anchor: ARAnchor) {
        if !isAddingPositions { return }
        
        // Set up anchor entity
        let anchorEntity = AnchorEntity(world: anchor.transform)
        
        DispatchQueue.main.async {
            let cubeEntity = CubeEntity(color: .red, size: 0.1)
            
            self.arView.scene.addAnchor(anchorEntity)
            anchorEntity.addChild(cubeEntity)
            
            self.anchors.append(anchorEntity)
            if !self.haveReference() { self.set(reference: anchorEntity) }
        }
    }

    func randomizeInitialBoard() {
        setGeometriesSize(area: area)
        removeInitialCubes()
        
        (initialGamePositions, backupGamePositions) = calculatePoints(in: vertices)
        availablePositions = backupGamePositions
        
        for position in initialGamePositions {
            createEntity(in: position)
        }
        
        if !haveACombination() {
            createACombination()
        }
    }
    
    override func clearBoard() {
        super.clearBoard()
        removeInitialCubes()
    }
    
    override func restart() {
        super.restart()
        anchors.removeAll()
        isAddingPositions = true
        vertices.removeAll()
    }
    
    func addNewPair() {
        if availablePositions.count < 2 && !haveACombination() {
            createNewBoard()
            return
        }
        
        addEntity()
        addEntity()
        
        if !haveACombination() {
            createACombination()
        }
    }
    
    private func addEntity(_ type: GeometryType? = nil) {
        guard availablePositions.count >= 1 else { return }
        
        let index = Int.random(in: 0..<availablePositions.count)
        let position = availablePositions.remove(at: index)
        
        createEntity(in: position, type)
    }
    
    func removePair(firstEntity: GeometryEntity, secondEntity: GeometryEntity) {
        removeEntity(firstEntity)
        removeEntity(secondEntity)
    }
    
    private func createACombination() {
        let randomType = Int.random(in: 0..<entitieTypes.count)
        let matches = mapMatches[entitieTypes[randomType]]!
        let randomMatch = Int.random(in: 0..<matches.count)
        
        addEntity(matches[randomMatch])
    }
    
    private func finishInitialPointsPlacement() {
        isAddingPositions = false
        area = calculateArea()
        print("AREA: \(area!)")
        delegate?.placed(area: area)
    }
    
    func createNewBoard() {
        clearBoard()
        randomizeInitialBoard()
    }
    
    private func calculateArea() -> Double {
        guard anchors.count == 4, let reference = getReference() else { return 0 }
        
        for a in anchors {
            vertices.append(SIMD2<Float>(a.position(relativeTo: reference).x, a.position(relativeTo: reference).z))
        }
        
        return calculateInitialQuadrilateralArea(vertices: vertices)
    }
    
    private func calculatePoints(in vertices: [SIMD2<Float>]) -> ([SIMD2<Float>], [SIMD2<Float>]){
        let points = calculateDistances(vertices: vertices, distancePins: Float(1.2 * getGeometriesSize()))
        
        return dividePoints(points: points)
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
        let a = 0.05412485 // 0.05015012 //0.02
        let b = 1.559054 // 2.646978 //1.743192
        let c = 10109.99 // 3.594851 //1.836294
        let d = 264589.6 // 1.021068 //0.5250122
        let x = area / c
        var size = d + ((a - d) / (1 + pow(x, b)))
        
        if size > 0.6 {
            size = 0.6
        }
        
        set(geometriesSize: size)
        print("SIZEE: \(size)")
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

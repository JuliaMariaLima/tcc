//
//  ViewController.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 10/11/19.
//  Copyright © 2019 Julia Maria Santos. All rights reserved.
//

import UIKit
import RealityKit
import ARKit
import Combine

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet var arView: ARView!
    
    var coachingView: ARCoachingOverlayView!
    
    var floor: FloorEntity!
    
    var anchorEntityFloor: AnchorEntity!
    
    var anchorEntityForms: [AnchorEntity] = []
    var entities: [GeometryEntity] = []
    var mapMatches: [GeometryType:[GeometryType]] = [:]
    
    var selectedEntity: GeometryEntity!
    
    var planeAnchor: ARPlaneAnchor? = nil
    
    var animation: Cancellable!
    
    var currentAnimation: AnimationPlaybackController!
    
    var isTouching: Bool! = false
    
    var moveDuration: TimeInterval = 30
    
    var moveDistance: Float = 15
    
    lazy var cameraAnchor: AnchorEntity! = {
        var anchor = AnchorEntity(.camera)
        anchor.name = "cameraAnchor"
        
        return anchor
    }()
    
    // MARK: Gesture Recognizers
    
    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        
        return recognizer
    }()
    
    // MARK:- UI Views
    
    lazy var buttonUp: UIButton! = {
        let button = UIButton(frame: CGRect(x: view.frame.width / 2 - 25, y: view.frame.height - 150, width: 50, height: 45))
        
        button.addTarget(self, action: #selector(buttonUpClicked), for: .touchDown)
        button.addTarget(self, action: #selector(buttonReleased), for: .touchUpInside)
        button.setImage(UIImage(named: "up"), for: .normal)
        
        return button
    }()
    
    lazy var buttonDown: UIButton! = {
        let button = UIButton(frame: CGRect(x: view.frame.width / 2 - 25, y: view.frame.height - 50, width: 50, height: 45))
        
        button.addTarget(self, action: #selector(buttonDownClicked), for: .touchDown)
        button.addTarget(self, action: #selector(buttonReleased), for: .touchUpInside)
        button.setImage(UIImage(named: "down"), for: .normal)
        
        return button
    }()
    
    lazy var buttonLeft: UIButton! = {
        let button = UIButton(frame: CGRect(x: view.frame.width / 2 - 75, y: view.frame.height - 102.5, width: 45, height: 50))
        
        button.addTarget(self, action: #selector(buttonLeftClicked), for: .touchDown)
        button.addTarget(self, action: #selector(buttonReleased), for: .touchUpInside)
        button.setImage(UIImage(named: "left"), for: .normal)
        
        return button
    }()
    
    lazy var buttonRight: UIButton! = {
        let button = UIButton(frame: CGRect(x: view.frame.width / 2 + 25, y: view.frame.height - 102.5, width: 45, height: 50))
        
        button.addTarget(self, action: #selector(buttonRightClicked), for: .touchDown)
        button.addTarget(self, action: #selector(buttonReleased), for: .touchUpInside)
        button.setImage(UIImage(named: "right"), for: .normal)
        
        return button
    }()
    
    // MARK:- Life Cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arView.session.delegate = self
        arView.scene.addAnchor(cameraAnchor)
        
        floor = FloorEntity(color: .clear)
        
        arView.addGestureRecognizer(tapRecognizer)
        
        setUpEntities()
        setUpMatches()
        setUpConfigurations()
        setUpCoachingView()
        setUpButtons()
        setUpSubscription()
    }
    
    // MARK:- Set ups
    
    func setUpConfigurations() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        arView.session.run(configuration)
    }
    
    func setUpButtons() {
        view.addSubview(buttonUp)
        view.addSubview(buttonDown)
        view.addSubview(buttonLeft)
        view.addSubview(buttonRight)
    }
    
    func setUpSubscription() {
        animation = arView.scene.subscribe(to: AnimationEvents.PlaybackTerminated.self) { (event) in
            guard let movingEntity = event.playbackController.entity as? GeometryEntity else { return }
            for entity in self.entities {
                for match in self.mapMatches[movingEntity.type] ?? [] {
                    if entity.type == match {
                        self.calculateDistance(movingEntity: movingEntity, staticEntity: entity)
                    }
                }
                //                print("MAPMATCHES[", movingEntity,"] = ", self.mapMatches[movingEntity.type] ?? [])
                //                if mapMatches[movingEntity]
                //
            }
        }
    }
    
    func setUpEntities() {
        entities.append(CubeEntity(color: .red))
        entities.append(QuadrilateralPyramidEntity(color: .blue))
        //        entities.append(TriangularPrismEntity(color: .cyan))
        //        entities.append(SemiSphereEntity(color: .green))
        //        entities.append(CylinderEntity(color: .magenta))
        //        entities.append(PentagonalPrismEntity(color: .orange))
        //        entities.append(OctahedronEntity(color: .purple))
        //        entities.append(TetrahedronEntity(color: .yellow))
        //        entities.append(ConeEntity(color: .systemPink))
        //        entities.append(PentagonalPyramidEntity(color: .white))
        
        selectedEntity = entities.first!
    }
    
    func setUpMatches() {
        mapMatches[.Cube] = [.Cube]
        mapMatches[.QuadrilateralPyramid] = [.Cube]
        mapMatches[.TriangularPrism] = [.Octahedron, .TriangularPrism]
        mapMatches[.SemiSphere] = [.Cylinder]
        mapMatches[.Cylinder] = [.Cylinder]
        mapMatches[.PentagonalPrism] = [.PentagonalPrism]
        mapMatches[.Octahedron] = [.TriangularPrism, .Octahedron]
        mapMatches[.Tetrahedron] = [.Octahedron, .TriangularPrism]
        mapMatches[.Cone] = [.Cylinder]
        mapMatches[.PentagonalPyramid] = [.PentagonalPrism]
    }
    
    func addEntities() {
        guard let result = arView.raycast(from: self.view.center, allowing: .existingPlaneGeometry, alignment: .horizontal).first
            else {
                reset()
                return
        }
        
        let x = result.worldTransform.columns.3.x
        let y = result.worldTransform.columns.3.y
        let z = result.worldTransform.columns.3.z
        
        var n: Double = 0
        for entity in entities {
            entity.generateCollisionShapes(recursive: false)
            
            let anchorEntity = AnchorEntity()
            anchorEntity.position = [x + Float(n*0.4), y, z]
            
            entity.position = [0, 0, 0]
            anchorEntity.addChild(entity)
            
//            arView.installGestures(.translation, for: entity)
            arView.scene.addAnchor(anchorEntity)
            
            entity.addCollision()
            n += 1
        }
        
//        anchorEntityFloor = AnchorEntity()
//        anchorEntityFloor.position = [x, y, z]
//        anchorEntityFloor.addChild(floor)
//
//        arView.scene.addAnchor(anchorEntityFloor)
    }
    
    // MARK: - Actions
    
    func calculateDistance(movingEntity: GeometryEntity, staticEntity: GeometryEntity) {
        let staticPosition = staticEntity.position(relativeTo: movingEntity)
        var movingPosition = staticPosition
        movingPosition.y += 10
        let dist = distance(staticPosition, movingEntity.position)
        print("DIST (static: ", staticEntity, " - moving: ", movingEntity, ") = ", dist)
        //        if dist < 15 && movingPosition.y > staticPosition.y {
        //
        //            movingEntity.setPosition(movingPosition, relativeTo: movingEntity)
        //            movingEntity.cancelCollision()
        //            staticEntity.cancelCollision()
        //            let alert = UIAlertController(title: "Você ganhou!!", message: "", preferredStyle: .alert)
        //            alert.addAction(UIAlertAction(title: "Jogar de novo", style: .cancel, handler: { (alert) in
        //                //                        self.staticEntity.removeFromParent()
        //                //                        self.movingEntity.removeFromParent()
        //                //                        self.anchorEntityFloor.removeFromParent()
        //                // self.reset()
        //                movingEntity.cancelCollision()
        //                staticEntity.cancelCollision()
        //            }))
        //
        //            self.present(alert, animated: true)
        //        }
    }
    
    func reset() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        arView.session.run(configuration, options: .resetTracking)
        coachingView.activatesAutomatically = true
    }
    
    @objc
    func buttonUpClicked() {
        let transformMatrix = selectedEntity.transformMatrix(relativeTo: cameraAnchor)
        var transform = Transform(matrix: transformMatrix)
        transform.translation.y += moveDistance
    
        currentAnimation = selectedEntity.move(to: transform, relativeTo: cameraAnchor, duration: moveDuration)
    }
    
    @objc
    func buttonDownClicked() {
        let transformMatrix = selectedEntity.transformMatrix(relativeTo: cameraAnchor)
        var transform = Transform(matrix: transformMatrix)
        transform.translation.y -= moveDistance
        
        currentAnimation = selectedEntity.move(to: transform, relativeTo: cameraAnchor, duration: moveDuration)
    }
    
    @objc
    func buttonLeftClicked() {
        let transformMatrix = selectedEntity.transformMatrix(relativeTo: cameraAnchor)
        var transform = Transform(matrix: transformMatrix)
        transform.translation.x -= moveDistance
        
        currentAnimation = selectedEntity.move(to: transform, relativeTo: cameraAnchor, duration: moveDuration)
    }
    
    @objc
    func buttonRightClicked() {
        let transformMatrix = selectedEntity.transformMatrix(relativeTo: cameraAnchor)
        var transform = Transform(matrix: transformMatrix)
        transform.translation.x += moveDistance
        
        currentAnimation = selectedEntity.move(to: transform, relativeTo: cameraAnchor, duration: moveDuration)
    }
    
    @objc
    func buttonReleased() {
        currentAnimation.stop()
    }
    
    @objc
    private func handleTap(recognizer: UITapGestureRecognizer) {
        print(">>>> TAP <<<<")
        let tapLocation = recognizer.location(in: arView)
        
        let hits = arView.hitTest(tapLocation)
        
        for hit in hits {
            if hit.entity is GeometryEntity {
                selectedEntity = hit.entity as? GeometryEntity
                print("SELECTED ENTITY IS:::: ", selectedEntity as Any)
                return
            }
        }
        
        print("Achou nada")
    }
}


//MARK: - AR Coaching Overlay View Delegate

extension ViewController: ARCoachingOverlayViewDelegate {
    
    func setUpCoachingView() {
        coachingView = ARCoachingOverlayView()
        view.addSubview(coachingView)
        
        coachingView.delegate = self
        coachingView.goal = .horizontalPlane
        coachingView.session = arView.session
        coachingView.translatesAutoresizingMaskIntoConstraints = false
        
        setUpConstraints()
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            coachingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            coachingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            coachingView.heightAnchor.constraint(equalTo: view.heightAnchor),
            coachingView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
    
    func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        print("ta funcionando desativei", coachingOverlayView)
        coachingView.activatesAutomatically = false
        
        addEntities()
    }
}

// MARK:- AR Session Delegate

extension ViewController: ARSessionDelegate {
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors {
            if anchor is ARPlaneAnchor, planeAnchor == nil {
                print("PLANOOOO")
                planeAnchor = anchor as? ARPlaneAnchor
                print(planeAnchor!)
            }
        }
    }
}

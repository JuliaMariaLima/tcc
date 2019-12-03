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
    
    var cube: CubeEntity!
    var pyramid: PyramidEntity!
    var floor: FloorEntity!
    
    var anchorEntityCube: AnchorEntity!
    var anchorEntityPyramid: AnchorEntity!
    var anchorEntityFloor: AnchorEntity!

    var planeAnchor: ARPlaneAnchor? = nil
    
    var animation: Cancellable!
    
    lazy var cameraAnchor: AnchorEntity! = {
        var anchor = AnchorEntity(.camera)
        anchor.name = "cameraAnchor"
        
        return anchor
    }()
    
    // MARK:- UI Views
    
    lazy var buttonUp: UIButton! = {
       let button = UIButton(frame: CGRect(x: view.frame.width / 2 - 25, y: view.frame.height - 150, width: 50, height: 45))
        
       button.addTarget(self, action: #selector(buttonUpClicked), for: .touchDown)
       button.setImage(UIImage(named: "up"), for: .normal)

        return button
    }()
    
    lazy var buttonDown: UIButton! = {
        let button = UIButton(frame: CGRect(x: view.frame.width / 2 - 25, y: view.frame.height - 50, width: 50, height: 45))
        
        button.addTarget(self, action: #selector(buttonDownClicked), for: .touchDown)
        button.setImage(UIImage(named: "down"), for: .normal)
        
        return button
    }()
    
    lazy var buttonLeft: UIButton! = {
        let button = UIButton(frame: CGRect(x: view.frame.width / 2 - 75, y: view.frame.height - 102.5, width: 45, height: 50))
        
        button.addTarget(self, action: #selector(buttonLeftClicked), for: .touchDown)
        button.setImage(UIImage(named: "left"), for: .normal)
        
        return button
    }()
    
    lazy var buttonRight: UIButton! = {
        let button = UIButton(frame: CGRect(x: view.frame.width / 2 + 25, y: view.frame.height - 102.5, width: 45, height: 50))
        
        button.addTarget(self, action: #selector(buttonRightClicked), for: .touchDown)
        button.setImage(UIImage(named: "right"), for: .normal)
        
        return button
    }()
    
    // MARK:- Life Cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arView.session.delegate = self
        arView.scene.addAnchor(cameraAnchor)
                
        cube = CubeEntity(color: .red)
        pyramid = PyramidEntity(color: .yellow)
        floor = FloorEntity(color: .clear)
            
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
        animation = arView.scene.subscribe(to: AnimationEvents.PlaybackCompleted.self) { (event) in
            //print(event.playbackController.entity as Any)
            self.calculateDistance()
        }
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
        
        
        
        anchorEntityCube = AnchorEntity()
        anchorEntityCube.position = [x, y + 0.1, z]
        cube.position = [0, 0, 0]
        
        anchorEntityPyramid = AnchorEntity()
        anchorEntityPyramid.position = [x - 0.5, y, z]
        pyramid.position = [0, 0, 0]
        
        anchorEntityFloor = AnchorEntity()
        anchorEntityFloor.position = [x, y, z]
        
        anchorEntityCube.addChild(cube)
        anchorEntityPyramid.addChild(pyramid)
//        anchorEntityFloor.addChild(floor)
        
//        arView.installGestures(.translation, for: cube)
//        arView.installGestures(.translation, for: pyramid)

        arView.scene.addAnchor(anchorEntityCube)
        arView.scene.addAnchor(anchorEntityPyramid)
        arView.scene.addAnchor(anchorEntityFloor)
        
        cube.addCollision()
        pyramid.addCollision()
    }
    
    // MARK: - Actions
    
    func calculateDistance() {
        let cubePosition = cube.position(relativeTo: pyramid)
        var pyramidPosition = cubePosition
        pyramidPosition.y += 10
        let dist = distance(cubePosition, pyramid.position)
   
        if dist < 15 && pyramidPosition.y > cubePosition.y {
           
            pyramid.setPosition(pyramidPosition, relativeTo: pyramid)
            pyramid.cancelCollision()
            cube.cancelCollision()
            let alert = UIAlertController(title: "Você ganhou!!", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Jogar de novo", style: .cancel, handler: { (alert) in
                self.cube.removeFromParent()
                self.pyramid.removeFromParent()
                self.anchorEntityCube.removeFromParent()
                self.anchorEntityPyramid.removeFromParent()
                self.anchorEntityFloor.removeFromParent()
                self.reset()
            }))

            self.present(alert, animated: true)
        }
    }
    
    func reset() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        arView.session.run(configuration, options: .resetTracking)
         coachingView.activatesAutomatically = true
    }
    
    @objc func buttonUpClicked() {
        let transformMatrix = pyramid.transformMatrix(relativeTo: cameraAnchor)
        var transform = Transform(matrix: transformMatrix)
        transform.translation.y += 0.1
        
        pyramid.move(to: transform, relativeTo: cameraAnchor, duration: 1.0)
    }
    
    @objc func buttonDownClicked() {
        let transformMatrix = pyramid.transformMatrix(relativeTo: cameraAnchor)
        var transform = Transform(matrix: transformMatrix)
        transform.translation.y -= 0.1
        
        pyramid.move(to: transform, relativeTo: cameraAnchor, duration: 1.0)
    }
    
    @objc func buttonLeftClicked() {
        let transformMatrix = pyramid.transformMatrix(relativeTo: cameraAnchor)
        var transform = Transform(matrix: transformMatrix)
        transform.translation.x -= 0.1
        
        pyramid.move(to: transform, relativeTo: cameraAnchor, duration: 1.0)
    }
    
    @objc func buttonRightClicked() {
        let transformMatrix = pyramid.transformMatrix(relativeTo: cameraAnchor)
        var transform = Transform(matrix: transformMatrix)
        transform.translation.x += 0.1
        
        pyramid.move(to: transform, relativeTo: cameraAnchor, duration: 1.0)
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

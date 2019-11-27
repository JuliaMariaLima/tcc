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

class ViewController: UIViewController {
    
    @IBOutlet var arView: ARView!
    
    var cube: CubeEntity!
    
    lazy var cameraAnchor: AnchorEntity! = {
        var anchor = AnchorEntity(.camera)
        anchor.name = "cameraAnchor"
        
        return anchor
    }()
    
    lazy var buttonUp: UIButton! = {
       let button = UIButton(frame: CGRect(x: view.frame.width - 100, y: view.frame.height - 150, width: 50, height: 45))
        
       button.addTarget(self, action: #selector(buttonUpClicked), for: .touchUpInside)
       button.setImage(UIImage(named: "up"), for: .normal)

        return button
    }()
    
    lazy var buttonDown: UIButton! = {
        let button = UIButton(frame: CGRect(x: view.frame.width - 100, y: view.frame.height - 50, width: 50, height: 45))
        
        button.addTarget(self, action: #selector(buttonDownClicked), for: .touchUpInside)
        button.setImage(UIImage(named: "down"), for: .normal)
        
        return button
    }()
    
    lazy var buttonLeft: UIButton! = {
        let button = UIButton(frame: CGRect(x: view.frame.width - 150, y: view.frame.height - 100, width: 45, height: 50))
        
        button.addTarget(self, action: #selector(buttonLeftClicked), for: .touchUpInside)
        button.setImage(UIImage(named: "left"), for: .normal)
        
        return button
    }()
    
    lazy var buttonRight: UIButton! = {
        let button = UIButton(frame: CGRect(x: view.frame.width - 50, y: view.frame.height - 100, width: 45, height: 50))
        
        button.addTarget(self, action: #selector(buttonRightClicked), for: .touchUpInside)
        button.setImage(UIImage(named: "right"), for: .normal)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let anchorEntity = AnchorEntity()
        anchorEntity.position = [0, 0, -1.5]
        
        cube = CubeEntity(color: .red)
        
//        arView.installGestures(.all, for: cube)
        arView.scene.addAnchor(anchorEntity)
        
        arView.session.delegate = self
        
        anchorEntity.addChild(cube)
        
        view.addSubview(buttonUp)
        
        view.addSubview(buttonDown)
        
        view.addSubview(buttonLeft)
        
        view.addSubview(buttonRight)
                
        arView.scene.addAnchor(cameraAnchor)
    }
    
    @objc func buttonUpClicked() {
        print("up")
        
        let entity = Entity()
        let position = cube.position(relativeTo: cameraAnchor)
        entity.position = [position.x, position.y + 1, position.z]

        cube.move(to: entity.transform, relativeTo: cameraAnchor, duration: 1.0)
    }
    
    @objc func buttonDownClicked() {
        print("down")
        
        let entity = Entity()
        let position = cube.position(relativeTo: cameraAnchor)
        entity.position = [position.x, position.y - 1, position.z]

        cube.move(to: entity.transform, relativeTo: cameraAnchor, duration: 1.0)
    }
    
    @objc func buttonLeftClicked() {
        print("left")
        
        let entity = Entity()
        let position = cube.position(relativeTo: cameraAnchor)
        entity.position = [position.x - 0.5, position.y, position.z]

        cube.move(to: entity.transform, relativeTo: cameraAnchor, duration: 1.0)
    }
    
    @objc func buttonRightClicked() {
        print("right")
        
        let entity = Entity()
        let position = cube.position(relativeTo: cameraAnchor)
        entity.position = [position.x + 0.5, position.y, position.z]

        cube.move(to: entity.transform, relativeTo: cameraAnchor, duration: 1.0)
    }
}

extension ViewController: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
//        let position = cube.position
//        let transform = cube.transform
//
//        cube.look(at: cameraAnchor.position(relativeTo: cube), from: cube.position(relativeTo: cube), relativeTo: nil)
//
//        print("look: ", cube.transform)
//        cube.transform = transform
//        cube.position = position
//        print("cool: ", cube.transform)
        
//        let position = cube.position(relativeTo: cameraAnchor)
//        let h = sqrt((position.x * position.x) + (position.z * position.z))
//        let t = 180 - (acos(position.z / h) * 180 / .pi) // angle between player and base
//
    }
}

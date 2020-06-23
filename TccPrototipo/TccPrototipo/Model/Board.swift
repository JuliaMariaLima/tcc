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
    var arView: ARView!
    var isAddingPoins = true
    var anchors: [ARAnchor] = [] {
        didSet {
            guard case anchors.count = 4 else { return }
            finishInitialPointsPlacement()
        }
    }
    
    weak var delegate: GameDelegate?
    
    init(view: ARView) {
        self.arView = view
    }
    
    func addPoint(to anchor: ARAnchor) {
        if (!isAddingPoins) { return }
        // Set up anchor entity
        let anchorEntity = AnchorEntity(world: anchor.transform)
        
        DispatchQueue.main.async {
            let cubeEntity = CubeEntity(color: .red)
            self.arView.installGestures(for: cubeEntity)

            self.arView.scene.addAnchor(anchorEntity)
            anchorEntity.addChild(cubeEntity)
            
            self.arView.installGestures(.translation, for: cubeEntity)
            
            // Make this thread safe
            self.anchors.append(anchor)
        }
    }
    
    func finishInitialPointsPlacement() {
        isAddingPoins = false
        delegate?.placed(self, anchors: anchors)
    }
    
    func calculatePoints() {
        
    }
}

//
//  GameDelegate.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 22/06/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import RealityKit

protocol GameDelegate: class {
    func placed(_ board: Board, anchors: [AnchorEntity])
    
    func counted()
        
    func played()
}

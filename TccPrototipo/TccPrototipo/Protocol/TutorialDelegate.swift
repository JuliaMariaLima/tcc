//
//  TutorialDelegate.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 05/07/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import Foundation

protocol TutorialDelegate: class {
    
    func showObject(type: GeometryType) -> GeometryEntity
    
    func showOrientedEntity(for object: GeometryEntity)
    
    func showObjectUnder(object: GeometryEntity, type: GeometryType) -> GeometryEntity    
}

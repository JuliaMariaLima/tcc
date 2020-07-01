//
//  ConstructionDelegate.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 30/06/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import Foundation

protocol ConstructionDelegate: class {
    func initializingToPlacing()
    
    func initializingToInitializing()
    
    func placingToLooking()
    
    func lookingToAdding()
    
    func lookingToConstructing()
    
    func lookingToLeaving()
    
    func addingToLooking()
    
    func addingToClassifying()
    
    func constructingToLooking()
    
    func constructingToLeaving()
    
    func classifyingToConstructing()
    
    func classifyingToAdding()
    
    func leavingToInitializing()
    
    func leavingToLooking()
}

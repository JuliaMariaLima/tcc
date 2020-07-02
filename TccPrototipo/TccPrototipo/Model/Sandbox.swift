//
//  Sandbox.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 28/06/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import Foundation

class Sandbox: Codable {
    static var shared = Sandbox()
    
    private var constructions: [UUID:Construction] = [:]
    
    private init() {}
    
    func add(_ construction: Construction) {
       constructions[construction.id] = construction
    }
    
    func get(by id: UUID) -> Construction? {
        return constructions[id]
    }
    
    func getAll() -> [Construction] {
        return Array(constructions.values)
    }
}

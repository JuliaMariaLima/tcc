//
//  Construction.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 28/06/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import UIKit

class Construction: Codable {
    
    var id: UUID!
    
    var image: Image!
    
    var map: [SIMD3<Float>:GeometryType] = [:]
    
    init() {
        id = UUID()
    }
}

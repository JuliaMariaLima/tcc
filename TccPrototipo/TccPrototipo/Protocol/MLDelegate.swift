//
//  MLDelegate.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 30/06/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import Foundation

protocol MLDelegate: class {
    func result(identifier: String, confidence: Float)
}

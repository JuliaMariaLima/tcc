//
//  GeometryType.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 29/06/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import Foundation

enum GeometryType {
    case Cube
    case QuadrilateralPyramid
    case TriangularPrism
    case SemiSphere
    case Cylinder
    case PentagonalPrism
    case Octahedron
    case Tetrahedron
    case Cone
    case PentagonalPyramid
}

extension GeometryType {
    func next() -> GeometryType? {
        guard let face = EntityProperties.shared.mapTypeToFace[self] else { return nil }
        guard let types = EntityProperties.shared.mapFaceToTypes[face] else { return nil }
        var next: Int = 0
        
        for i in 0..<types.count {
            if types[i] == self {
                next = i + 1
                break
            }
        }
        
        next = next % types.count
        
        return types[next]
    }
}

extension GeometryType: Codable {
    enum CodingKeys: CodingKey {
        case rawValue
    }
    
    enum CodingError: Error {
        case unknownValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let rawValue = try container.decode(String.self, forKey: .rawValue)
        
        switch rawValue {
        case "Cube":
            self = .Cube
        case "QuadrilateralPyramid":
            self = .QuadrilateralPyramid
        case "TriangularPrism":
            self = .TriangularPrism
        case "SemiSphere":
            self = .SemiSphere
        case "Cylinder":
            self = .Cylinder
        case "PentagonalPrism":
            self = .PentagonalPrism
        case "Octahedron":
            self = .Octahedron
        case "Tetrahedron":
            self = .Tetrahedron
        case "Cone":
            self = .Cone
        case "PentagonalPyramid":
            self = .PentagonalPyramid
        default:
            throw CodingError.unknownValue
        }
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .Cube:
            try container.encode("Cube", forKey: .rawValue)
        case .QuadrilateralPyramid:
            try container.encode("QuadrilateralPyramid", forKey: .rawValue)
        case .TriangularPrism:
            try container.encode("TriangularPrism", forKey: .rawValue)
        case .SemiSphere:
            try container.encode("SemiSphere", forKey: .rawValue)
        case .Cylinder:
            try container.encode("Cylinder", forKey: .rawValue)
        case .PentagonalPrism:
            try container.encode("PentagonalPrism", forKey: .rawValue)
        case .Octahedron:
            try container.encode("Octahedron", forKey: .rawValue)
        case .Tetrahedron:
            try container.encode("Tetrahedron", forKey: .rawValue)
        case .Cone:
            try container.encode("Cone", forKey: .rawValue)
        case .PentagonalPyramid:
            try container.encode("PentagonalPyramid", forKey: .rawValue)
        }
    }
}

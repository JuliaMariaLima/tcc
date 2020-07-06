//
//  Array.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 23/06/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

extension Array where Element: Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()

        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }

        return result
    }
}

//
//  CodableExtension.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 22/06/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import Foundation

enum FileManageError:Error {
    case canNotSaveInFile
    case canNotReadFile
}

extension Encodable {
    func save(in file:String? = nil) throws {

        // generates URL for documentDir/file.json
        let documentDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let fileName = file ?? String(describing: type(of: self))
        let url = URL(fileURLWithPath: documentDir.appendingPathComponent(fileName+".json"))
        
        
        // Try to save
        do {
            try JSONEncoder().encode(self).write(to: url)
            debugPrint("Save in", String(describing: url))
        } catch {
            debugPrint("Can not save in", String(describing: url))
            throw FileManageError.canNotSaveInFile
        }
    }
}

extension Decodable {
    mutating func load(from file:String? = nil) throws {

        // generates URL for documentDir/file.json
        let documentDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let fileName = file ?? String(describing: type(of: self))
        let url = URL(fileURLWithPath: documentDir.appendingPathComponent(fileName+".json"))

        // Try to read
        do {
            let readedData = try Data(contentsOf: url)
            let readedInstance = try JSONDecoder().decode(Self.self, from: readedData)
            self = readedInstance
        } catch {
            print("Can not read from", String(describing: url))
            throw FileManageError.canNotReadFile
        }
    }
    
    func delete(in file:String? = nil) {
        let documentDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let fileName = file ?? String(describing: type(of: self))
        let url = URL(fileURLWithPath: documentDir.appendingPathComponent(fileName+".json"))
        
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print("Can not delete from", String(describing: url))
        }
    }
}

//
//  DataExtension.swift
//  JaoStoreReleases
//
//  Created by João Melo on 12/07/24.
//

import Foundation

extension Data {
    init<T>(from value: T) {
        var value = value
        self = withUnsafePointer(to: &value) { ptr in
            ptr.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout<T>.size) {
                Data(bytes: $0, count: MemoryLayout<T>.size)
            }
        }
    }
    
    func to<T>(type: T.Type) -> T {
        return self.withUnsafeBytes { $0.load(as: T.self) }
    }
}

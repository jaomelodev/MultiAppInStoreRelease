//
//  Injector.swift
//  JaoStoreReleases
//
//  Created by João Melo on 13/07/24.
//

class Injector<T> {
    func registerDependencies() -> T {
        fatalError("Must be overridden in subclass")
    }
}

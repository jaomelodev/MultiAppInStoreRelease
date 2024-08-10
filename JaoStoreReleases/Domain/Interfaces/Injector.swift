//
//  Injector.swift
//  JaoStoreReleases
//
//  Created by João Melo on 13/07/24.
//

import Foundation
import Swinject

protocol InjectorProtocol {
    var container: Container { get }
    func registerDependencies() -> Void;
}

class Injector: InjectorProtocol {
    private(set) var container: Container
    
    init() {
        container = Container()
        registerDependencies()
    }
    
    func registerDependencies() {
        fatalError("Must be overridden in subclass")
    }
}

class InjectorTest<T> {
    func registerDependencies() -> T {
        fatalError("Must be overridden in subclass")
    }
}

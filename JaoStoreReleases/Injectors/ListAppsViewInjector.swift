//
//  ListAppsViewInjector.swift
//  JaoStoreReleases
//
//  Created by João Melo on 14/07/24.
//

import Foundation

class ListAppsViewInjector: Injector {
    override func registerDependencies() {
        container.register(ListAppsController.self) { resolver in
            ListAppsController()
        }
    }
}

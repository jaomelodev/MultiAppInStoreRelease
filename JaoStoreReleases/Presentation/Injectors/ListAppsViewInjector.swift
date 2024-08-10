//
//  ListAppsViewInjector.swift
//  JaoStoreReleases
//
//  Created by João Melo on 14/07/24.
//

import Foundation

class ListAppsViewInjector: Injector {
    override func registerDependencies() {
        let client = AppStoreHTTPClient()
        
        let appStoreService = AppStoreServiceImpl(appStoreClient: client)
        
        container.register(ListAllAppsAppleService.self) { resolver in appStoreService }
        
        container.register(ListAllAppsAppleUseCase.self) { resolver in
            ListAllAppsAppleUseCaseImpl(appStoreService: resolver.resolve(ListAllAppsAppleService.self)!)
        }
        
        container.register(ListAppsController.self) { resolver in
            ListAppsController(
                listAllAppsAppleUseCase: resolver.resolve(ListAllAppsAppleUseCase.self)!
            )
        }
    }
}

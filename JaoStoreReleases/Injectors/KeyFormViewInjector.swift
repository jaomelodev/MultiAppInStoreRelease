//
//  HomeViewInjector.swift
//  JaoStoreReleases
//
//  Created by João Melo on 13/07/24.
//

import Foundation

class KeyFormViewInjector: Injector {
    override func registerDependencies() {
        container.register(LocalAuthService.self) { _ in LocalAuthServiceImpl()}
        
        container.register(LocalAuthenticationUseCase.self) { resolver in
            LocalAuthenticationUseCase(localAuthenticationService: resolver.resolve(LocalAuthService.self)!)
        }
        
        container.register(KeyChainService.self) { _ in KeyChainServiceImpl()}
        
        container.register(SaveItemKeyChainUseCase.self) { resolver in
            SaveItemKeyChainUseCase(keyChainService: resolver.resolve(KeyChainService.self)!)
        }
        
        container.register(KeyFormController.self) { resolver in
            KeyFormController(
                localAuthenticationUseCase: resolver.resolve(LocalAuthenticationUseCase.self)!,
                saveItemKeyChainUseCase: resolver.resolve(SaveItemKeyChainUseCase.self)!
            )
        }
    }
}

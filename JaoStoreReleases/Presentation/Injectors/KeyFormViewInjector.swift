//
//  HomeViewInjector.swift
//  JaoStoreReleases
//
//  Created by João Melo on 13/07/24.
//

import Foundation

class KeyFormViewInjector: Injector {
    override func registerDependencies() {
        let authService = AuthServiceImpl()
        
        container.register(LocalAuthService.self) { _ in authService }
        
        container.register(LocalAuthUseCase.self) { resolver in
            LocalAuthUseCaseImpl(localAuthService: resolver.resolve(LocalAuthService.self)!)
        }
        
        let keyChainService = KeyChainServiceImpl()
        
        container.register(SaveItemKeyChainService.self) { _ in keyChainService }
        
        container.register(SaveItemKeyChainUseCase.self) { resolver in
            SaveItemKeyChainUseCaseImpl(saveItemKeyChainService: resolver.resolve(SaveItemKeyChainService.self)!)
        }
        
        container.register(KeyFormController.self) { resolver in
            KeyFormController(
                localAuthUseCase: resolver.resolve(LocalAuthUseCase.self)!,
                saveItemKeyChainUseCase: resolver.resolve(SaveItemKeyChainUseCase.self)!
            )
        }
    }
}

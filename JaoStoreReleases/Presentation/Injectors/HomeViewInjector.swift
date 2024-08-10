//
//  HomeInjector.swift
//  JaoStoreReleases
//
//  Created by João Melo on 13/07/24.
//

import Foundation

class HomeViewInjector: Injector {
    override func registerDependencies() {
        let authService = AuthServiceImpl()
        
        container.register(LocalAuthService.self) { _ in authService}
        
        container.register(LocalAuthUseCase.self) { resolver in
            LocalAuthUseCaseImpl(localAuthService: resolver.resolve(LocalAuthService.self)!)
        }
        
        let keyChainService = KeyChainServiceImpl()
        
        container.register(GetItemKeyChainService.self) { _ in keyChainService}
        
        container.register(GetItemKeyChainUseCase.self) { resolver in
            GetItemKeyChainUseCaseImpl(getItemKeyChainService: resolver.resolve(GetItemKeyChainService.self)!)
        }
        
        container.register(HomeController.self) { resolver in
            HomeController(
                localAuthUseCase: resolver.resolve(LocalAuthUseCase.self)!,
                getItemKeyChainUseCase: resolver.resolve(GetItemKeyChainUseCase.self)!
            )
        }
    }
}



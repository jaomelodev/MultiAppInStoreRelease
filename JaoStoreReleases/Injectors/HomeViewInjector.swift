//
//  HomeInjector.swift
//  JaoStoreReleases
//
//  Created by João Melo on 13/07/24.
//

import Foundation

class HomeViewInjector: Injector {
    override func registerDependencies() {
        container.register(LocalAuthService.self) { _ in LocalAuthServiceImpl()}
        
        container.register(LocalAuthenticationUseCase.self) { resolver in
            LocalAuthenticationUseCase(localAuthenticationService: resolver.resolve(LocalAuthService.self)!)
        }
        
        container.register(KeyChainService.self) { _ in KeyChainServiceImpl()}
        
        container.register(GetItemKeyChainUseCase.self) { resolver in
            GetItemKeyChainUseCase(keyChainService: resolver.resolve(KeyChainService.self)!)
        }
        
        container.register(HomeController.self) { resolver in
            HomeController(
                localAuthenticationUseCase: resolver.resolve(LocalAuthenticationUseCase.self)!,
                getItemKeyChainUseCase: resolver.resolve(GetItemKeyChainUseCase.self)!
            )
        }
    }
}



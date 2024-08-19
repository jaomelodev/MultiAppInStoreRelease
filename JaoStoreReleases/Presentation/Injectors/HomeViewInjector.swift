//
//  HomeInjector.swift
//  JaoStoreReleases
//
//  Created by João Melo on 13/07/24.
//

import Foundation

class HomeViewInjector: Injector<HomeController> {
    override func registerDependencies() -> HomeController {
        let authService = AuthServiceImpl()
        
        let localAuthUseCase = LocalAuthUseCaseImpl(localAuthService: authService)
        
        let keyChainService = KeyChainServiceImpl()
        
        let getItemKeyChainUseCase = GetItemKeyChainUseCaseImpl(getItemKeyChainService: keyChainService)
        
        return HomeController(
            localAuthUseCase: localAuthUseCase,
            getItemKeyChainUseCase: getItemKeyChainUseCase
        )
    }
}



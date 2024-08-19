//
//  HomeViewInjector.swift
//  JaoStoreReleases
//
//  Created by João Melo on 13/07/24.
//

import SwiftUI

class KeyFormViewInjector: Injector<KeyFormController> {
    let hasKeySaved: Binding<Bool>
    
    init(hasKeySaved: Binding<Bool>) {
        self.hasKeySaved = hasKeySaved
    }
    
    override func registerDependencies() -> KeyFormController {
        let authService = AuthServiceImpl()
        
        let localAuthUseCase = LocalAuthUseCaseImpl(localAuthService: authService)
        
        let keyChainService = KeyChainServiceImpl()
        
        let saveItemKeyChainUseCase = SaveItemKeyChainUseCaseImpl(saveItemKeyChainService: keyChainService)
        
        return KeyFormController(
            hasKeySaved: hasKeySaved,
            localAuthUseCase: localAuthUseCase,
            saveItemKeyChainUseCase: saveItemKeyChainUseCase
        )
    }
}

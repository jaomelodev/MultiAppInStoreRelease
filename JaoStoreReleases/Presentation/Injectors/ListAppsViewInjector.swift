//
//  ListAppsViewInjector.swift
//  JaoStoreReleases
//
//  Created by João Melo on 14/07/24.
//

import SwiftUI

class ListAppsViewInjector: Injector<ListAppsController> {
    let hasKeySaved: Binding<Bool>
    
    init(hasKeySaved: Binding<Bool>) {
        self.hasKeySaved = hasKeySaved
    }
    
    override func registerDependencies() -> ListAppsController {
        let client = AppStoreHTTPClient()
        
        let appStoreAppsService = AppStoreAppsService(appStoreClient: client)
        
        let listAllAppsAppleUseCase = ListAllAppStoreAppsUseCaseImpl(listAllAppStoreAppsService: appStoreAppsService)
        
        let keyChainService = KeyChainServiceImpl()
        
        let removeItemKeyChainUseCase = RemoveItemKeyChainUseCaseImpl(
            removeItemKeyChainService: keyChainService
        )
        
        return ListAppsController(
            hasKeySaved: hasKeySaved,
            listAllAppsAppleUseCase: listAllAppsAppleUseCase,
            removeItemKeyChainUseCase: removeItemKeyChainUseCase
        )
    }
}

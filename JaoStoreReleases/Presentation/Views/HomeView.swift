//
//  HomeView.swift
//  JaoStoreReleases
//
//  Created by João Melo on 13/07/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var controller: HomeController
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                if controller.isLoading {
                    ProgressView("Checking if your key is stored")
                } else {
                    if controller.hasKeySaved {
                        let listAppsViewInjector = ListAppsViewInjector()
                        
                        ListAppsView(controller: listAppsViewInjector.container.resolve(ListAppsController.self)!)
                    } else {
                        let keyFormViewInjector = KeyFormViewInjector()
                        
                        KeyFormView(
                            controller: keyFormViewInjector.container.resolve(KeyFormController.self)!,
                            hasKeySaved: $controller.hasKeySaved
                        )
                    }
                }
                
                Spacer()
            }
            Spacer()
        }
        .onAppear {
            Task {
                await controller.getKeyInStorate()
            }
        }
    }
}

#Preview {

    
    let authService = AuthServiceImpl()
    
    let localAuthUseCase = LocalAuthUseCaseImpl(
        localAuthService: authService
    )
    
    let keyChainService = KeyChainServiceImpl()
    
    let getItemKeyChainUseCase = GetItemKeyChainUseCaseImpl(
        getItemKeyChainService: keyChainService
    )
    
    let homeController = HomeController(
        localAuthUseCase: localAuthUseCase,
        getItemKeyChainUseCase: getItemKeyChainUseCase
    )
    
    return HomeView(
        controller: homeController
    )
}

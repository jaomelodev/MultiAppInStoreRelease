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
                        Text("Authenticated")
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
    let localAuthService = LocalAuthServiceImpl()
    
    let localAuthenticationUseCase = LocalAuthenticationUseCase(
        localAuthenticationService: localAuthService
    )
    
    let keyChainService = KeyChainServiceImpl()
    
    let getItemKeyChainUseCase = GetItemKeyChainUseCase(
        keyChainService: keyChainService
    )
    
    let homeController = HomeController(
        localAuthenticationUseCase: localAuthenticationUseCase,
        getItemKeyChainUseCase: getItemKeyChainUseCase
    )
    
    return HomeView(
        controller: homeController
    )
}

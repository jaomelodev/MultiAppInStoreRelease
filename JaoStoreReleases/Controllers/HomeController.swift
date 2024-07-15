//
//  HomeController.swift
//  JaoStoreReleases
//
//  Created by João Melo on 13/07/24.
//

import Foundation

class HomeController: ObservableObject {
    let localAuthenticationUseCase: LocalAuthenticationUseCase
    
    let getItemKeyChainUseCase: GetItemKeyChainUseCase
    
    @Published var hasKeySaved = false
    
    @Published var isLoading = false
    
    init(
        localAuthenticationUseCase: LocalAuthenticationUseCase,
        getItemKeyChainUseCase: GetItemKeyChainUseCase
    ) {
        self.localAuthenticationUseCase = localAuthenticationUseCase
        self.getItemKeyChainUseCase = getItemKeyChainUseCase
    }
    
    func getKeyInStorate() async -> Void {
        isLoading = true
        
        do {
            let isAuthorized = try await localAuthenticationUseCase.execute(NoParams())
            
            if !isAuthorized {
                return
            }
            
            guard let keyData = try await getItemKeyChainUseCase.execute("privateKey") else {
                hasKeySaved = false
                return
            }
            
            AppStoreHTTPClient.privateKeyInfo = keyData
            
            hasKeySaved = true
        } catch {
            print("Error")
        }
        
        isLoading = false
    }
}

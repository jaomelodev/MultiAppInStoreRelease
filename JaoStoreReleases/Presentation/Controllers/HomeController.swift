//
//  HomeController.swift
//  JaoStoreReleases
//
//  Created by João Melo on 13/07/24.
//

import Foundation

class HomeController: ObservableObject {
    let localAuthUseCase: LocalAuthUseCase
    let getItemKeyChainUseCase: GetItemKeyChainUseCase
    
    @Published var hasKeySaved = false
    
    @Published var isLoading = false
    
    init(
        localAuthUseCase: LocalAuthUseCase,
        getItemKeyChainUseCase: GetItemKeyChainUseCase
    ) {
        self.localAuthUseCase = localAuthUseCase
        self.getItemKeyChainUseCase = getItemKeyChainUseCase
    }
    
    func getKeyInStorate() async -> Void {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        defer {
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
        
        let authResult = await localAuthUseCase.execute(NoParams())
        
        if case .failure(_) = authResult {
            print("Not Authorized")
            return
        }
        
        let keyDataResult = await getItemKeyChainUseCase.execute(KeyChain.privateKeyName)
        
        if case .failure(_) = keyDataResult {
            DispatchQueue.main.async {
                self.hasKeySaved = false
            }
            
            return
        }
        
        let keyData = try! keyDataResult.get()
        
        AppStoreHTTPClient.privateKeyInfo = keyData
        
        DispatchQueue.main.async {
            self.hasKeySaved = true
        }
    }
}

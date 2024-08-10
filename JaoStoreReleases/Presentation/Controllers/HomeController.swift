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
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        let authResult = await localAuthUseCase.execute(NoParams())
        
        if case .failure(_) = authResult {
            print("Not Authorized")
            return
        }
        
        let keyDataResult = await getItemKeyChainUseCase.execute("privateKey")
        
        if case .failure(_) = keyDataResult {
            hasKeySaved = false
            return
        }
        
        let keyData = try! keyDataResult.get()
        
        AppStoreHTTPClient.privateKeyInfo = keyData
        
        hasKeySaved = true
    }
}

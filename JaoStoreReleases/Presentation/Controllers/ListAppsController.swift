//
//  ListAppsController.swift
//  JaoStoreReleases
//
//  Created by João Melo on 14/07/24.
//

import SwiftUI
import Combine

class ListAppsController: ObservableObject {
    @Binding var hasKeySaved: Bool
    
    let listAllAppsAppleUseCase: ListAllAppStoreAppsUseCase
    let removeItemKeyChainUseCase: RemoveItemKeyChainUseCase
    
    @Published var apps: [ListAppItemEntity] = []
    @Published var loadingApps = false
    @Published var errorMessage = ""
    
    @Published var selectedApp: ListAppItemEntity?
    
    @Published var showChangeAccountDialog: Bool = false
    
    init(
        hasKeySaved: Binding<Bool>,
        listAllAppsAppleUseCase: ListAllAppStoreAppsUseCase,
        removeItemKeyChainUseCase: RemoveItemKeyChainUseCase
    ) {
        self._hasKeySaved = hasKeySaved
        self.listAllAppsAppleUseCase = listAllAppsAppleUseCase
        self.removeItemKeyChainUseCase = removeItemKeyChainUseCase
    }
    
    func listAllApps() async {
        DispatchQueue.main.async {
            self.loadingApps = true
            self.errorMessage = ""
        }
        
        let result = await listAllAppsAppleUseCase.execute(NoParams())
        
        DispatchQueue.main.async {
            self.loadingApps = false
            switch result {
            case .success(let apps):
                self.apps = apps.sorted { $0.name < $1.name }
            case .failure(let error):
                self.errorMessage = "Could not load your apps, try again later. Error: \(error.localizedDescription)"
            }
        }
    }
    
    func changeAccount() async -> Void {
        let response = await removeItemKeyChainUseCase.execute(KeyChain.privateKeyName)
        
        DispatchQueue.main.async {
            switch response {
            case .success(_):
                self.hasKeySaved = false
            case .failure(_):
                print("Failed to delete key info")
            }
        }
    }
}

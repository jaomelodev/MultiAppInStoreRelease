//
//  ListAppsController.swift
//  JaoStoreReleases
//
//  Created by João Melo on 14/07/24.
//

import Foundation
import Combine

class ListAppsController: ObservableObject {
    let listAllAppsAppleUseCase: ListAllAppsAppleUseCase
    
    @Published var apps: [ListAppItemEntity] = []
    @Published var loadingApps = false
    @Published var errorMessage = ""
    
    @Published var selectedApp: ListAppItemEntity?
    
    init(
        listAllAppsAppleUseCase: ListAllAppsAppleUseCase
    ) {
        self.listAllAppsAppleUseCase = listAllAppsAppleUseCase
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
    
    func changeItem() -> Void {
        let listAppItem = ListAppItemEntity(
            id: "asdfasdf",
            appOrBundleId: "br.com.me",
            name: "My App",
            type: .apple,
            imageUrl: "https://is1-ssl.mzstatic.com/image/thumb/Purple211/v4/78/98/66/7898667a-28f6-80a3-c7a3-118585cf6d69/AppIcon-prod60x60@2x.png/120x120bb.png",
            appStoreVersion: AppStoreVersionEntity(
                id: "132132132",
                state: .accepted,
                versionString: "2024.07.15"
            )
        )
        
        apps[0] = listAppItem
    }
}

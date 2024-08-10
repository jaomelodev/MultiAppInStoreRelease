//
//  AppDetailsController.swift
//  JaoStoreReleases
//
//  Created by João Melo on 06/08/24.
//

import SwiftUI
import Combine

class AppDetailsController: ObservableObject {
    @Published var appItem: ListAppItemEntity
    
    let listAvailableAppBuildsUseCase: ListAvailableAppBuildsUseCase
    let createNewReleaseUseCase: CreateNewReleaseUseCase
    let getAppVersionFromAppUseCase: GetAppVersionFromAppUseCase
    
    let updateItemOnAppList: (ListAppItemEntity) -> Void
    
    var listBuildsTask: AnyCancellable?
    
    enum AppBuildsState {
        case loading
        case appBuilds([AppBuildEntity])
        case empty
        case error(String)
    }

    @Published private(set) var appBuildsState: AppBuildsState = .appBuilds([])
    
    @Published var showCreateReleaseForm = false
    
    @Published var versionString: String = ""
    @Published var releaseNotes: String = ""
    @Published var selectedBuild: String = ""
    @Published var usesNonExemptEncryption: Bool = false
    
    @Published var createNewVersionControllerError: String = ""
    
    @Published var getAppVersionLoading: Bool = false
    
    init(
        appItem: ListAppItemEntity,
        listAvailableAppBuildsUseCase: ListAvailableAppBuildsUseCase,
        createNewReleaseUseCase: CreateNewReleaseUseCase,
        getAppVersionFromAppUseCase: GetAppVersionFromAppUseCase,
        updateItemOnAppList: @escaping (ListAppItemEntity) -> Void
    ) {
        self.appItem = appItem
        self.listAvailableAppBuildsUseCase = listAvailableAppBuildsUseCase
        self.createNewReleaseUseCase = createNewReleaseUseCase
        self.getAppVersionFromAppUseCase = getAppVersionFromAppUseCase
        self.updateItemOnAppList = updateItemOnAppList
    }
    
    func listAppBuilds() {
        listBuildsTask = Task {
            guard let appStoreVersion = self.appItem.appStoreVersion else {
                return
            }
            
            DispatchQueue.main.async {
                self.appBuildsState = .loading
            }
            
            let result = await listAvailableAppBuildsUseCase.execute(
                ListAvailableAppBuildsParams(appId: appItem.id, appVersionId: appStoreVersion.id)
            )
            
            DispatchQueue.main.async {
                switch result {
                case .success(let builds):
                    let appBuildsState: AppBuildsState = builds.isEmpty ? .empty : .appBuilds(builds)
                    
                    self.appBuildsState = appBuildsState
                case .failure(let error):
                    if error != .canceled {
                        self.appBuildsState = .error("Could not load app builds. Error: \(error.localizedDescription)")
                    } else {
                        print("cancelado")
                    }
                }
            }
        }.eraseToAnyCancellable()
    }
    
    func validateForm() -> Bool {
        createNewVersionControllerError = ""
        
        versionString = versionString.trimmingCharacters(in: .whitespacesAndNewlines)
        releaseNotes = releaseNotes.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if versionString.isEmpty {
            createNewVersionControllerError = "Invalid Version ID"
        } else if releaseNotes.isEmpty {
            createNewVersionControllerError = "Invalid Release Notes"
        } else if (selectedBuild.isEmpty) {
            createNewVersionControllerError = "Select your build"
        }
        
        return createNewVersionControllerError.isEmpty
    }
    
    func createNewReleaseForApp() async -> Void {
        if !validateForm() {
            return
        }
        
        let response = await createNewReleaseUseCase.execute(
            CreateNewReleaseParams(
                appVersionId: appItem.appStoreVersion?.state != .readyForSale ? appItem.appStoreVersion?.id : nil,
                versionString: versionString,
                appId: appItem.id,
                whatsNew: releaseNotes,
                buildId: selectedBuild,
                usesNonExemptEncryption: usesNonExemptEncryption
            )
        )
        
        switch response {
        case .success(let success):
            DispatchQueue.main.async {
                self.showCreateReleaseForm = false
            }
            
            await self.getAppVersion()
        case .failure(_):
            DispatchQueue.main.async {
                self.createNewVersionControllerError = "Could not create the release"
            }
        }
    }
    
    func getAppVersion() async -> Void {
        DispatchQueue.main.async {
            self.getAppVersionLoading = true
        }
        
        let response = await getAppVersionFromAppUseCase.execute(appItem.id)
        
        DispatchQueue.main.async {
            switch response {
            case .success(let appVersion):
                self.appItem = self.appItem.copyWith(appStoreVersion: appVersion)
                self.updateItemOnAppList(self.appItem)
            case .failure(_):
                print("Deu ruim no app verison")
            }
            
            self.getAppVersionLoading = false
        }
    }
}

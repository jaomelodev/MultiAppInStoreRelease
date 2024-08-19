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
    let getAppVersionFromAppUseCase: GetAppAppVersionUseCase
    let releaseAppVersionUseCase: ReleaseAppVersionUseCase
    
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
    @Published var createNewVersionFormError: String = ""
    
    enum CreateVersionState: Equatable {
        case idle
        case loading(String)
        case versionCreated
        case error
    }
    
    @Published private(set) var createAppVersionState: CreateVersionState = .idle
    
    @Published var showReleaseVersionDialog = false
    
    enum ReleaseVersionState: Equatable {
        case idle
        case loading
        case error
        case success
    }
    
    @Published private(set) var releaseVersionState: ReleaseVersionState = .idle
    
    @Published var getAppVersionLoading: Bool = false
    
    init(
        appItem: ListAppItemEntity,
        listAvailableAppBuildsUseCase: ListAvailableAppBuildsUseCase,
        createNewReleaseUseCase: CreateNewReleaseUseCase,
        getAppVersionFromAppUseCase: GetAppAppVersionUseCase,
        releaseAppVersionUseCase: ReleaseAppVersionUseCase,
        updateItemOnAppList: @escaping (ListAppItemEntity) -> Void
    ) {
        self.appItem = appItem
        self.listAvailableAppBuildsUseCase = listAvailableAppBuildsUseCase
        self.createNewReleaseUseCase = createNewReleaseUseCase
        self.getAppVersionFromAppUseCase = getAppVersionFromAppUseCase
        self.releaseAppVersionUseCase = releaseAppVersionUseCase
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
    
    func openCreateReleaseForm() -> Void {
        createAppVersionState = .idle
        
        showCreateReleaseForm = true
    }
    
    func validateForm() -> Bool {
        createNewVersionFormError = ""
        
        versionString = versionString.trimmingCharacters(in: .whitespacesAndNewlines)
        releaseNotes = releaseNotes.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if versionString.isEmpty {
            createNewVersionFormError = "Invalid Version ID"
        } else if releaseNotes.isEmpty {
            createNewVersionFormError = "Invalid Release Notes"
        } else if (selectedBuild.isEmpty) {
            createNewVersionFormError = "Select your build"
        }
        
        return createNewVersionFormError.isEmpty
    }
    
    func createNewReleaseForApp() async -> Void {
        if !validateForm() {
            return
        }
        
        DispatchQueue.main.async {
            self.createAppVersionState = .loading("Creating the version")
        }
        
        let response = await createNewReleaseUseCase.execute(
            CreateNewReleaseParams(
                appVersionId: appItem.appStoreVersion?.state != .readyForSale ? appItem.appStoreVersion?.id : nil,
                versionString: versionString,
                appId: appItem.id,
                whatsNew: releaseNotes,
                buildId: selectedBuild,
                usesNonExemptEncryption: usesNonExemptEncryption
            ) { loadingMessage in
                DispatchQueue.main.async {
                    self.createAppVersionState = .loading(loadingMessage)
                }
            }
        )
        
        switch response {
        case .success(_):
            DispatchQueue.main.async {
                self.createAppVersionState = .versionCreated
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.showCreateReleaseForm = false
                Task {
                    await self.getAppVersion()
                }
                
            }
        case .failure(_):
            DispatchQueue.main.async {
                self.createAppVersionState = .error
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.showCreateReleaseForm = false
                Task {
                    await self.getAppVersion()
                }
                
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
    
    func releaseAppVersion() async -> Void {
        guard let appVersion = appItem.appStoreVersion else {
            return
        }
        
        if appVersion.state != .pendingDeveloperRelease {
            return
        }
        
        DispatchQueue.main.async {
            self.releaseVersionState = .loading
        }
        
        let response = await releaseAppVersionUseCase.execute(appVersion.id)
        
        DispatchQueue.main.async {
            switch response {
            case .success(_):
                self.releaseVersionState = .success
            case .failure(_):
                self.releaseVersionState = .error
            }
        }
    }
}

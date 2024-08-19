//
//  ListAllAppsAppleUseCaseMock.swift
//  JaoStoreReleases
//
//  Created by João Melo on 03/08/24.
//

#if DEBUG
let listAllAppStoreAppsMockResult = [
    ListAppItemEntity(
        id: "asdfasdf",
        appOrBundleId: "br.com.me",
        name: "My App",
        type: .apple,
        imageUrl: "https://is1-ssl.mzstatic.com/image/thumb/Purple211/v4/78/98/66/7898667a-28f6-80a3-c7a3-118585cf6d69/AppIcon-prod60x60@2x.png/120x120bb.png",
        appStoreVersion: AppStoreVersionEntity(
            id: "132132132",
            state: .pendingDeveloperRelease,
            versionString: "2024.07.15"
        )
    )
]

class ListAllAppStoreAppsCaseMock: ListAllAppStoreAppsUseCase {
    let result: Result<[ListAppItemEntity], ListAllAppStoreAppsError>
    
    init(result: Result<[ListAppItemEntity], ListAllAppStoreAppsError> = .success(listAllAppStoreAppsMockResult)) {
        self.result = result
    }
    
    override func execute(_ params: NoParams) async -> Result<[ListAppItemEntity], ListAllAppStoreAppsError> {
        return result
    }
}
#endif

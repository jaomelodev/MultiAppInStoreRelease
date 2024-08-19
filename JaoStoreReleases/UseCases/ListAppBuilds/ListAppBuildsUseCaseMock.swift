//
//  ListAllAppBuildsUseCaseMock.swift
//  JaoStoreReleases
//
//  Created by João Melo on 03/08/24.
//


#if DEBUG
import Foundation

let listAppBuildsMockResponse = [
    AppBuildEntity(
        id: "asdfasdfasd",
        version: "24072401",
        uploadedDate: Date.now,
        imgUrl: "https://is1-ssl.mzstatic.com/image/thumb/Purple211/v4/78/98/66/7898667a-28f6-80a3-c7a3-118585cf6d69/AppIcon-prod60x60@2x.png/120x120bb.png",
        buildState: .valid
    ),
    AppBuildEntity(
        id: "asdfasdfasd",
        version: "24072401",
        uploadedDate: Date.now,
        imgUrl: "https://is1-ssl.mzstatic.com/image/thumb/Purple211/v4/78/98/66/7898667a-28f6-80a3-c7a3-118585cf6d69/AppIcon-prod60x60@2x.png/120x120bb.png",
        buildState: .processing
    ),
    AppBuildEntity(
        id: "asdfasdfasd",
        version: "24072401",
        uploadedDate: Date.now,
        imgUrl: "https://is1-ssl.mzstatic.com/image/thumb/Purple211/v4/78/98/66/7898667a-28f6-80a3-c7a3-118585cf6d69/AppIcon-prod60x60@2x.png/120x120bb.png",
        buildState: .failed
    )
]

class ListAppBuildsUseCaseMock: ListAppBuildsUseCase {
    let result: Result<Array<AppBuildEntity>, ListAppBuildsError>
    
    init(result: Result<Array<AppBuildEntity>, ListAppBuildsError> = .success(listAppBuildsMockResponse)) {
        self.result = result
    }
    
    override func execute(_ params: String) async -> Result<Array<AppBuildEntity>, ListAppBuildsError> {
        return result
    }
}
#endif

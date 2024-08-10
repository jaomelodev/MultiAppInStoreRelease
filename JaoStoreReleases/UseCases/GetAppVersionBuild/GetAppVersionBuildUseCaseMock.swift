//
//  GetAppVersionBuildUseCaseMock.swift
//  JaoStoreReleases
//
//  Created by João Melo on 09/08/24.
//

#if DEBUG
import Foundation

let getAppVersionBuildDefaultResponse = AppBuildEntity(
    id: "asdfasde",
    version: "2024.08.09",
    uploadedDate: Date.now,
    imgUrl: "https://is1-ssl.mzstatic.com/image/thumb/Purple211/v4/78/98/66/7898667a-28f6-80a3-c7a3-118585cf6d69/AppIcon-prod60x60@2x.png/120x120bb.png",
    buildState: .valid
)

class GetAppVersionBuildUseCaseMock: GetAppVersionBuildUseCase {
    let result: Result<AppBuildEntity, GetAppVersionBuildError>
    
    init(result: Result<AppBuildEntity, GetAppVersionBuildError> = .success(getAppVersionBuildDefaultResponse)) {
        self.result = result
    }
    
    override func execute(_ params: String) async -> Result<AppBuildEntity, GetAppVersionBuildError> {
        return result
    }
}
#endif



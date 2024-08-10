//
//  GetAppVersionFromAppUseCaseMock.swift
//  JaoStoreReleases
//
//  Created by João Melo on 10/08/24.
//

#if DEBUG
import Foundation

let getAppVersionFromAppDefaultResponse = AppStoreVersionEntity(
    id: "asdfasdf",
    state: .readyForSale,
    versionString: "2024.08.10"
)

class GetAppVersionFromAppUseCaseMock: GetAppVersionFromAppUseCase {
    let result: Result<AppStoreVersionEntity, GetAppVersionFromAppError>
    
    init(result: Result<AppStoreVersionEntity, GetAppVersionFromAppError> = .success(getAppVersionDefaultResponse)) {
        self.result = result
    }
    
    override func execute(_ params: String) async -> Result<AppStoreVersionEntity, GetAppVersionFromAppError> {
        return result
    }
}
#endif

//
//  GetAppVersionFromAppUseCaseMock.swift
//  JaoStoreReleases
//
//  Created by João Melo on 10/08/24.
//

#if DEBUG
import Foundation

let getAppAppVersionDefaultResponse = AppStoreVersionEntity(
    id: "asdfasdf",
    state: .readyForSale,
    versionString: "2024.08.10"
)

class GetAppAppVersionUseCaseMock: GetAppAppVersionUseCase {
    let result: Result<AppStoreVersionEntity, GetAppAppVersionError>
    
    init(result: Result<AppStoreVersionEntity, GetAppAppVersionError> = .success(getAppAppVersionDefaultResponse)) {
        self.result = result
    }
    
    override func execute(_ params: String) async -> Result<AppStoreVersionEntity, GetAppAppVersionError> {
        return result
    }
}
#endif

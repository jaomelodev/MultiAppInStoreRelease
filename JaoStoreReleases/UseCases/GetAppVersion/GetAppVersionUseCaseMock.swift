//
//  GetAppVersionUseCaseMock.swift
//  JaoStoreReleases
//
//  Created by João Melo on 10/08/24.
//

#if DEBUG
import Foundation

let getAppVersionDefaultResponse = AppStoreVersionEntity(
    id: "asdfasdf",
    state: .readyForSale,
    versionString: "2024.08.10"
)


class GetAppVersionUseCaseMock: GetAppVersionUseCase {
    let result: Result<AppStoreVersionEntity, GetAppVersionError>
    
    init(result: Result<AppStoreVersionEntity, GetAppVersionError> = .success(getAppVersionDefaultResponse)) {
        self.result = result
    }
    
    override func execute(_ params: String) async -> Result<AppStoreVersionEntity, GetAppVersionError> {
        return result
    }
}
#endif

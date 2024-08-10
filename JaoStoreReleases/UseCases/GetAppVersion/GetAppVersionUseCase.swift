//
//  GetAppVersionUseCase.swift
//  JaoStoreReleases
//
//  Created by João Melo on 10/08/24.
//

import Foundation

class GetAppVersionUseCase: UseCase<String, AppStoreVersionEntity, GetAppVersionError> {}

class GetAppVersionUseCaseImpl: GetAppVersionUseCase {
    let getAppVersionService: GetAppVersionService
    
    init(getAppVersionService: GetAppVersionService) {
        self.getAppVersionService = getAppVersionService
    }
    
    override func execute(_ params: String) async -> Result<AppStoreVersionEntity, GetAppVersionError> {
        let response = await getAppVersionService.getAppVersion(appVersionId: params)
        
        if case .failure(let failure) = response {
            return .failure(failure)
        }
        
        guard let data = try? response.get() else {
            return .failure(.cannotConvert)
        }
        
        let appVersion = data.toAppStoreVersionEntity()
        
        return .success(appVersion)
    }
}

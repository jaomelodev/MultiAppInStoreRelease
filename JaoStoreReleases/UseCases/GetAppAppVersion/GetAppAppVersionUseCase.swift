//
//  GetAppVersionFromAppUseCase.swift
//  JaoStoreReleases
//
//  Created by João Melo on 10/08/24.
//

import Foundation

class GetAppAppVersionUseCase: UseCase<String, AppStoreVersionEntity, GetAppAppVersionError> {}

class GetAppAppVersionUseCaseImpl: GetAppAppVersionUseCase {
    let getAppAppVersionService: GetAppAppVersionService
    
    init(getAppAppVersionService: GetAppAppVersionService) {
        self.getAppAppVersionService = getAppAppVersionService
    }
    
    override func execute(_ params: String) async -> Result<AppStoreVersionEntity, GetAppAppVersionError> {
        let response = await getAppAppVersionService.getAppAppVersion(appId: params)
        
        if case .failure(let failure) = response {
            return .failure(failure)
        }
        
        guard let appBuildModel = try? response.get() else {
            return .failure(.cannotConvert)
        }
        
        return .success(appBuildModel.toAppStoreVersionEntity())
    }
}

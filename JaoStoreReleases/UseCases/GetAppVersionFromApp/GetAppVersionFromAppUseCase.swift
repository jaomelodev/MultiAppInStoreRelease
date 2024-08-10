//
//  GetAppVersionFromAppUseCase.swift
//  JaoStoreReleases
//
//  Created by João Melo on 10/08/24.
//

import Foundation

class GetAppVersionFromAppUseCase: UseCase<String, AppStoreVersionEntity, GetAppVersionFromAppError> {}

class GetAppVersionFromAppUseCaseImpl: GetAppVersionFromAppUseCase {
    let getAppVersionFromAppService: GetAppVersionFromAppService
    
    init(getAppVersionFromAppService: GetAppVersionFromAppService) {
        self.getAppVersionFromAppService = getAppVersionFromAppService
    }
    
    override func execute(_ params: String) async -> Result<AppStoreVersionEntity, GetAppVersionFromAppError> {
        let response = await getAppVersionFromAppService.getAppVersionFromApp(appId: params)
        
        if case .failure(let failure) = response {
            return .failure(failure)
        }
        
        guard let appBuildModel = try? response.get() else {
            return .failure(.cannotConvert)
        }
        
        return .success(appBuildModel.toAppStoreVersionEntity())
    }
}

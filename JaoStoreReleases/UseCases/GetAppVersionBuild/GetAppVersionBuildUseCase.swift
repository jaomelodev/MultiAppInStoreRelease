//
//  GetAppVersionBuildUseCase.swift
//  JaoStoreReleases
//
//  Created by João Melo on 09/08/24.
//

import Foundation

class GetAppVersionBuildUseCase: UseCase<String, AppBuildEntity, GetAppVersionBuildError> {}

class GetAppVersionBuildUseCaseImpl: GetAppVersionBuildUseCase {
    let getAppVersionBuildService: GetAppVersionBuildService
    
    init(getAppVersionBuildService: GetAppVersionBuildService) {
        self.getAppVersionBuildService = getAppVersionBuildService
    }
    
    override func execute(_ params: String) async -> Result<AppBuildEntity, GetAppVersionBuildError> {
        let response = await getAppVersionBuildService.getAppVersionBuild(appVersionId: params)
        
        if case .failure(let failure) = response {
            return .failure(failure)
        }
        
        guard let data = try? response.get() else {
            return .failure(.cannotConvert)
        }
        
        return .success(data.toAppBuildEntity())
    }
}

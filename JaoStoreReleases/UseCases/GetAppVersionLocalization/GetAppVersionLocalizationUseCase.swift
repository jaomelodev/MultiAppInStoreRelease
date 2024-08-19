//
//  GetLocalizationFromReleaseUseCase.swift
//  JaoStoreReleases
//
//  Created by João Melo on 01/08/24.
//

import Foundation

class GetAppVersionLocalizationUseCase: UseCase<String, String, GetAppVersionLocalizationError> {}

class GetAppVersionLocalizationUseCaseImpl: GetAppVersionLocalizationUseCase {
    let getAppVersionLocalizationService: GetAppVersionLocalizationService
    
    init(getAppVersionLocalizationService: GetAppVersionLocalizationService) {
        self.getAppVersionLocalizationService = getAppVersionLocalizationService
    }
    
    override func execute(_ params: String) async -> Result<String, GetAppVersionLocalizationError> {
        return await getAppVersionLocalizationService.getLocalizationFromRelease(appVersionId: params)
    }
}

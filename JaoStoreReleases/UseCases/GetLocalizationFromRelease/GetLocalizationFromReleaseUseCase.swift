//
//  GetLocalizationFromReleaseUseCase.swift
//  JaoStoreReleases
//
//  Created by João Melo on 01/08/24.
//

import Foundation

class GetLocalizationFromReleaseUseCase: UseCase<String, String, GetLocalizationFromReleaseError> {}

class GetLocalizationFromReleaseUseCaseImpl: GetLocalizationFromReleaseUseCase {
    let getLocalizationFromReleaseService: GetLocalizationFromReleaseService
    
    init(getLocalizationFromReleaseService: GetLocalizationFromReleaseService) {
        self.getLocalizationFromReleaseService = getLocalizationFromReleaseService
    }
    
    override func execute(_ params: String) async -> Result<String, GetLocalizationFromReleaseError> {
        return await getLocalizationFromReleaseService.getLocalizationFromRelease(releaseId: params)
    }
}

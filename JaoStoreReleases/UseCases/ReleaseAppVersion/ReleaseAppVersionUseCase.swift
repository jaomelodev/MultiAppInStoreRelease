//
//  ReleaseAppVersionUseCase.swift
//  JaoStoreReleases
//
//  Created by João Melo on 13/08/24.
//

import Foundation

class ReleaseAppVersionUseCase: UseCase<String, Void, ReleaseAppVersionError> {}

class ReleaseAppVersionUseCaseImpl: ReleaseAppVersionUseCase {
    let releaseAppVersionService: ReleaseAppVersionService
    
    init(releaseAppVersionService: ReleaseAppVersionService) {
        self.releaseAppVersionService = releaseAppVersionService
    }
    
    override func execute(_ params: String) async -> Result<Void, ReleaseAppVersionError> {
        return await releaseAppVersionService.releaseAppVersion(appVersionId: params)
    }
}

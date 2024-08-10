//
//  UpdateAppVersionUseCase.swift
//  JaoStoreReleases
//
//  Created by João Melo on 08/08/24.
//

import Foundation

class UpdateAppVersionUseCase: UseCase<UpdateAppVersionParams, Void, UpdateAppVersionError> {}

class UpdateAppVersionUseCaseImpl: UpdateAppVersionUseCase {
    let updateAppVersionService: UpdateAppVersionService
    
    init(updateAppVersionService: UpdateAppVersionService) {
        self.updateAppVersionService = updateAppVersionService
    }
    
    override func execute(_ params: UpdateAppVersionParams) async -> Result<Void, UpdateAppVersionError> {
        return await updateAppVersionService.updateAppVersion(params: params)
    }
}

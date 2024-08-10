//
//  CreateAppReleaseUseCase.swift
//  JaoStoreReleases
//
//  Created by João Melo on 30/07/24.
//

import Foundation

class CreateAppVersionUseCase: UseCase<CreateAppVersionParams, String, CreateAppVersionError> {}

class CreateAppVersionUseCaseImpl: CreateAppVersionUseCase {
    let createAppVersionService: CreateAppVersionService
    
    init(createAppVersionService: CreateAppVersionService) {
        self.createAppVersionService = createAppVersionService
    }
    
    override func execute(_ params: CreateAppVersionParams) async -> Result<String, CreateAppVersionError> {
        return await createAppVersionService.createAppVersion(params: params);
    }
}

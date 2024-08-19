//
//  AddBuildToAppReleaseUseCase.swift
//  JaoStoreReleases
//
//  Created by João Melo on 31/07/24.
//

import Foundation

class AddBuildToAppVersionUseCase: UseCase<AddBuildToAppVersionParams, Void, AddBuildToAppVersionError> {}

class AddBuildToAppVersionUseCaseImpl: AddBuildToAppVersionUseCase {
    let addBuildToAppVersionService: AddBuildToAppVersionService
    
    init(addBuildToAppVersionService: AddBuildToAppVersionService) {
        self.addBuildToAppVersionService = addBuildToAppVersionService
    }
    
    override func execute(_ params: AddBuildToAppVersionParams) async -> Result<Void, AddBuildToAppVersionError> {
        return await addBuildToAppVersionService.addBuildToAppVersion(params: params)
    }
}

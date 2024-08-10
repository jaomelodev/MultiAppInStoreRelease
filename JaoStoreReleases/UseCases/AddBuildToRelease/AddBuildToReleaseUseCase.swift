//
//  AddBuildToAppReleaseUseCase.swift
//  JaoStoreReleases
//
//  Created by João Melo on 31/07/24.
//

import Foundation

class AddBuildToReleaseUseCase: UseCase<AddBuildToReleaseParams, Void, AddBuildToReleaseError> {}

class AddBuildToReleaseUseCaseImpl: AddBuildToReleaseUseCase {
    let addBuildToReleaseService: AddBuildToReleaseService
    
    init(addBuildToReleaseService: AddBuildToReleaseService) {
        self.addBuildToReleaseService = addBuildToReleaseService
    }
    
    override func execute(_ params: AddBuildToReleaseParams) async -> Result<Void, AddBuildToReleaseError> {
        return await addBuildToReleaseService.addBuildToRelease(params: params)
    }
}

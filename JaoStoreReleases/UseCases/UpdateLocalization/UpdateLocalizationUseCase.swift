//
//  AddLocalizationToReleaseUseCase.swift
//  JaoStoreReleases
//
//  Created by João Melo on 01/08/24.
//

import Foundation

class UpdateLocalizationUseCase: UseCase<UpdateLocalizationParams, Void, UpdateLocalizationError> {}

class UpdateLocalizationUseCaseImpl: UpdateLocalizationUseCase {
    let addLocalizationToReleaseService: UpdateLocalizationService
    
    init(addLocalizationToReleaseService: UpdateLocalizationService) {
        self.addLocalizationToReleaseService = addLocalizationToReleaseService
    }
    
    override func execute(_ params: UpdateLocalizationParams) async -> Result<Void, UpdateLocalizationError> {
        return await addLocalizationToReleaseService.updateLocalization(params: params);
    }
}

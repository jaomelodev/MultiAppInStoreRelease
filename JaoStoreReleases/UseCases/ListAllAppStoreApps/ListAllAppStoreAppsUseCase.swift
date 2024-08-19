//
//  ListAllAppsUseCase.swift
//  JaoStoreReleases
//
//  Created by João Melo on 17/07/24.
//

import Foundation

class ListAllAppStoreAppsUseCase: UseCase<NoParams, [ListAppItemEntity], ListAllAppStoreAppsError> {}

class ListAllAppStoreAppsUseCaseImpl: ListAllAppStoreAppsUseCase {
    let listAllAppStoreAppsService: ListAllAppStoreAppsService
    
    init(listAllAppStoreAppsService: ListAllAppStoreAppsService) {
        self.listAllAppStoreAppsService = listAllAppStoreAppsService
    }
    
    override func execute(_ params: NoParams) async -> Result<[ListAppItemEntity], ListAllAppStoreAppsError> {
        let result = await listAllAppStoreAppsService.listAllAppStoreApps()
        
        if case .failure(let failure) = result {
            return .failure(failure)
        }
        
        guard let data = try? result.get() else {
            return .failure(.cannotConvert)
        }
        
        let entities = data.map { $0.toAppFromStoreEntity() }
        
        return .success(entities)
    }
}

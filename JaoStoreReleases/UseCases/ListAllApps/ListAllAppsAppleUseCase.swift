//
//  ListAllAppsUseCase.swift
//  JaoStoreReleases
//
//  Created by João Melo on 17/07/24.
//

import Foundation

class ListAllAppsAppleUseCase: UseCase<NoParams, [ListAppItemEntity], ListAllAppsAppleError> {}

class ListAllAppsAppleUseCaseImpl: ListAllAppsAppleUseCase {
    let appStoreService: ListAllAppsAppleService
    
    init(appStoreService: ListAllAppsAppleService) {
        self.appStoreService = appStoreService
    }
    
    override func execute(_ params: NoParams) async -> Result<[ListAppItemEntity], ListAllAppsAppleError> {
        let result = await appStoreService.listAllApps()
        
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

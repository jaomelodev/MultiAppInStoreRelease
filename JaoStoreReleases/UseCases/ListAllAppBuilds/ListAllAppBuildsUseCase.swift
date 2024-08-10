//
//  ListAllAppBuildsUseCase.swift
//  JaoStoreReleases
//
//  Created by João Melo on 22/07/24.
//

import Foundation

class ListAllAppBuildsUseCase: UseCase<String, [AppBuildEntity], ListAllAppBuildsError> {}

class ListAllAppBuildsUseCaseImpl: ListAllAppBuildsUseCase {
    let listAllAppBuildsService: ListAllAppBuildsService
    
    init(listAllAppBuildsService: ListAllAppBuildsService) {
        self.listAllAppBuildsService = listAllAppBuildsService
    }
    
    override func execute(_ params: String) async -> Result<[AppBuildEntity], ListAllAppBuildsError> {
        let response = await listAllAppBuildsService.listAllAppBuilds(appId: params)
        
        if case .failure(let failure) = response {
            return .failure(failure)
        }
        
        let data = try! response.get()
        
        let appBuilds = data.map { $0.toAppBuildEntity() }
        
        return .success(appBuilds)
    }
}

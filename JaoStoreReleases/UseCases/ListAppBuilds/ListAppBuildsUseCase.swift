//
//  ListAllAppBuildsUseCase.swift
//  JaoStoreReleases
//
//  Created by João Melo on 22/07/24.
//

import Foundation

class ListAppBuildsUseCase: UseCase<String, [AppBuildEntity], ListAppBuildsError> {}

class ListAppBuildsUseCaseImpl: ListAppBuildsUseCase {
    let listAppBuildsService: ListAppBuildsService
    
    init(listAppBuildsService: ListAppBuildsService) {
        self.listAppBuildsService = listAppBuildsService
    }
    
    override func execute(_ params: String) async -> Result<[AppBuildEntity], ListAppBuildsError> {
        let response = await listAppBuildsService.listAppBuilds(appId: params)
        
        if case .failure(let failure) = response {
            return .failure(failure)
        }
        
        let data = try! response.get()
        
        let appBuilds = data.map { $0.toAppBuildEntity() }
        
        return .success(appBuilds)
    }
}

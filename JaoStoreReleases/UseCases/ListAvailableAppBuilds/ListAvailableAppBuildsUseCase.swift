//
//  ListAvailableAppBuilds.swift
//  JaoStoreReleases
//
//  Created by João Melo on 09/08/24.
//

import Foundation

class ListAvailableAppBuildsUseCase: UseCase<ListAvailableAppBuildsParams, [AppBuildEntity], ListAvailableAppBuildsError> {}

class ListAvailableAppBuildsUseCaseImpl: ListAvailableAppBuildsUseCase {
    let listAllAppBuildsUseCase: ListAppBuildsUseCase
    let getAppVersionBuildUseCase: GetAppVersionBuildUseCase
    
    init(listAllAppBuildsUseCase: ListAppBuildsUseCase, getAppVersionBuildUseCase: GetAppVersionBuildUseCase) {
        self.listAllAppBuildsUseCase = listAllAppBuildsUseCase
        self.getAppVersionBuildUseCase = getAppVersionBuildUseCase
    }
    
    override func execute(_ params: ListAvailableAppBuildsParams) async -> Result<[AppBuildEntity], ListAvailableAppBuildsError> {
        async let listAllAppBuildsResponse = self.listAllAppBuildsUseCase.execute(params.appId)
        async let getAppVersionBuildResponse = self.getAppVersionBuildUseCase.execute(params.appVersionId)
        
        let listAllAppBuildsResult = await listAllAppBuildsResponse
        let getAppVersionBuildResult = await getAppVersionBuildResponse
        
        if case .failure(let failure) = listAllAppBuildsResult {
            if case .canceled = failure {
                return .failure(.canceled)
            }
            
            return .failure(.failedToListAllBuilds)
        }
        
        if case .failure(_) = getAppVersionBuildResult {
            return .failure(.failedToGetAppVersionBuild)
        }
        
        guard let allAppBuilds = try? listAllAppBuildsResult.get(),
              let appVersionBuild = try? getAppVersionBuildResult.get() else {
            return .failure(.cannotConvert)
        }
        
        let availableBuilds = allAppBuilds.filter { Int($0.version) ?? 0 >= Int(appVersionBuild.version) ?? 0 }
        
        return .success(availableBuilds)
    }
}

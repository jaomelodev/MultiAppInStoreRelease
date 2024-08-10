//
//  ListAllAppBuildsService.swift
//  JaoStoreReleases
//
//  Created by João Melo on 22/07/24.
//

import Foundation

protocol ListAllAppBuildsService {
    func listAllAppBuilds(appId: String) async -> Result<[AppBuildModel], ListAllAppBuildsError>
}

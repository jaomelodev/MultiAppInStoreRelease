//
//  ListAllAppBuildsService.swift
//  JaoStoreReleases
//
//  Created by João Melo on 22/07/24.
//

import Foundation

protocol ListAppBuildsService {
    func listAppBuilds(appId: String) async -> Result<[AppBuildModel], ListAppBuildsError>
}

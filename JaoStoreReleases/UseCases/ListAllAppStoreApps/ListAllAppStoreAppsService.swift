//
//  ListAllAppsService.swift
//  JaoStoreReleases
//
//  Created by João Melo on 17/07/24.
//

import Foundation

protocol ListAllAppStoreAppsService {
    func listAllAppStoreApps() async -> Result<[ListAppItemAppleModel], ListAllAppStoreAppsError>
}

//
//  ListAllAppsService.swift
//  JaoStoreReleases
//
//  Created by João Melo on 17/07/24.
//

import Foundation

protocol ListAllAppsAppleService {
    func listAllApps() async -> Result<[ListAppItemAppleModel], ListAllAppsAppleError>
}

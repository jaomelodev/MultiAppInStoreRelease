//
//  GetAppVersionFromAppService.swift
//  JaoStoreReleases
//
//  Created by João Melo on 10/08/24.
//

import Foundation

protocol GetAppAppVersionService {
    func getAppAppVersion(appId: String) async -> Result<AppStoreVersionModel, GetAppAppVersionError>
}

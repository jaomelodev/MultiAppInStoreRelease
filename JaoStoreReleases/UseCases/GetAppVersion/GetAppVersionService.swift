//
//  GetAppVersionService.swift
//  JaoStoreReleases
//
//  Created by João Melo on 10/08/24.
//

import Foundation

protocol GetAppVersionService {
    func getAppVersion(appVersionId: String) async -> Result<AppStoreVersionModel, GetAppVersionError>
}

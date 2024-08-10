//
//  GetAppVersionFromAppService.swift
//  JaoStoreReleases
//
//  Created by João Melo on 10/08/24.
//

import Foundation

protocol GetAppVersionFromAppService {
    func getAppVersionFromApp(appId: String) async -> Result<AppStoreVersionModel, GetAppVersionFromAppError>
}

//
//  GetAppVersionBuildService.swift
//  JaoStoreReleases
//
//  Created by João Melo on 09/08/24.
//

import Foundation

protocol GetAppVersionBuildService {
    func getAppVersionBuild(appVersionId: String) async -> Result<AppBuildModel, GetAppVersionBuildError>
}

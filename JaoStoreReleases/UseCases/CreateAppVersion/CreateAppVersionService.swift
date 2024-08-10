//
//  CreateAppReleaseService.swift
//  JaoStoreReleases
//
//  Created by João Melo on 30/07/24.
//

import Foundation

protocol CreateAppVersionService {
    func createAppVersion(params: CreateAppVersionParams) async -> Result<String, CreateAppVersionError>
}

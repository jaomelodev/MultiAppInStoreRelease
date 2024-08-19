//
//  AddBuildToAppReleaseService.swift
//  JaoStoreReleases
//
//  Created by João Melo on 31/07/24.
//

import Foundation

protocol AddBuildToAppVersionService {
    func addBuildToAppVersion(params: AddBuildToAppVersionParams) async -> Result<Void, AddBuildToAppVersionError>
}

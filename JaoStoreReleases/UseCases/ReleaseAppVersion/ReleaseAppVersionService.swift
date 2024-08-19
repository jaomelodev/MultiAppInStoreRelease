//
//  ReleaseAppVersionService.swift
//  JaoStoreReleases
//
//  Created by João Melo on 13/08/24.
//

import Foundation

protocol ReleaseAppVersionService {
    func releaseAppVersion(appVersionId: String) async -> Result<Void, ReleaseAppVersionError>
}

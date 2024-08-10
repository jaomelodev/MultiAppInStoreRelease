//
//  DeleteAppVersionService.swift
//  JaoStoreReleases
//
//  Created by João Melo on 08/08/24.
//

import Foundation

protocol DeleteAppVersionService {
    func deleteAppVersion(appVersionId: String) async -> Result<Void, DeleteAppVersionError>
}

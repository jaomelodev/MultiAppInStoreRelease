//
//  UpdateAppVersionService.swift
//  JaoStoreReleases
//
//  Created by João Melo on 08/08/24.
//

import Foundation

protocol UpdateAppVersionService {
    func updateAppVersion(params: UpdateAppVersionParams) async -> Result<Void, UpdateAppVersionError>
}

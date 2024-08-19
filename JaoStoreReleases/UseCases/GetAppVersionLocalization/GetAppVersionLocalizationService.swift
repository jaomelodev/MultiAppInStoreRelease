//
//  GetLocalizationFromReleaseService.swift
//  JaoStoreReleases
//
//  Created by João Melo on 01/08/24.
//

import Foundation

protocol GetAppVersionLocalizationService {
    func getLocalizationFromRelease(appVersionId: String) async -> Result<String, GetAppVersionLocalizationError>
}

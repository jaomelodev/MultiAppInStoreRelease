//
//  GetLocalizationFromReleaseService.swift
//  JaoStoreReleases
//
//  Created by João Melo on 01/08/24.
//

import Foundation

protocol GetLocalizationFromReleaseService {
    func getLocalizationFromRelease(releaseId: String) async -> Result<String, GetLocalizationFromReleaseError>
}

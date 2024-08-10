//
//  AddLocalizationToReleaseService.swift
//  JaoStoreReleases
//
//  Created by João Melo on 01/08/24.
//

import Foundation

protocol UpdateLocalizationService {
    func updateLocalization(params: UpdateLocalizationParams) async -> Result<Void, UpdateLocalizationError>
}

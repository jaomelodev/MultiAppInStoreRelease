//
//  AddBuildToAppReleaseService.swift
//  JaoStoreReleases
//
//  Created by João Melo on 31/07/24.
//

import Foundation

protocol AddBuildToReleaseService {
    func addBuildToRelease(params: AddBuildToReleaseParams) async -> Result<Void, AddBuildToReleaseError>
}

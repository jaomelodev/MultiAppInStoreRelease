//
//  CreateNewReleaseParams.swift
//  JaoStoreReleases
//
//  Created by João Melo on 02/08/24.
//

import Foundation

struct CreateNewReleaseParams {
    let appVersionId: String?
    let versionString: String
    let appId: String
    let whatsNew: String
    let buildId: String
    let usesNonExemptEncryption: Bool
    let updateLoadingState: (String) -> Void
}

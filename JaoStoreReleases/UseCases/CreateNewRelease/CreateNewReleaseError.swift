//
//  CreateNewReleaseError.swift
//  JaoStoreReleases
//
//  Created by João Melo on 02/08/24.
//

import Foundation

enum CreateNewReleaseError: Error {
    case failedToCreateAppVersion
    case failedToUpdateAppVersion
    case failedToAddBuildToRelease(appVersionId: String)
    case failedToAddComplianceToBuild(appVersionId: String, buildId: String)
    case failedToGetLocalization(appVersionId: String)
    case failedToUpdateLocalization(appVersionId: String, localizationId: String)
    case failedToSubmitRelease(appVersionId: String)
}

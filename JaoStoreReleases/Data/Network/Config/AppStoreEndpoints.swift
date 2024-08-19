//
//  AppEndpoints.swift
//  JaoStoreReleases
//
//  Created by João Melo on 14/07/24.
//

import Foundation

enum AppStoreEndpoints {
    case apps
    case appBuilds(appId: String)
    case appAppStoreVersions(appId: String)
    case createAppVersion
    case addBuildToAppVersion(appVersionId: String)
    case getLocalizationFromAppVersion(appVersionId: String)
    case updateLocalization(localizationId: String)
    case build(buildId: String)
    case appStoreVersionSubmissions
    case appVersions(appVersionId: String)
    case appVersionBuild(appVersionId: String)
    case releaseRequest
    
    func path() -> String {
        switch self {
        case .apps:
            return "/v1/apps"
        case .appBuilds(let appId):
            return "/v1/apps/\(appId)/builds"
        case .appAppStoreVersions(let appId):
            return "/v1/apps/\(appId)/appStoreVersions"
        case .createAppVersion:
            return "/v1/appStoreVersions"
        case .addBuildToAppVersion(let appVersionId):
            return "/v1/appStoreVersions/\(appVersionId)/relationships/build"
        case .getLocalizationFromAppVersion(let appVersionId):
            return "/v1/appStoreVersions/\(appVersionId)/appStoreVersionLocalizations"
        case .updateLocalization(let localizationId):
            return "/v1/appStoreVersionLocalizations/\(localizationId)"
        case .build(let buildId):
            return "/v1/builds/\(buildId)"
        case .appStoreVersionSubmissions:
            return "/v1/appStoreVersionSubmissions"
        case .appVersions(let appVersionId):
            return "/v1/appStoreVersions/\(appVersionId)"
        case .appVersionBuild(let appVersionId):
            return "/v1/appStoreVersions/\(appVersionId)/build"
        case .releaseRequest:
            return "/v1/appStoreVersionReleaseRequests"
        }
    }
}

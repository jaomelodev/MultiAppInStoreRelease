//
//  AppStoreServiceImpl.swift
//  JaoStoreReleases
//
//  Created by João Melo on 16/07/24.
//

import Foundation

class AppStoreServiceImpl: ListAllAppsAppleService, ListAllAppBuildsService, CreateAppVersionService, AddBuildToReleaseService, GetLocalizationFromReleaseService, UpdateLocalizationService, AcceptComplianceService, SubmitToReviewService, DeleteAppVersionService, UpdateAppVersionService, GetAppVersionBuildService, GetAppVersionService, GetAppVersionFromAppService {
    
    let appStoreClient: AppStoreHTTPClient
    
    init(appStoreClient: AppStoreHTTPClient) {
        self.appStoreClient = appStoreClient
    }
    
    func listAllApps() async -> Result<[ListAppItemAppleModel], ListAllAppsAppleError> {
        let queryParams: [String:String] = [
            "include": "builds,appStoreVersions",
            "fields[apps]": "bundleId,name,builds,appStoreVersions",
            "fields[builds]": "iconAssetToken",
            "fields[appStoreVersions]": "versionString,platform,appStoreState",
            "filter[appStoreVersions.platform]": "IOS",
            "limit[builds]": "1",
            "limit[appStoreVersions]": "1"
        ]
        
        let response = await appStoreClient.request(endpoint: .apps, method: .get, queryParams: queryParams)
        
        if case .failure(_) = response {
            return .failure(.appsNotFound)
        }
        
        guard let json = try? response.get() else {
            return .failure(.cannotConvert)
        }
        
        guard let dataArray = json["data"] as? [[String: Any]] else {
            return .failure(.cannotConvert)
        }
        
        let includedDataArray = json["included"] as? [[String: Any]] ?? []
        
        var appBuildsDict: [String: Any] = [:]
        
        for includedData in includedDataArray {
            guard let buildId = includedData["id"] as? String else {
                continue
            }
            
            appBuildsDict[buildId] = includedData
        }
        
        var apps: [ListAppItemAppleModel] = []
        
        for item in dataArray {
            guard let app = ListAppItemAppleModel(dictionary: item, includedDataDic: appBuildsDict) else {
                continue
            }
            
            apps.append(app);
        }
        
        return .success(apps)
    }
    
    func listAllAppBuilds(appId: String) async -> Result<[AppBuildModel], ListAllAppBuildsError> {
        let queryParams: [String : String] = [
            "fields[builds]": "version,uploadedDate,iconAssetToken,processingState",
            "limit": "5",
        ]
        
        let response = await appStoreClient.request(endpoint: .appBuilds(appId: appId), method: .get, queryParams: queryParams)
        
        if case .failure(let error) = response {
            if case .canceled(_) = error {
                return .failure(.canceled)
            }
            
            return .failure(.buildsNotFound)
        }
        
        guard let json = try? response.get() else {
            return .failure(.cannotConvert)
        }
        
        guard let dataArray = json["data"] as? [[String: Any]] else {
            return .failure(.cannotConvert)
        }
        
        var builds: [AppBuildModel] = []
        
        for item in dataArray {
            guard let build = AppBuildModel(dictionary: item) else {
                continue
            }
            
            builds.append(build);
        }
        
        return .success(builds)
    }
    
    func createAppVersion(params: CreateAppVersionParams) async -> Result<String, CreateAppVersionError> {
        let body = [
            "data": [
                "type": "appStoreVersions",
                "attributes": [
                    "versionString": params.versionString,
                    "releaseType": "MANUAL",
                    "platform": "IOS"
                ],
                "relationships": [
                    "app": [
                        "data": [
                            "type": "apps",
                            "id": params.appId
                        ]
                    ]
                ]
            ]
        ]
        
        let response = await appStoreClient.request(
            endpoint: .createAppVersion,
            method: .post,
            body: body
        )
        
        if case .failure(_) = response {
            return .failure(.cannotCreate)
        }
        
        guard let json = try? response.get() else {
            return .failure(.cannotConvert)
        }
        
        if let jsonData = json["data"] as? [String: Any],
           let appVersionId = jsonData["id"] as? String {
            return .success(appVersionId)
        } else {
            return .failure(.cannotConvert)
        }
    }
    
    func addBuildToRelease(params: AddBuildToReleaseParams) async -> Result<Void, AddBuildToReleaseError> {
        let body = [
            "data": [
                "type": "builds",
                "id": params.buildId
            ]
        ]
        
        let response = await appStoreClient.request(
            endpoint: .addBuildToAppVersion(appVersionId: params.appReleaseId),
            method: .patch,
            body: body
        )
        
        if case .failure(_) = response {
            return .failure(.failedToAddBuild)
        }
        
        return .success(())
    }
    
    /// Get the localization id from a release in app store
    /// - Parameter releaseId: The ID of the release
    ///
    /// > important: Although the release has many localizations for different languages, for now, we only return the first one.
    ///
    /// - Returns: The first localization id from the release
    func getLocalizationFromRelease(releaseId: String) async -> Result<String, GetLocalizationFromReleaseError> {
        let response = await appStoreClient.request(
            endpoint: .getLocalizationFromAppVersion(appVersionId: releaseId),
            method: .get
        )
        
        if case .failure(_) = response {
            return .failure(.notFound)
        }
        
        guard let json = try? response.get() else {
            return .failure(.cannotConvert)
        }
        
        if let data = json["data"] as? [[String: Any]],
           let localizationId = data.first?["id"] as? String {
            return .success(localizationId)
        } else {
            return .failure(.cannotConvert)
        }
    }
    
    /// Add the description of whatsNew in the localization
    /// - Parameter params: It's a ``UpdateLocalizationParams`` struct containing the localizationId and the whatsNew description
    /// - Returns: a result with void to indicate success, or ``UpdateLocalizationError`` if something goes wrong with the request
    func updateLocalization(params: UpdateLocalizationParams) async -> Result<Void, UpdateLocalizationError> {
        let body = [
            "data": [
                "type": "appStoreVersionLocalizations",
                "id": params.localizationId,
                "attributes": [
                    "whatsNew": params.whatsNew
                ]
            ]
        ]
        
        let response = await appStoreClient.request(
            endpoint: .updateLocalization(localizationId: params.localizationId),
            method: .patch,
            body: body
        )
        
        if case .failure(_) = response {
            return .failure(.failedToUpdate)
        }
        
        return .success(())
    }
    
    func acceptCompliance(params: AcceptComplianceParams) async -> Result<Void, AcceptComplianceError> {
        let body = [
            "data": [
                "type": "builds",
                "id": params.buildId,
                "attributes": [
                    "usesNonExemptEncryption": params.usesNonExemptEncryption
                ]
            ]
        ]
        
        let response = await appStoreClient.request(
            endpoint: .build(buildId: params.buildId),
            method: .patch,
            body: body
        )
        
        if case .failure(let failure) = response {
            if case .requestError(let json, _, _) = failure {
                let errors = json["errors"] as? [[String: Any]]
                
                let errorMessage = errors?.first?["detail"] as? String
                
                if errorMessage != "You cannot update when the value is already set." {
                    return .failure(.failedToAcceptCompliance)
                }
            } else {
                return .failure(.failedToAcceptCompliance)
            }
        }
        
        return .success(())
    }
    
    func submitToReview(releaseId: String) async -> Result<Void, SubmitToReviewError> {
        let body = [
            "data": [
                "type": "appStoreVersionSubmissions",
                "relationships": [
                    "appStoreVersion": [
                        "data": [
                            "type": "appStoreVersions",
                            "id": releaseId
                        ]
                    ]
                ]
            ]
        ]
        
        let response = await appStoreClient.request(
            endpoint: .appStoreVersionSubmissions,
            method: .post,
            body: body
        )
        
        if case .failure(_) = response {
            return .failure(.failedToSubmitVersion)
        }
        
        return .success(())
    }
    
    func deleteAppVersion(appVersionId: String) async -> Result<Void, DeleteAppVersionError> {
        let response = await appStoreClient.request(
            endpoint: .appVersions(appVersionId: appVersionId),
            method: .delete
        )
        
        if case .failure(_) = response {
            return .failure(.cannotDelete)
        }
        
        return .success(())
    }
    
    func updateAppVersion(params: UpdateAppVersionParams) async -> Result<Void, UpdateAppVersionError> {
        let body = [
            "data": [
                "id": params.appVersionId,
                "type": "appStoreVersions",
                "attributes": [
                    "versionString": params.versionString,
                ],
            ]
        ]
        
        let response = await appStoreClient.request(
            endpoint: .appVersions(appVersionId: params.appVersionId),
            method: .patch,
            body: body
        )
        
        if case .failure(_) = response {
            return .failure(.cannotUpdate)
        }
        
        return .success(())
    }
    
    func getAppVersionBuild(appVersionId: String) async -> Result<AppBuildModel, GetAppVersionBuildError> {
        let response = await appStoreClient.request(
            endpoint: .appVersionBuild(appVersionId: appVersionId),
            method: .get
        )
        
        if case .failure(_) = response {
            return .failure(.failedToGetBuild)
        }
        
        guard let json = try? response.get(),
              let dataDic = json["data"] as? [String: Any],
              let appBuild = AppBuildModel(dictionary: dataDic) else {
            return .failure(.cannotConvert)
        }
        
        return .success(appBuild)
    }
    
    func getAppVersion(appVersionId: String) async -> Result<AppStoreVersionModel, GetAppVersionError> {
        let response = await appStoreClient.request(
            endpoint: .appVersions(appVersionId: appVersionId),
            method: .get
        )
        
        if case .failure(_) = response {
            return .failure(.cannotGetAppVersion)
        }
        
        guard let json = try? response.get(), let dataDic = json["data"] as? [String: Any],
              let appVersion = AppStoreVersionModel(dictionary: json) else {
            return .failure(.cannotConvert)
        }
        
        return .success(appVersion)
    }
    
    func getAppVersionFromApp(appId: String) async -> Result<AppStoreVersionModel, GetAppVersionFromAppError> {
        let queryParams: [String:String] = [
            "fields[appStoreVersions]": "appStoreState,versionString,platform",
            "filter[platform]": "IOS",
            "limit": "1"
        ]
        
        let response = await appStoreClient.request(
            endpoint: .appAppStoreVersions(appId: appId),
            method: .get,
            queryParams: queryParams
        )
        
        if case .failure(_) = response {
            return .failure(.cannotGetAppVersionFromApp)
        }
        
        guard let json = try? response.get(),
              let dataList = json["data"] as? [[String: Any]],
              let appVersionData = dataList.first,
              let appVersion = AppStoreVersionModel(dictionary: appVersionData) else {
            return .failure(.cannotConvert)
        }
        
        return .success(appVersion)

    }
}

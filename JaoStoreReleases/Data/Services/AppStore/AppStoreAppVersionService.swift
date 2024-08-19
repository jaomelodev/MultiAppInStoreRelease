//
//  AppStoreAppVersionService.swift
//  JaoStoreReleases
//
//  Created by João Melo on 13/08/24.
//

import Foundation

class AppStoreAppVersionService: CreateAppVersionService, DeleteAppVersionService, UpdateAppVersionService, GetAppVersionService, GetAppAppVersionService, ReleaseAppVersionService {
    let appStoreClient: AppStoreHTTPClient
    
    init(appStoreClient: AppStoreHTTPClient) {
        self.appStoreClient = appStoreClient
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
    
    func getAppVersion(appVersionId: String) async -> Result<AppStoreVersionModel, GetAppVersionError> {
        let response = await appStoreClient.request(
            endpoint: .appVersions(appVersionId: appVersionId),
            method: .get
        )
        
        if case .failure(_) = response {
            return .failure(.cannotGetAppVersion)
        }
        
        guard let json = try? response.get(),
              let appVersion = AppStoreVersionModel(dictionary: json) else {
            return .failure(.cannotConvert)
        }
        
        return .success(appVersion)
    }
    
    func getAppAppVersion(appId: String) async -> Result<AppStoreVersionModel, GetAppAppVersionError> {
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
            return .failure(.cannotGetAppVersion)
        }
        
        guard let json = try? response.get(),
              let dataList = json["data"] as? [[String: Any]],
              let appVersionData = dataList.first,
              let appVersion = AppStoreVersionModel(dictionary: appVersionData) else {
            return .failure(.cannotConvert)
        }
        
        return .success(appVersion)
        
    }
    
    func releaseAppVersion(appVersionId: String) async -> Result<Void, ReleaseAppVersionError> {
        let body = [
            "data": [
                "type": "appStoreVersionReleaseRequests",
                "relationships": [
                    "appStoreVersion": [
                        "data": [
                            "type": "appStoreVersions",
                            "id": appVersionId,
                        ]
                    ]
                ]
            ]
        ]
        
        let response = await appStoreClient.request(
            endpoint: .releaseRequest,
            method: .post,
            body: body
        )
        
        if case .failure(_) = response {
            return .failure(.failedToReleaseVersion)
        }
        
        return .success(())
    }
}

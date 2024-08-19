//
//  AppStoreAppsService.swift
//  JaoStoreReleases
//
//  Created by João Melo on 13/08/24.
//

import Foundation

class AppStoreAppsService: ListAllAppStoreAppsService {
    let appStoreClient: AppStoreHTTPClient
    
    init(appStoreClient: AppStoreHTTPClient) {
        self.appStoreClient = appStoreClient
    }
    
    func listAllAppStoreApps() async -> Result<[ListAppItemAppleModel], ListAllAppStoreAppsError> {
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
}

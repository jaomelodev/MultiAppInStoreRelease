//
//  AppStoreBuildsService.swift
//  JaoStoreReleases
//
//  Created by João Melo on 13/08/24.
//

import Foundation

class AppStoreBuildsService: ListAppBuildsService, AcceptBuildComplianceService, GetAppVersionBuildService, AddBuildToAppVersionService {
    let appStoreClient: AppStoreHTTPClient
    
    init(appStoreClient: AppStoreHTTPClient) {
        self.appStoreClient = appStoreClient
    }
    
    func listAppBuilds(appId: String) async -> Result<[AppBuildModel], ListAppBuildsError> {
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
    
    func acceptBuildCompliance(params: AcceptBuildComplianceParams) async -> Result<Void, AcceptBuildComplianceError> {
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
    
    func addBuildToAppVersion(params: AddBuildToAppVersionParams) async -> Result<Void, AddBuildToAppVersionError> {
        let body = [
            "data": [
                "type": "builds",
                "id": params.buildId
            ]
        ]
        
        let response = await appStoreClient.request(
            endpoint: .addBuildToAppVersion(appVersionId: params.appVersionId),
            method: .patch,
            body: body
        )
        
        if case .failure(_) = response {
            return .failure(.failedToAddBuild)
        }
        
        return .success(())
    }
}

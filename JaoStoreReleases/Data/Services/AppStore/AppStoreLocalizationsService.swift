//
//  AppStoreLocalizationsService.swift
//  JaoStoreReleases
//
//  Created by João Melo on 13/08/24.
//

import Foundation

class AppStoreLocalizationsService: GetAppVersionLocalizationService, UpdateLocalizationService {
    
    let appStoreClient: AppStoreHTTPClient
    
    init(appStoreClient: AppStoreHTTPClient) {
        self.appStoreClient = appStoreClient
    }
    
    /// Get the localization id from a release in app store
    /// - Parameter releaseId: The ID of the release
    ///
    /// > important: Although the release has many localizations for different languages, for now, we only return the first one.
    ///
    /// - Returns: The first localization id from the release
    func getLocalizationFromRelease(appVersionId: String) async -> Result<String, GetAppVersionLocalizationError> {
        let response = await appStoreClient.request(
            endpoint: .getLocalizationFromAppVersion(appVersionId: appVersionId),
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
}

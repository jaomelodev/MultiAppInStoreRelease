//
//  AppStoreReviewService.swift
//  JaoStoreReleases
//
//  Created by João Melo on 13/08/24.
//

import Foundation

class AppStoreReviewService: SubmitAppVersionToReviewService {
    let appStoreClient: AppStoreHTTPClient
    
    init(appStoreClient: AppStoreHTTPClient) {
        self.appStoreClient = appStoreClient
    }
    
    func submitAppVersionToReview(appVersionId: String) async -> Result<Void, SubmitAppVersionToReviewError> {
        let body = [
            "data": [
                "type": "appStoreVersionSubmissions",
                "relationships": [
                    "appStoreVersion": [
                        "data": [
                            "type": "appStoreVersions",
                            "id": appVersionId
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
            return .failure(.failedToSubmitAppVersion)
        }
        
        return .success(())
    }
}

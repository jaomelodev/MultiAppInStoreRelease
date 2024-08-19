//
//  SubmitToReviewService.swift
//  JaoStoreReleases
//
//  Created by João Melo on 02/08/24.
//

import Foundation

protocol SubmitAppVersionToReviewService {
    func submitAppVersionToReview(appVersionId: String) async -> Result<Void, SubmitAppVersionToReviewError>
}

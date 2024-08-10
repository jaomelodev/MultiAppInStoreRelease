//
//  SubmitToReviewService.swift
//  JaoStoreReleases
//
//  Created by João Melo on 02/08/24.
//

import Foundation

protocol SubmitToReviewService {
    func submitToReview(releaseId: String) async -> Result<Void, SubmitToReviewError>
}

//
//  SubmitToReviewUseCase.swift
//  JaoStoreReleases
//
//  Created by João Melo on 02/08/24.
//

import Foundation

class SubmitAppVersionToReviewUseCase: UseCase<String, Void, SubmitAppVersionToReviewError> {}

class SubmitAppVersionToReviewUseCaseImpl: SubmitAppVersionToReviewUseCase {
    let submitAppVersionToReviewService: SubmitAppVersionToReviewService
    
    init(submitAppVersionToReviewService: SubmitAppVersionToReviewService) {
        self.submitAppVersionToReviewService = submitAppVersionToReviewService
    }
    
    override func execute(_ params: String) async -> Result<Void, SubmitAppVersionToReviewError> {
        return await submitAppVersionToReviewService.submitAppVersionToReview(appVersionId: params)
    }
}

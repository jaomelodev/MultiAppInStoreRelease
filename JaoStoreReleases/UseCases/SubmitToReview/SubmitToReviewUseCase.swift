//
//  SubmitToReviewUseCase.swift
//  JaoStoreReleases
//
//  Created by João Melo on 02/08/24.
//

import Foundation

class SubmitToReviewUseCase: UseCase<String, Void, SubmitToReviewError> {}

class SubmitToReviewUseCaseImpl: SubmitToReviewUseCase {
    let submitToReviewService: SubmitToReviewService
    
    init(submitToReviewService: SubmitToReviewService) {
        self.submitToReviewService = submitToReviewService
    }
    
    override func execute(_ params: String) async -> Result<Void, SubmitToReviewError> {
        return await submitToReviewService.submitToReview(releaseId: params)
    }
}

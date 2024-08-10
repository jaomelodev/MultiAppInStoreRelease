//
//  AcceptComplianceUseCase.swift
//  JaoStoreReleases
//
//  Created by João Melo on 02/08/24.
//

import Foundation

class AcceptComplianceUseCase: UseCase<AcceptComplianceParams, Void, AcceptComplianceError> {}

class AcceptComplianceUseCaseImpl: AcceptComplianceUseCase {
    let acceptComplianceService: AcceptComplianceService
    
    init(acceptComplianceService: AcceptComplianceService) {
        self.acceptComplianceService = acceptComplianceService
    }
    
    override func execute(_ params: AcceptComplianceParams) async -> Result<Void, AcceptComplianceError> {
        return await acceptComplianceService.acceptCompliance(params: params)
    }
}

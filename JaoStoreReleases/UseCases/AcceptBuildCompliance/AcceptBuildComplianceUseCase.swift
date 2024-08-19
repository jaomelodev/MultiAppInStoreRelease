//
//  AcceptComplianceUseCase.swift
//  JaoStoreReleases
//
//  Created by João Melo on 02/08/24.
//

import Foundation

class AcceptBuildComplianceUseCase: UseCase<AcceptBuildComplianceParams, Void, AcceptBuildComplianceError> {}

class AcceptBuildComplianceUseCaseImpl: AcceptBuildComplianceUseCase {
    let acceptBuildComplianceService: AcceptBuildComplianceService
    
    init(acceptBuildComplianceService: AcceptBuildComplianceService) {
        self.acceptBuildComplianceService = acceptBuildComplianceService
    }
    
    override func execute(_ params: AcceptBuildComplianceParams) async -> Result<Void, AcceptBuildComplianceError> {
        return await acceptBuildComplianceService.acceptBuildCompliance(params: params)
    }
}

//
//  AcceptComplianceService.swift
//  JaoStoreReleases
//
//  Created by João Melo on 02/08/24.
//

import Foundation

protocol AcceptBuildComplianceService {
    func acceptBuildCompliance(params: AcceptBuildComplianceParams) async -> Result<Void, AcceptBuildComplianceError>
}

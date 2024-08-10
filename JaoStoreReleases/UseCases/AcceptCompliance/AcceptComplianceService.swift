//
//  AcceptComplianceService.swift
//  JaoStoreReleases
//
//  Created by João Melo on 02/08/24.
//

import Foundation

protocol AcceptComplianceService {
    func acceptCompliance(params: AcceptComplianceParams) async -> Result<Void, AcceptComplianceError>
}

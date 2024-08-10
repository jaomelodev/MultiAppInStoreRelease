//
//  DeleteAppVersionUseCase.swift
//  JaoStoreReleases
//
//  Created by João Melo on 08/08/24.
//

import Foundation

class DeleteAppVersionUseCase: UseCase<String, Void, DeleteAppVersionError> {}

class DeleteAppVersionUseCaseImpl: DeleteAppVersionUseCase {
    let deleteAppVersionService: DeleteAppVersionService
    
    init(deleteAppVersionService: DeleteAppVersionService) {
        self.deleteAppVersionService = deleteAppVersionService
    }
    
    override func execute(_ params: String) async -> Result<Void, DeleteAppVersionError> {
        return await deleteAppVersionService.deleteAppVersion(appVersionId: params)
    }
}

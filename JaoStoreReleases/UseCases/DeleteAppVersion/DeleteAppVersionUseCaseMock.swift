//
//  DeleteAppVersionUseCaseMock.swift
//  JaoStoreReleases
//
//  Created by João Melo on 08/08/24.
//

#if DEBUG
import Foundation

class DeleteAppVersionUseCaseMock: DeleteAppVersionUseCase {
    let result: Result<Void, DeleteAppVersionError>
    
    init(result: Result<Void, DeleteAppVersionError> = .success(())) {
        self.result = result
    }
    
    override func execute(_ params: String) async -> Result<Void, DeleteAppVersionError> {
        return result
    }
}
#endif

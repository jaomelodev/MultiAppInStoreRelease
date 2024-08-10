//
//  CreateNewReleaseUseCaseMock.swift
//  JaoStoreReleases
//
//  Created by João Melo on 07/08/24.
//

#if DEBUG
import Foundation

class CreateNewReleaseUseCaseMock: CreateNewReleaseUseCase {
    let result: Result<Void, CreateNewReleaseError>
    
    init(result: Result<Void, CreateNewReleaseError> = .success(())) {
        self.result = result
    }
    
    override func execute(_ params: CreateNewReleaseParams) async -> Result<Void, CreateNewReleaseError> {
        return result
    }
}
#endif

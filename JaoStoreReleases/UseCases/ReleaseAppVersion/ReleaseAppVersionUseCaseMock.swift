//
//  ReleaseAppVersionUseCaseMock.swift
//  JaoStoreReleases
//
//  Created by João Melo on 13/08/24.
//

#if DEBUG
import Foundation

class ReleaseAppVersionUseCaseMock: ReleaseAppVersionUseCase {
    let result: Result<Void, ReleaseAppVersionError>
    
    init(result: Result<Void, ReleaseAppVersionError> = .success(())) {
        self.result = result
    }
    
    override func execute(_ params: String) async -> Result<Void, ReleaseAppVersionError> {
        return result
    }
}

#endif

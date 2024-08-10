//
//  UseCase.swift
//  JaoStoreReleases
//
//  Created by João Melo on 13/07/24.
//

import Foundation

struct NoParams {}

class UseCase<ParamsUseCase, ResultUseCase, ErrorUseCase> where ErrorUseCase: Error {
    func execute(_ params: ParamsUseCase) async -> Result<ResultUseCase, ErrorUseCase> {
        fatalError("should implement execute")
    }
}

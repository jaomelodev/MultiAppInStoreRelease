//
//  UseCase.swift
//  JaoStoreReleases
//
//  Created by João Melo on 13/07/24.
//

import Foundation

struct NoParams {}

protocol UseCase<ResultUseCase, ParamsUseCase> {
    associatedtype ResultUseCase
    associatedtype ParamsUseCase
    
    func execute(_ params: ParamsUseCase) async throws -> ResultUseCase
}

//
//  ListAllAppsAppleUseCaseMock.swift
//  JaoStoreReleases
//
//  Created by João Melo on 03/08/24.
//

#if DEBUG
class ListAllAppsAppleUseCaseMock: ListAllAppsAppleUseCase {
    override func execute(_ params: NoParams) async -> Result<[ListAppItemEntity], ListAllAppsAppleError> {
        return .success([])
    }
}
#endif

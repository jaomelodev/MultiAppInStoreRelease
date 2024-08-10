//
//  AppDetailsViewInjector.swift
//  JaoStoreReleases
//
//  Created by João Melo on 06/08/24.
//

import Foundation
import SwiftUI

class AppDetailsViewInjector: InjectorTest<AppDetailsController> {
    let appItem: ListAppItemEntity
    let updateItemOnAppList: (ListAppItemEntity) -> Void
    
    init(
        appItem: ListAppItemEntity,
        updateItemOnAppList: @escaping (ListAppItemEntity) -> Void
    ) {
        self.appItem = appItem
        self.updateItemOnAppList = updateItemOnAppList
    }
    
    override func registerDependencies() -> AppDetailsController {
        let client = AppStoreHTTPClient()
        
        let appStoreService = AppStoreServiceImpl(appStoreClient: client)
        
        let listAllAppBuildsUseCase = ListAllAppBuildsUseCaseImpl(listAllAppBuildsService: appStoreService)
        let getAppVersionBuildUseCase = GetAppVersionBuildUseCaseImpl(getAppVersionBuildService: appStoreService)
        let listAvailableAppBuildsUseCase = ListAvailableAppBuildsUseCaseImpl(
            listAllAppBuildsUseCase: listAllAppBuildsUseCase,
            getAppVersionBuildUseCase: getAppVersionBuildUseCase
        )

        let createAppVersionUseCase = CreateAppVersionUseCaseImpl(createAppVersionService: appStoreService)
        let updateAppVersionUseCase = UpdateAppVersionUseCaseImpl(updateAppVersionService: appStoreService)
        let addBuildToReleaseUseCase = AddBuildToReleaseUseCaseImpl(addBuildToReleaseService: appStoreService)
        let getLocalizationFromReleaseUseCase = GetLocalizationFromReleaseUseCaseImpl(getLocalizationFromReleaseService: appStoreService)
        let updateLocalizationUseCase = UpdateLocalizationUseCaseImpl(addLocalizationToReleaseService: appStoreService)
        let acceptComplianceUseCase = AcceptComplianceUseCaseImpl(acceptComplianceService: appStoreService)
        let submitToReviewUseCase = SubmitToReviewUseCaseImpl(submitToReviewService: appStoreService)

        let createNewReleaseUseCase = CreateNewReleaseUseCaseImpl(
            createAppReleaseUseCase: createAppVersionUseCase,
            updateAppVersionUseCase: updateAppVersionUseCase,
            addBuildToReleaseUseCase: addBuildToReleaseUseCase,
            getLocalizationFromReleaseUseCase: getLocalizationFromReleaseUseCase,
            updateLocalizationUseCase: updateLocalizationUseCase,
            acceptComplianceUseCase: acceptComplianceUseCase,
            submitToReviewUseCase: submitToReviewUseCase
        )

        let getAppVersionFromAppUseCase = GetAppVersionFromAppUseCaseImpl(getAppVersionFromAppService: appStoreService)

        // Manually instantiate the controller
        let appDetailsController = AppDetailsController(
            appItem: self.appItem,
            listAvailableAppBuildsUseCase: listAvailableAppBuildsUseCase,
            createNewReleaseUseCase: createNewReleaseUseCase,
            getAppVersionFromAppUseCase: getAppVersionFromAppUseCase,
            updateItemOnAppList: self.updateItemOnAppList
        )
        
        return appDetailsController
    }
}

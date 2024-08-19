//
//  AppDetailsViewInjector.swift
//  JaoStoreReleases
//
//  Created by João Melo on 06/08/24.
//

import Foundation
import SwiftUI

class AppDetailsViewInjector: Injector<AppDetailsController> {
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
        
        let appStoreBuildsService = AppStoreBuildsService(appStoreClient: client)
        let appStoreLocalizationService = AppStoreLocalizationsService(appStoreClient: client)
        let appStoreReviewService = AppStoreReviewService(appStoreClient: client)
        let appStoreAppVersionService = AppStoreAppVersionService(appStoreClient: client)
        
        let listAllAppBuildsUseCase = ListAppBuildsUseCaseImpl(listAppBuildsService: appStoreBuildsService)
        let getAppVersionBuildUseCase = GetAppVersionBuildUseCaseImpl(getAppVersionBuildService: appStoreBuildsService)
        let listAvailableAppBuildsUseCase = ListAvailableAppBuildsUseCaseImpl(
            listAllAppBuildsUseCase: listAllAppBuildsUseCase,
            getAppVersionBuildUseCase: getAppVersionBuildUseCase
        )

        let createAppVersionUseCase = CreateAppVersionUseCaseImpl(createAppVersionService: appStoreAppVersionService)
        let updateAppVersionUseCase = UpdateAppVersionUseCaseImpl(updateAppVersionService: appStoreAppVersionService)
        let addBuildToReleaseUseCase = AddBuildToAppVersionUseCaseImpl(addBuildToAppVersionService: appStoreBuildsService)
        let getLocalizationFromReleaseUseCase = GetAppVersionLocalizationUseCaseImpl(getAppVersionLocalizationService: appStoreLocalizationService)
        let updateLocalizationUseCase = UpdateLocalizationUseCaseImpl(addLocalizationToReleaseService: appStoreLocalizationService)
        let acceptComplianceUseCase = AcceptBuildComplianceUseCaseImpl(acceptBuildComplianceService: appStoreBuildsService)
        let submitToReviewUseCase = SubmitAppVersionToReviewUseCaseImpl(submitAppVersionToReviewService: appStoreReviewService)

        let createNewReleaseUseCase = CreateNewReleaseUseCaseImpl(
            createAppReleaseUseCase: createAppVersionUseCase,
            updateAppVersionUseCase: updateAppVersionUseCase,
            addBuildToReleaseUseCase: addBuildToReleaseUseCase,
            getLocalizationFromReleaseUseCase: getLocalizationFromReleaseUseCase,
            updateLocalizationUseCase: updateLocalizationUseCase,
            acceptComplianceUseCase: acceptComplianceUseCase,
            submitToReviewUseCase: submitToReviewUseCase
        )

        let getAppVersionFromAppUseCase = GetAppAppVersionUseCaseImpl(getAppAppVersionService: appStoreAppVersionService)
        
        let releaseAppVersionUseCase = ReleaseAppVersionUseCaseImpl(releaseAppVersionService: appStoreAppVersionService)

        // Manually instantiate the controller
        let appDetailsController = AppDetailsController(
            appItem: self.appItem,
            listAvailableAppBuildsUseCase: listAvailableAppBuildsUseCase,
            createNewReleaseUseCase: createNewReleaseUseCase,
            getAppVersionFromAppUseCase: getAppVersionFromAppUseCase,
            releaseAppVersionUseCase: releaseAppVersionUseCase,
            updateItemOnAppList: self.updateItemOnAppList
        )
        
        return appDetailsController
    }
}

//
//  CreateNewReleaseUseCase.swift
//  JaoStoreReleases
//
//  Created by João Melo on 02/08/24.
//

import Foundation

class CreateNewReleaseUseCase: UseCase<CreateNewReleaseParams, Void, CreateNewReleaseError> {}

class CreateNewReleaseUseCaseImpl: CreateNewReleaseUseCase {
    let createAppVersionUseCase: CreateAppVersionUseCase
    let updateAppVersionUseCase: UpdateAppVersionUseCase
    let addBuildToReleaseUseCase: AddBuildToAppVersionUseCase
    let getLocalizationFromReleaseUseCase: GetAppVersionLocalizationUseCase
    let updateLocalizationUseCase: UpdateLocalizationUseCase
    let acceptComplianceUseCase: AcceptBuildComplianceUseCase
    let submitToReviewUseCase: SubmitAppVersionToReviewUseCase
    
    init(
        createAppReleaseUseCase: CreateAppVersionUseCase,
        updateAppVersionUseCase: UpdateAppVersionUseCase,
        addBuildToReleaseUseCase: AddBuildToAppVersionUseCase,
        getLocalizationFromReleaseUseCase: GetAppVersionLocalizationUseCase,
        updateLocalizationUseCase: UpdateLocalizationUseCase,
        acceptComplianceUseCase: AcceptBuildComplianceUseCase,
        submitToReviewUseCase: SubmitAppVersionToReviewUseCase
    ) {
        self.createAppVersionUseCase = createAppReleaseUseCase
        self.updateAppVersionUseCase = updateAppVersionUseCase
        self.addBuildToReleaseUseCase = addBuildToReleaseUseCase
        self.getLocalizationFromReleaseUseCase = getLocalizationFromReleaseUseCase
        self.updateLocalizationUseCase = updateLocalizationUseCase
        self.acceptComplianceUseCase = acceptComplianceUseCase
        self.submitToReviewUseCase = submitToReviewUseCase
    }
    
    override func execute(_ params: CreateNewReleaseParams) async -> Result<Void, CreateNewReleaseError> {
        let appVersionId: String
        
        if let appVersionIdUpdate = params.appVersionId {
            let updateAppVersionResponse = await updateAppVersionUseCase.execute(
                UpdateAppVersionParams(
                    appVersionId: appVersionIdUpdate,
                    versionString: params.versionString
                )
            )
            
            if case .failure(_) = updateAppVersionResponse {
                return .failure(.failedToUpdateAppVersion)
            }
            
            appVersionId = appVersionIdUpdate
        } else {
            params.updateLoadingState("Updating current version...")
            
            let createReleaseResponse = await createAppVersionUseCase.execute(
                CreateAppVersionParams(
                    versionString: params.versionString,
                    appId: params.appId
                )
            )
            
            guard let createdAppVersionId = try? createReleaseResponse.get() else {
                return .failure(.failedToCreateAppVersion)
            }
            
            appVersionId = createdAppVersionId
        }
        
        params.updateLoadingState("Adding build and what's new...")
        
        // Use TaskGroup to run tasks in parallel
        let parallelResult = await withTaskGroup(of: Result<Void, CreateNewReleaseError>.self, returning: Result<Void, CreateNewReleaseError>.self) { group in
            // Adding build to release
            group.addTask {
                let addBuildToReleaseResponse = await self.addBuildToReleaseUseCase.execute(
                    AddBuildToAppVersionParams(appVersionId: appVersionId, buildId: params.buildId)
                )
                
                if case .failure(_) = addBuildToReleaseResponse {
                    return .failure(.failedToAddBuildToRelease(appVersionId: appVersionId))
                }
                
                let acceptComplianceResponse = await self.acceptComplianceUseCase.execute(
                    AcceptBuildComplianceParams(
                        buildId: params.buildId,
                        usesNonExemptEncryption: params.usesNonExemptEncryption
                    )
                )
                
                if case .failure(_) = acceptComplianceResponse {
                    return .failure(.failedToAddComplianceToBuild(appVersionId: appVersionId, buildId: params.buildId))
                }
                
                return .success(())
            }
            
            // Get localization from release and update localization
            group.addTask {
                let getLocalizationFromReleaseResponse = await self.getLocalizationFromReleaseUseCase.execute(appVersionId)
                
                guard let localizationId = try? getLocalizationFromReleaseResponse.get() else {
                    return .failure(.failedToGetLocalization(appVersionId: appVersionId))
                }
                
                let updateLocalizationResponse = await self.updateLocalizationUseCase.execute(
                    UpdateLocalizationParams(
                        localizationId: localizationId,
                        whatsNew: params.whatsNew
                    )
                )
                
                if case .failure(_) = updateLocalizationResponse {
                    return .failure(.failedToUpdateLocalization(appVersionId: appVersionId, localizationId: localizationId))
                }
                
                return .success(())
            }
            
            for await result in group {
                if case .failure(let error) = result {
                    return .failure(error)
                }
            }
            
            return .success(())
        }
        
        if case .failure(let failure) = parallelResult {
            return .failure(failure)
        }
        
        params.updateLoadingState("Submitting to review...")
        
        let submitToReviewResponse = await submitToReviewUseCase.execute(appVersionId)
        
        if case .failure(_) = submitToReviewResponse {
            return .failure(.failedToSubmitRelease(appVersionId: appVersionId))
        }
        
        return .success(())
    }
}

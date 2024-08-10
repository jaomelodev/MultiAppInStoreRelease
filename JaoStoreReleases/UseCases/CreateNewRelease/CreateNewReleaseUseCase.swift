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
    let addBuildToReleaseUseCase: AddBuildToReleaseUseCase
    let getLocalizationFromReleaseUseCase: GetLocalizationFromReleaseUseCase
    let updateLocalizationUseCase: UpdateLocalizationUseCase
    let acceptComplianceUseCase: AcceptComplianceUseCase
    let submitToReviewUseCase: SubmitToReviewUseCase
    
    init(
        createAppReleaseUseCase: CreateAppVersionUseCase,
        updateAppVersionUseCase: UpdateAppVersionUseCase,
        addBuildToReleaseUseCase: AddBuildToReleaseUseCase,
        getLocalizationFromReleaseUseCase: GetLocalizationFromReleaseUseCase,
        updateLocalizationUseCase: UpdateLocalizationUseCase,
        acceptComplianceUseCase: AcceptComplianceUseCase,
        submitToReviewUseCase: SubmitToReviewUseCase
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
        
        // Use TaskGroup to run tasks in parallel
        let parallelResult = await withTaskGroup(of: Result<Void, CreateNewReleaseError>.self, returning: Result<Void, CreateNewReleaseError>.self) { group in
            // Adding build to release
            group.addTask {
                let addBuildToReleaseResponse = await self.addBuildToReleaseUseCase.execute(
                    AddBuildToReleaseParams(appReleaseId: appVersionId, buildId: params.buildId)
                )
                
                if case .failure(_) = addBuildToReleaseResponse {
                    return .failure(.failedToAddBuildToRelease(appVersionId: appVersionId))
                }
                
                let acceptComplianceResponse = await self.acceptComplianceUseCase.execute(
                    AcceptComplianceParams(
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
        
        let submitToReviewResponse = await submitToReviewUseCase.execute(appVersionId)
        
        if case .failure(_) = submitToReviewResponse {
            return .failure(.failedToSubmitRelease(appVersionId: appVersionId))
        }
        
        return .success(())
    }
}

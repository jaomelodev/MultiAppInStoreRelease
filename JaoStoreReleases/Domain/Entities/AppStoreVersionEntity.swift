//
//  AppStoreVersionEntity.swift
//  JaoStoreReleases
//
//  Created by João Melo on 21/07/24.
//

import Foundation
import SwiftUI

enum AppStoreVersionState: String {
    case accepted = "ACCEPTED"
    case developerRemovedFromSale = "DEVELOPER_REMOVED_FROM_SALE"
    case developerRejected = "DEVELOPER_REJECTED"
    case inReview = "IN_REVIEW"
    case invalidBinary = "INVALID_BINARY"
    case metadataRejected = "METADATA_REJECTED"
    case pendingAppleRelease = "PENDING_APPLE_RELEASE"
    case pendingContract = "PENDING_CONTRACT"
    case pendingDeveloperRelease = "PENDING_DEVELOPER_RELEASE"
    case prepareForSubmission = "PREPARE_FOR_SUBMISSION"
    case preorderReadyForSale = "PREORDER_READY_FOR_SALE"
    case processingForAppStore = "PROCESSING_FOR_APP_STORE"
    case readyForReview = "READY_FOR_REVIEW"
    case readyForSale = "READY_FOR_SALE"
    case rejected = "REJECTED"
    case removedFromSale = "REMOVED_FROM_SALE"
    case waitingForExportCompliance = "WAITING_FOR_EXPORT_COMPLIANCE"
    case waitingForReview = "WAITING_FOR_REVIEW"
    case replacedWithNewVersion = "REPLACED_WITH_NEW_VERSION"
    case notApplicable = "NOT_APPLICABLE"
    
    init?(fromString string: String) {
        self.init(rawValue: string)
    }
}

struct AppStoreVersionEntity {
    let id: String
    let state: AppStoreVersionState
    let versionString: String
    
    var versionStateName: String {
        self.state.rawValue.replacingOccurrences(of: "_", with: " ")
    }
    
    var stateColor: Color {
        switch self.state {
        case .accepted, .preorderReadyForSale, .readyForReview, .readyForSale:
            return .green
        case .inReview, .pendingAppleRelease, .pendingContract, .pendingDeveloperRelease, .prepareForSubmission, .processingForAppStore, .waitingForExportCompliance, .waitingForReview:
            return .yellow
        case .developerRemovedFromSale, .developerRejected, .invalidBinary, .metadataRejected, .rejected, .removedFromSale, .replacedWithNewVersion, .notApplicable:
            return .red
        }
    }
    
    var stateIcon: Image {
        let iconName: String
        
        switch self.state {
        case .accepted, .preorderReadyForSale, .readyForReview, .readyForSale:
            iconName = "checkmark.circle.fill"
            break
        case .inReview, .pendingAppleRelease, .pendingContract, .pendingDeveloperRelease, .prepareForSubmission, .processingForAppStore, .waitingForExportCompliance, .waitingForReview:
            iconName = "exclamationmark.circle.fill"
            break
        case .developerRemovedFromSale, .developerRejected, .invalidBinary, .metadataRejected, .rejected, .removedFromSale, .replacedWithNewVersion, .notApplicable:
            iconName = "xmark.circle.fill"
            break
        }
        
        return Image(systemName: iconName)
    }
}

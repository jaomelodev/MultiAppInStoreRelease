//
//  AppBuildEntity.swift
//  JaoStoreReleases
//
//  Created by João Melo on 23/07/24.
//

import Foundation
import SwiftUI

enum BuildState: String {
    case processing = "PROCESSING"
    case failed = "FAILED"
    case invalid = "INVALID"
    case valid = "VALID"
    
    init?(fromString string: String) {
        self.init(rawValue: string)
    }
}


struct AppBuildEntity: Hashable, Identifiable {
    let id: String
    let version: String
    let uploadedDate: Date
    let imgUrl: String
    let buildState: BuildState
    
    var buildStateColor: Color {
        switch self.buildState {
        case .valid:
            return .green
        case .processing:
            return .yellow
        default:
            return .red
        }
    }
    
    var stateIcon: Image {
        let iconName: String
        
        switch self.buildState {
        case .valid:
            iconName = "checkmark.circle.fill"
            break
        case .processing:
            iconName = "exclamationmark.circle.fill"
            break
        default:
            iconName = "xmark.circle.fill"
            break
        }
        
        return Image(systemName: iconName)
    }
}

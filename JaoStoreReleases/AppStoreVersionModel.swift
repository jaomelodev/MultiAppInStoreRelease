//
//  AppStoreVersionModel.swift
//  JaoStoreReleases
//
//  Created by João Melo on 21/07/24.
//

import Foundation

class AppStoreVersionModel {
    let id: String
    let state: AppStoreVersionState
    let versionString: String
    let platform: String
    
    init(id: String, state: AppStoreVersionState, versionString: String, platform: String) {
        self.id = id
        self.state = state
        self.versionString = versionString
        self.platform = platform
    }
    
    convenience init?(dictionary: [String: Any]) {
        guard let appVersionId = dictionary["id"] as? String,
              let appVersionAttributes = dictionary["attributes"] as? [String: Any],
              let appVersionPlatform = appVersionAttributes["platform"] as? String,
              let appVersionString = appVersionAttributes["versionString"] as? String,
              let appVersionStateString = appVersionAttributes["appStoreState"] as? String,
              let appVersionState = AppStoreVersionState.init(rawValue: appVersionStateString) else {
            return nil
        }
        
        self.init(
            id: appVersionId,
            state: appVersionState,
            versionString: appVersionString,
            platform: appVersionPlatform
        )
    }
    
    func toAppStoreVersionEntity() -> AppStoreVersionEntity {
        AppStoreVersionEntity(
            id: self.id,
            state: self.state,
            versionString: self.versionString
        )
    }
}

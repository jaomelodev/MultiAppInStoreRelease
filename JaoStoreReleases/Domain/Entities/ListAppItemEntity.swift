//
//  AppFromStoreEntity.swift
//  JaoStoreReleases
//
//  Created by João Melo on 15/07/24.
//

import Foundation

enum AppType: String {
    case apple = "App Store"
    case google = "Google Play"
}

struct ListAppItemEntity: Hashable, Identifiable {
    let id: String
    let appOrBundleId: String
    let name: String
    let type: AppType
    let imageUrl: String?
    let appStoreVersion: AppStoreVersionEntity?
    
    func copyWith(
        id: String? = nil,
        appOrBundleId: String? = nil,
        name: String? = nil,
        type: AppType? = nil,
        imageUrl: String? = nil,
        appStoreVersion: AppStoreVersionEntity? = nil
    ) -> ListAppItemEntity {
        return ListAppItemEntity(
            id: id ?? self.id,
            appOrBundleId: appOrBundleId ?? self.appOrBundleId,
            name: name ?? self.name,
            type: type ?? self.type,
            imageUrl: imageUrl ?? self.imageUrl,
            appStoreVersion: appStoreVersion ?? self.appStoreVersion
        )
    }
    
    static func == (lhs: ListAppItemEntity, rhs: ListAppItemEntity) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

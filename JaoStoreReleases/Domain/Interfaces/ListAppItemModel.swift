//
//  AppFromStoreModel.swift
//  JaoStoreReleases
//
//  Created by João Melo on 15/07/24.
//

import Foundation

protocol ListAppItemModel {
    func toAppFromStoreEntity() -> ListAppItemEntity
}

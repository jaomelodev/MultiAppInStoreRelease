//
//  StoreServiceErrors.swift
//  JaoStoreReleases
//
//  Created by João Melo on 16/07/24.
//

import Foundation

enum ListAllAppStoreAppsError: Error {
    case appsNotFound
    case cannotConvert
}

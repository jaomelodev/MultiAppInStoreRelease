//
//  ListAvailableAppBuildsError.swift
//  JaoStoreReleases
//
//  Created by João Melo on 09/08/24.
//

import Foundation

enum ListAvailableAppBuildsError: Error {
    case failedToListAllBuilds
    case canceled
    case failedToGetAppVersionBuild
    case cannotConvert
}

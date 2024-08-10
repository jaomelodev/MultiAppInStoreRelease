//
//  GetAppVersionBuildError.swift
//  JaoStoreReleases
//
//  Created by João Melo on 09/08/24.
//

import Foundation

enum GetAppVersionBuildError: Error {
    case failedToGetBuild
    case cannotConvert
}

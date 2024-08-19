//
//  ReleaseAppVersionError.swift
//  JaoStoreReleases
//
//  Created by João Melo on 13/08/24.
//

import Foundation

enum ReleaseAppVersionError: Error {
    case failedToReleaseVersion
    case cannotConvert
}

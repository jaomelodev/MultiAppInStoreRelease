//
//  ListAllAppBuildsError.swift
//  JaoStoreReleases
//
//  Created by João Melo on 22/07/24.
//

import Foundation

enum ListAppBuildsError: Error {
    case buildsNotFound
    case canceled
    case cannotConvert
}

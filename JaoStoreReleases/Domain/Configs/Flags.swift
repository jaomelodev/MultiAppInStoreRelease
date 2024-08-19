//
//  Flags.swift
//  JaoStoreReleases
//
//  Created by João Melo on 20/07/24.
//

import Foundation

struct Flags {
    static let localAuthEnabled: Bool = ProcessInfo.processInfo.environment["LOCAL_AUTH"] == "true";
}

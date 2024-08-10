//
//  UTTypeExtension.swift
//  JaoStoreReleases
//
//  Created by João Melo on 10/07/24.
//

import UniformTypeIdentifiers

extension UTType {
    static var p8: UTType {
        UTType(importedAs: "com.apple.pkcs8-pem")
    }
}

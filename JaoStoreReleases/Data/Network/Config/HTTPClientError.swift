//
//  AppStoreHTTPClientError.swift
//  JaoStoreReleases
//
//  Created by João Melo on 16/07/24.
//

import Foundation

enum HTTPClientError: Error {
    case invalidResponse([String: Any], URLRequest)
    case refreshTokenFailed([String: Any], URLRequest, HTTPURLResponse)
    case requestError([String: Any], URLRequest, HTTPURLResponse)
    case networkError(Error, URLRequest)
    case canceled(URLRequest)
}

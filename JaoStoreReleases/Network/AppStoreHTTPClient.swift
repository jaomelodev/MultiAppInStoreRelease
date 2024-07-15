//
//  HTTPClient.swift
//  JaoStoreReleases
//
//  Created by João Melo on 14/07/24.
//

import Foundation
import SwiftJWT

class AppStoreHTTPClient {
    static var privateKeyInfo: PrivateKeyInfoData?
    
    private let baseURL: URL = URL(string: "https://api.appstoreconnect.apple.com")!
    private let session: URLSession = .shared
    
    private static var accessToken: String?
    
    func request(endpoint: AppStoreEndpoints, method: HTTPMethods, isRetry: Bool = false) async throws -> Data {
        let url = baseURL.appendingPathComponent(endpoint.rawValue)
        var requestData = URLRequest(url: url)
        
        requestData.httpMethod = method.rawValue
        requestData.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if AppStoreHTTPClient.accessToken != nil {
            requestData.addValue("Bearer \(AppStoreHTTPClient.accessToken!)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            let (data, response) = try await session.data(for: requestData)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NSError(domain: "Invalid response", code: 0, userInfo: nil)
            }
            
            if httpResponse.statusCode != 401 {
                return data
            }
            
            if refreshAccessToken() && !isRetry {
                return try await request(endpoint: endpoint, method: method, isRetry: true)
            } else {
                throw NSError(domain: "Token refresh failed", code: 0, userInfo: nil)
            }
            
        } catch {
            throw error
        }
    }
    
    private func refreshAccessToken() -> Bool {
        guard let privateKeyInfo = AppStoreHTTPClient.privateKeyInfo else {
            return false
        }
        
        let jwtHeader = Header(kid: privateKeyInfo.keyId)
        let now = Date()
        let expDate = now.addingTimeInterval(900)
        
        let claims = AppStoreJWTClaims(
            iss: privateKeyInfo.id.uuidString.lowercased(),
            aud: "appstoreconnect-v1",
            exp: Int(expDate.timeIntervalSince1970),
            iat: Int(now.timeIntervalSince1970)
        )
        
        var jwt = JWT(header: jwtHeader, claims: claims)
        
        let jwtSigner = JWTSigner.es256(privateKey: privateKeyInfo.keyContent)
        
        do {
            let jwtSigned = try jwt.sign(using: jwtSigner)
            
            AppStoreHTTPClient.accessToken = jwtSigned
            
            return true
        } catch {
            return false
        }
    }
}

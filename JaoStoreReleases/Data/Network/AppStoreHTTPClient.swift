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
    
    func request(
        endpoint: AppStoreEndpoints,
        method: HTTPMethods,
        queryParams: [String: String]? = nil,
        body: [String: Any]? = nil,
        isRetry: Bool = false
    ) async -> Result<[String: Any], HTTPClientError> {
        var url = baseURL.appendingPathComponent(endpoint.path())
        
        if let queryParams = queryParams {
            url = appendQueryParams(to: url, queryParams: queryParams)
        }
        
        var requestData = URLRequest(url: url)
        
        requestData.httpMethod = method.rawValue
        requestData.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = body {
            requestData.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        }
        
        if let accessToken = AppStoreHTTPClient.accessToken {
            requestData.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            let (data, response) = try await session.data(for: requestData)
            
            let json = (try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]) ?? [:]
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(.invalidResponse(json, requestData))
            }
            
            if (200...299).contains(httpResponse.statusCode) {
                return .success(json)
            }
            
            if httpResponse.statusCode != 401 {
                return .failure(.requestError(json, requestData, httpResponse))
            }
            
            if refreshAccessToken() && !isRetry {
                return await request(endpoint: endpoint, method: method, queryParams: queryParams, isRetry: true)
            } else {
                return .failure(.refreshTokenFailed(json, requestData, httpResponse))
            }
            
        } catch let error as URLError where error.code == .cancelled {
            return .failure(.canceled(requestData))
        } catch {
            return .failure(.networkError(error, requestData))
        }
    }
    
    private func appendQueryParams(to url: URL, queryParams: [String: String]) -> URL {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        return components?.url ?? url
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

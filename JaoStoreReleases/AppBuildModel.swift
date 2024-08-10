//
//  AppBuildModel.swift
//  JaoStoreReleases
//
//  Created by João Melo on 22/07/24.
//

import Foundation

class AppBuildModel {
    var id: String
    var version: String
    var uploadedDate: Date
    var imgUrl: String
    var buildState: BuildState
    
    init(id: String, version: String, uploadedDate: Date, imgUrl: String, buildState: BuildState) {
        self.id = id
        self.version = version
        self.uploadedDate = uploadedDate
        self.imgUrl = imgUrl
        self.buildState = buildState
    }
    
    func toAppBuildEntity() -> AppBuildEntity {
        AppBuildEntity(
            id: self.id,
            version: self.version,
            uploadedDate: self.uploadedDate,
            imgUrl: self.imgUrl,
            buildState: self.buildState
        )
    }
    
    convenience init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
              let attributes = dictionary["attributes"] as? [String: Any],
              let version = attributes["version"] as? String,
              let uploadedDate = attributes["uploadedDate"] as? String,
              let processingState = attributes["processingState"] as? String,
              let iconAssetToken = attributes["iconAssetToken"] as? [String: Any],
              let imgWidth = iconAssetToken["width"] as? Int,
              let imgHeight = iconAssetToken["height"] as? Int,
              let imgTemplate = iconAssetToken["templateUrl"] as? String else {
                return nil
            }
        
        guard let buildState = BuildState(fromString: processingState) else {
            return nil
        }
        
        let imageUrl = imgTemplate
            .replacingOccurrences(of: "{w}", with: "\(imgWidth)")
            .replacingOccurrences(of: "{h}", with: "\(imgHeight)")
            .replacingOccurrences(of: "{f}", with: "png")
        
        let dateFormatter = ISO8601DateFormatter()
        let date = dateFormatter.date(from: uploadedDate) ?? Date.now
        
        self.init(id: id, version: version, uploadedDate: date, imgUrl: imageUrl, buildState: buildState)
    }
}

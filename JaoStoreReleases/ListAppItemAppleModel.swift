//
//  AppFromAppStoreModel.swift
//  JaoStoreReleases
//
//  Created by João Melo on 15/07/24.
//

import Foundation

class ListAppItemAppleModel: ListAppItemModel {
    var id: String
    var bundleId: String
    var name: String
    var imageUrl: String?
    var appStoreVersion: AppStoreVersionModel?
    
    init(id: String, bundleId: String, name: String, imageUrl: String?, appStoreVersion: AppStoreVersionModel?) {
        self.id = id
        self.bundleId = bundleId
        self.name = name
        self.imageUrl = imageUrl
        self.appStoreVersion = appStoreVersion
    }
    
    func toAppFromStoreEntity() -> ListAppItemEntity {
        ListAppItemEntity(
            id: self.id,
            appOrBundleId: self.bundleId,
            name: self.name,
            type: .apple,
            imageUrl: self.imageUrl,
            appStoreVersion: self.appStoreVersion?.toAppStoreVersionEntity()
        )
    }
    
    // JSON Serialization
    
    convenience init?(dictionary: [String: Any], includedDataDic: [String: Any]) {
        guard let id = dictionary["id"] as? String,
              let attributes = dictionary["attributes"] as? [String: Any],
              let name = attributes["name"] as? String,
              let bundleId = attributes["bundleId"] as? String else {
            return nil
        }
        
        var imageUrl: String? = nil
        
        if let relationships = dictionary["relationships"] as? [String: Any],
           let builds = relationships["builds"] as? [String: Any],
           let buildData = builds["data"] as? [[String: Any]],
           let buildId = buildData.first?["id"] as? String,
           let buildData = includedDataDic[buildId] as? [String: Any],
           let buildAttributes = buildData["attributes"] as? [String: Any],
           let iconAssetToken = buildAttributes["iconAssetToken"] as? [String: Any],
           let imgWidth = iconAssetToken["width"] as? Int,
           let imgHeight = iconAssetToken["height"] as? Int,
           let imgTemplate = iconAssetToken["templateUrl"] as? String {
            imageUrl = imgTemplate
                .replacingOccurrences(of: "{w}", with: "\(imgWidth)")
                .replacingOccurrences(of: "{h}", with: "\(imgHeight)")
                .replacingOccurrences(of: "{f}", with: "png")
            
        }
        
        var appStoreVersion: AppStoreVersionModel? = nil
        
        if let relationships = dictionary["relationships"] as? [String: Any],
           let appStoreVersions = relationships["appStoreVersions"] as? [String: Any],
           let appStoreVersionData = appStoreVersions["data"] as? [[String: Any]],
           let appStoreVersionId = appStoreVersionData.first?["id"] as? String,
           let appStoreVersionDataDic = includedDataDic[appStoreVersionId] as? [String: Any]
        {
            appStoreVersion = AppStoreVersionModel(
                dictionary: appStoreVersionDataDic
            )
            
        }
        
     
        
        self.init(id: id, bundleId: bundleId, name: name, imageUrl: imageUrl, appStoreVersion: appStoreVersion)
    }
}

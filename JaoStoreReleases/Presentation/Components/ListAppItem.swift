//
//  ListAppItem.swift
//  JaoStoreReleases
//
//  Created by João Melo on 20/07/24.
//

import SwiftUI

struct ListAppItem: View {
    @Binding var appItem: ListAppItemEntity
    
    var body: some View {
        
        HStack {
            if let imageUrl = appItem.imageUrl {
                AsyncImage(url: URL(string: imageUrl)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 25, maxHeight: 25)
                            .cornerRadius(5)
                    case .failure:
                        Image(systemName: "questionmark.app")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 27, maxHeight: 27)
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image(systemName: "questionmark.app")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 27, maxHeight: 27)
            }
            
            VStack (alignment: .leading, spacing: 3) {
                Text(appItem.name)
                Text(appItem.appOrBundleId)
                    .font(.caption)
            }
            
            if let appStoreVersion = appItem.appStoreVersion {
                Spacer()
                
                appStoreVersion.stateIcon
                    .resizable()
                    .frame(width: 10, height: 10)
                    .foregroundColor(appStoreVersion.stateColor)
                
            }
        }
    }
}

#Preview {
    let appFromStoreEntity = ListAppItemEntity(
        id: "123344",
        appOrBundleId: "br.com.me",
        name: "App Teste",
        type: .apple,
        imageUrl: "https://is1-ssl.mzstatic.com/image/thumb/Purple211/v4/78/98/66/7898667a-28f6-80a3-c7a3-118585cf6d69/AppIcon-prod60x60@2x.png/100x100bb.png",
        appStoreVersion: AppStoreVersionEntity(id: "1", state: .accepted, versionString: "10")
    )
    
    return ListAppItem(
        appItem: .constant(appFromStoreEntity)
    )
    .frame(width: 300)
    .padding(30)
}

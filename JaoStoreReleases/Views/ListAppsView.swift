//
//  ListAppsView.swift
//  JaoStoreReleases
//
//  Created by João Melo on 14/07/24.
//

import SwiftUI

struct ListAppsView: View {
    @StateObject var controller: ListAppsController
    
    var body: some View {
        NavigationSplitView {
            Text("Text")
        } detail: {
            Text("Test")
        }
    }
}

#Preview {
    let controller = ListAppsController()
    
    return ListAppsView(
        controller: controller
    )
}

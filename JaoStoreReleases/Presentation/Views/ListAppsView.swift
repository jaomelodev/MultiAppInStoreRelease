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
        NavigationView {
            if controller.loadingApps {
                ProgressView()
            } else if !controller.errorMessage.isEmpty || controller.apps.isEmpty {
                Text(controller.errorMessage)
                    .foregroundColor(.red)
            } else {
                List(controller.apps.indices, id: \.self, selection: $controller.selectedApp) { appIndex in
                    let app = controller.apps[appIndex]
                    
                    LazyNavigationLink(
                        destination: {
                            let appDetailsInjector = AppDetailsViewInjector(appItem: app) { appItem in
                                controller.apps[appIndex] = appItem
                            }
                               
                            let appDetailsController = appDetailsInjector.registerDependencies()
                            
                            AppDetailsView(
                                controller: appDetailsController
                            )
                        }
                    ) {
                        ListAppItem(appItem: $controller.apps[appIndex])
                    }
                    .tag(app)
                    
                }
                .listStyle(SidebarListStyle())
            }
            
            if controller.loadingApps {
                ProgressView()
            } else {
                Text("Select an app")
            }
        }
        .onAppear {
            Task {
                await controller.listAllApps()
            }
        }
    }
}

#Preview {
    let client = AppStoreHTTPClient()
    
    let appStoreService = AppStoreServiceImpl(appStoreClient: client)
    
    let listAllAppsUseCase = ListAllAppsAppleUseCaseImpl(appStoreService: appStoreService)
    
    let controller = ListAppsController(
        listAllAppsAppleUseCase: listAllAppsUseCase
    )
    
    return ListAppsView(
        controller: controller
    )
}

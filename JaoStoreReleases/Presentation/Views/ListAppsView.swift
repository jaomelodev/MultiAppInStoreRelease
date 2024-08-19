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
        .confirmationDialog(
            "Change account?",
            isPresented: $controller.showChangeAccountDialog
        ) {
            Button("Confirm") {
                Task {
                    await controller.changeAccount()
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to change account?")
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button {
                    controller.showChangeAccountDialog = true
                } label: {
                    Text("Change account")
                        .padding(5)
                }
            }
        }
    }
}

#Preview {
    let listAllAppsUseCase = ListAllAppStoreAppsCaseMock()
    
    let keyChainService = KeyChainServiceImpl()
    
    let removeItemKeyChainUseCase = RemoveItemKeyChainUseCaseImpl(
        removeItemKeyChainService: keyChainService
    )
    
    let controller = ListAppsController(
        hasKeySaved: .constant(true),
        listAllAppsAppleUseCase: listAllAppsUseCase,
        removeItemKeyChainUseCase: removeItemKeyChainUseCase
    )
    
    return ListAppsView(
        controller: controller
    )
}

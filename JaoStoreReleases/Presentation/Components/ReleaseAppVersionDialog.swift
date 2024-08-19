//
//  ReleaseAppVersionDialog.swift
//  JaoStoreReleases
//
//  Created by João Melo on 13/08/24.
//

import SwiftUI

struct ReleaseAppVersionDialog: View {
    @StateObject var appDetailsController: AppDetailsController
    
    var body: some View {
        VStack {
            switch appDetailsController.releaseVersionState {
            case .idle:
                VStack {
                    Spacer()
                    
                    Image(systemName: "questionmark.app")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .padding(.bottom, 10)
                    
                    Text("Release version \(appDetailsController.appItem.appStoreVersion?.versionString ?? "")!")
                    
                    Text("Are you sure you want to release this version?")
                        .padding(.bottom, 20)
                    
                    HStack {
                        Button("Cancel") {
                            appDetailsController.showCreateReleaseForm = false
                        }
                        .buttonStyle(.bordered)
                        .cornerRadius(5)
                        
                        Spacer()
                        
                        
                        Button("Release") {
                            Task {
                                await appDetailsController.releaseAppVersion()
                            }
                        }
                        .buttonStyle(.bordered)
                        .background(.blue)
                        .cornerRadius(5)
                    }
                    
                    Spacer()
                }
                .frame(width: 280, height: 300)
                
            case .loading:
                VStack {
                    Spacer()
                    ProgressView("Releasing your version...")
                    Spacer()
                }
                .frame(height: 300)
            case .error:
                VStack {
                    Spacer()
                    
                    Image(systemName: "xmark.app")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .padding(.bottom, 10)
                    
                    Text("Could not release your version!")
                    Text("If the error persists, verify on App Store Connect if everything's ok")
                    
                    Spacer()
                }
                .foregroundColor(.red)
                .frame(height: 300)
            case .success:
                VStack {
                    Spacer()
                    
                    Image(systemName: "app.badge.checkmark")
                        .resizable()
                        .frame(width: 35, height: 30)
                        .padding(.bottom, 10)
                    
                    Text("Your version was released!")
                    Text("Now your app is available in App Store.")
                    
                    Spacer()
                }
                .foregroundColor(.green)
                .frame(height: 300)
            }
        }
        .navigationTitle("Release AppVersion")
        .frame(width: 450)
        .animation(.easeIn, value: appDetailsController.releaseVersionState)
    }
}

#Preview {
    let listAvailableAppBuildsUseCase = ListAvailableAppBuildsUseCaseMock()
    
    let createNewReleaseUseCase = CreateNewReleaseUseCaseMock()
    
    let getAppVersionFromAppUseCase = GetAppAppVersionUseCaseMock()
    
    let releaseAppVersionUseCase = ReleaseAppVersionUseCaseMock()
    
    let listAppItem = ListAppItemEntity(
        id: "asdfasdf",
        appOrBundleId: "br.com.me",
        name: "My App",
        type: .apple,
        imageUrl: "https://is1-ssl.mzstatic.com/image/thumb/Purple211/v4/78/98/66/7898667a-28f6-80a3-c7a3-118585cf6d69/AppIcon-prod60x60@2x.png/120x120bb.png",
        appStoreVersion: AppStoreVersionEntity(
            id: "132132132",
            state: .accepted,
            versionString: "2024.07.15"
        )
    )
    
    let controller = AppDetailsController(
        appItem: listAppItem,
        listAvailableAppBuildsUseCase: listAvailableAppBuildsUseCase,
        createNewReleaseUseCase: createNewReleaseUseCase,
        getAppVersionFromAppUseCase: getAppVersionFromAppUseCase,
        releaseAppVersionUseCase: releaseAppVersionUseCase
    ) { appItem in
        print(appItem)
    }
    
    controller.listAppBuilds()
    
    return ReleaseAppVersionDialog(
        appDetailsController: controller
    )
}

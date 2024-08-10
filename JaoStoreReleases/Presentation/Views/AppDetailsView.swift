//
//  AppDetailsView.swift
//  JaoStoreReleases
//
//  Created by João Melo on 21/07/24.
//

import SwiftUI

struct AppDetailsView: View {
    @StateObject var controller: AppDetailsController
    
    var body: some View {
        
        VStack(spacing: 0) {
            if controller.getAppVersionLoading {
                ProgressView()
                    .frame(height: 80)
            } else {
                HStack {
                    if let imageUrl = controller.appItem.imageUrl {
                        AsyncImage(
                            url: URL(string: imageUrl),
                            transaction: Transaction(animation: .default)
                        ) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(20)
                            case .failure:
                                Image(systemName: "questionmark.app")
                                    .resizable()
                                    .frame(maxWidth: 80, maxHeight: 80)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    } else {
                        Image(systemName: "questionmark.app")
                            .resizable()
                            .frame(maxWidth: 80, maxHeight: 80)
                    }
                    
                    VStack(alignment: .leading) {
                        Text(controller.appItem.name)
                            .font(.largeTitle)
                        
                        Text(controller.appItem.appOrBundleId)
                        
                        if let appStoreVersion = controller.appItem.appStoreVersion {
                            Spacer()
                            
                            HStack {
                                appStoreVersion.stateIcon
                                    .foregroundColor(appStoreVersion.stateColor)
                                
                                Text(appStoreVersion.versionString)
                                
                                Text(appStoreVersion.versionStateName)
                            }
                        }
                    }
                    .padding(10)
                    
                    Spacer()
                    
                    if case .appBuilds(_) = controller.appBuildsState {
                        VStack {
                            Button {
                                controller.showCreateReleaseForm = true
                            } label: {
                                VStack {
                                    Image(systemName: "plus.app")
                                        .resizable()
                                        .frame(width: 17, height: 17)
                                    
                                    Text("Create new\nversion")
                                        .font(.caption)
                                        .multilineTextAlignment(.center)
                                }
                                
                            }
                            .buttonStyle(PlainButtonStyle())
                            .sheet(isPresented: $controller.showCreateReleaseForm) {
                                CreateReleaseForm(
                                    appDetailsController: controller
                                )
                            }
                        }
                    }
                }
                .frame(height: 80)
            }
            
            Divider()
                .padding([.top, .bottom])
            
            HStack {
                Text("Available builds")
                    .font(.system(size: 20, weight: .medium))
                
                Spacer()
                
                Button {
                    controller.listAppBuilds()
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .resizable()
                        .frame(width: 17, height: 17)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding([.bottom], 20)
            
            AppBuildsTable(isAppStore: true)
            
            Spacer()
        }
        .padding(32)
        .onAppear {
            controller.listAppBuilds()
        }
        .onDisappear {
            controller.listBuildsTask = nil
        }
    }
    
    @ViewBuilder
    private func AppBuildsTable(isAppStore: Bool) -> some View {
        switch controller.appBuildsState {
        case .loading:
            ProgressView("Loading your builds")
                .padding(.top, 40)
        case .error(_):
            HStack {
                Spacer()
                
                VStack {
                    Image(systemName: "xmark.app")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .padding(.bottom, 10)
                        .padding(.top, 20)
                    
                    Text("Could not load the app builds")
                    Text("Check your connections and try again!")
                        .padding(.bottom, 20)
                }
                .foregroundColor(.red)
                Spacer()
            }
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.red, lineWidth: 1)
            )
        case .empty:
            HStack {
                Spacer()
                
                VStack {
                    Image(systemName: "nosign.app")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .padding(.bottom, 10)
                        .padding(.top, 20)
                    
                    Text("There aren't builds available for a new release.")
                    Text("Upload your builds in App Store Connect and try again")
                        .padding(.bottom, 20)
                }
                .foregroundColor(.yellowStrong)
                Spacer()
            }
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.yellowStrong, lineWidth: 1)
            )
        case .appBuilds(let appBuilds):
            VStack(spacing: 0) {
                ForEach(appBuilds.indices, id: \.self) { index in
                    let appBuild = appBuilds[index]
                    
                    HStack {
                        AsyncImage(url: URL(string: appBuild.imgUrl)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .frame(width: 35, height: 35)
                                    .cornerRadius(10)
                            case .failure:
                                Image(systemName: "questionmark.app")
                                    .resizable()
                                    .frame(maxWidth: 40, maxHeight: 40)
                            @unknown default:
                                EmptyView()
                            }
                        }
                        
                        Text(appBuild.version)
                        
                        Spacer()
                        
                        Text(isAppStore ? "App Store" : "Google Play")
                        
                        Spacer()
                        
                        HStack {
                            Spacer()
                            
                            Text(appBuild.buildState.rawValue)
                            
                                .multilineTextAlignment(.trailing)
                            
                            appBuild.stateIcon
                                .foregroundColor(appBuild.buildStateColor)
                        }
                        .frame(width: 120)
                        
                        
                        
                    }
                    .padding(10)
                    
                    
                    
                    if index < appBuilds.count - 1 {
                        Divider()
                            .foregroundColor(isAppStore ? .blue : .green)
                    }
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.blue, lineWidth: 1)
            )
        }
    }
}

#Preview {
    let listAvailableAppBuildsUseCase = ListAvailableAppBuildsUseCaseMock(result: .failure(.failedToListAllBuilds))
    
    let createNewReleaseUseCase = CreateNewReleaseUseCaseMock()
    
    let getAppVersionFromAppUseCase = GetAppVersionFromAppUseCaseMock()
    
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
        getAppVersionFromAppUseCase: getAppVersionFromAppUseCase
    ) { appItem in
        print(appItem)
    }

    return AppDetailsView(
        controller: controller
    )
    .padding(30)
}

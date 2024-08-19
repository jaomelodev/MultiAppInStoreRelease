//
//  CreateReleaseForm.swift
//  JaoStoreReleases
//
//  Created by João Melo on 06/08/24.
//

import SwiftUI

struct CreateReleaseForm: View {
    @StateObject var appDetailsController: AppDetailsController
    
    var body: some View {
        VStack {
            switch appDetailsController.createAppVersionState {
            case .loading(let loadingMessage):
                VStack {
                    Spacer()
                    ProgressView(loadingMessage)
                    Spacer()
                }
                .frame(height: 300)
            case .versionCreated:
                VStack {
                    Spacer()
                    
                    Image(systemName: "app.badge.checkmark")
                        .resizable()
                        .frame(width: 35, height: 30)
                        .padding(.bottom, 10)
                    
                    Text("Your release was created!")
                    Text("Now your app is on review in App Store Connect.")
                    
                    Spacer()
                }
                .foregroundColor(.green)
                .frame(height: 300)
            case .error:
                VStack {
                    Spacer()
                    
                    Image(systemName: "xmark.app")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .padding(.bottom, 10)
                    
                    Text("Could not create your release!")
                    Text("If the error persists, verify on App Store Connect if everything's ok")
                    
                    Spacer()
                }
                .foregroundColor(.red)
                .frame(height: 300)
            case .idle:
                Form {
                    Section(header: Text("Version (e.g., 2024.08.06)")) {
                        VStack {
                            TextEditor(text: $appDetailsController.versionString)
                                .textEditorStyle(.plain)
                                .font(.body)
                                .scrollIndicators(.never)
                                .frame(height: 15)
                        }
                        .padding(5)
                        .background(.black.opacity(0.2))
                        .cornerRadius(5)
                        .padding(.bottom, 20)
                    }
                    
                    Section(header: Text("Release Notes")) {
                        VStack {
                            TextEditor(text: $appDetailsController.releaseNotes)
                                .textEditorStyle(.plain)
                                .font(.body)
                                .scrollIndicators(.never)
                                .frame(height: 100)
                        }
                        .padding(5)
                        .background(.black.opacity(0.2))
                        .cornerRadius(5)
                        .padding(.bottom, 20)
                    }
                    
                    
                    
                    if case .appBuilds(let builds) = appDetailsController.appBuildsState {
                        Section(header: Text("Build Selection")) {
                            Picker("", selection: $appDetailsController.selectedBuild) {
                                Text("Select a build")
                                    .tag("")
                                
                                ForEach(builds.filter { $0.buildState == .valid }) { build in
                                    Text(build.version)
                                        .tag(build.id)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .padding(.bottom, 20)
                        }
                    }
                    
                    Section {
                        Toggle("Uses Non Exempt Encryption", isOn: $appDetailsController.usesNonExemptEncryption)
                            .padding(.bottom, 20)
                    }
                    
                    Section {
                        HStack {
                            Button("Cancel") {
                                appDetailsController.showCreateReleaseForm = false
                            }
                            .buttonStyle(.bordered)
                            .cornerRadius(5)
                            
                            Spacer()
                            
                            Text(appDetailsController.createNewVersionFormError)
                                .foregroundColor(.red)
                            
                            Spacer()
                            
                            
                            Button("Submit") {
                                Task {
                                    await appDetailsController.createNewReleaseForApp()
                                }
                            }
                            .buttonStyle(.bordered)
                            .background(.blue)
                            .cornerRadius(5)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Release Form")
        .frame(width: 450)
        .animation(.easeIn, value: appDetailsController.createAppVersionState)
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
    
    return CreateReleaseForm(
        appDetailsController: controller
    )
}

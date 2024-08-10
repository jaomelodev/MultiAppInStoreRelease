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
        Form {
            Section(header: Text("Version (e.g., 2024.08.06)")) {
                TextField("", text: $appDetailsController.versionString)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 20)
            }
            
            Section(header: Text("Release Notes")) {
                TextEditor(text: $appDetailsController.releaseNotes)
                    .frame(height: 100)
                    .border(Color.gray, width: 1)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
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
                    
                    Text(appDetailsController.createNewVersionControllerError)
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
        .navigationTitle("Release Form")
        .frame(width: 450)
    }
}

#Preview {
    let listAvailableAppBuildsUseCase = ListAvailableAppBuildsUseCaseMock()
    
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
    
    controller.listAppBuilds()
    
    return CreateReleaseForm(
        appDetailsController: controller
    )
}

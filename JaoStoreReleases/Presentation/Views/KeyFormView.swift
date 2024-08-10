//
//  HomeView.swift
//  JaoStoreReleases
//
//  Created by João Melo on 11/07/24.
//

import SwiftUI

struct KeyFormView: View {
    @StateObject var controller: KeyFormController
    
    @Binding var hasKeySaved: Bool
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                Form {
                    Section(header: Text("Key ID")) {
                        TextField("",text: $controller.keyIDFormField)
                            .textFieldStyle(.roundedBorder)
                            .padding([.bottom], 15)
                    }
                    
                    Section(header: Text("Key Issuer")) {
                        TextField("", text: $controller.keyIssuerFormField)
                            .textFieldStyle(.roundedBorder)
                            .padding([.bottom], 15)
                    }

                    HStack {
                        Text("Selected File:")
                        Spacer()
                        if let selectedFile = controller.selectedFile {
                            Text(selectedFile.lastPathComponent)
                                .lineLimit(1)
                        } else {
                            Text("No file selected")
                                .foregroundColor(.gray)
                        }
                        Button(action: {
                            controller.showFileImporter.toggle()
                        }) {
                            Image(systemName: "folder")
                        }
                    }
                    .padding([.bottom], 30)
                    .fileImporter(
                        isPresented: $controller.showFileImporter,
                        allowedContentTypes: [.p8],
                        allowsMultipleSelection: false,
                        onCompletion: controller.onFileSelected
                    )
                    
                    HStack {
                        Text(controller.errorMessage)
                            .foregroundColor(.red)
                        
                        Spacer()
                        
                        Button {
                            Task {
                                await controller.saveItem()
                            }
                        } label: {
                            Text("Continue")
                        }
                        .buttonStyle(.bordered)
                        .background(.blue)
                        .cornerRadius(5)
                        
                    }
                }
                .frame(maxWidth: 400)
                
                Spacer()
            }
            Spacer()
        }
        .onAppear {
            controller.dismissAction = {
                hasKeySaved = true
            }
        }
    }
}

#Preview {
    let authService = AuthServiceImpl()
    
    let localAuthUseCase = LocalAuthUseCaseImpl(
        localAuthService: authService
    )
    
    let keyChainService = KeyChainServiceImpl()
    
    let saveItemKeyChainUseCase = SaveItemKeyChainUseCaseImpl(
        saveItemKeyChainService: keyChainService
    )
    
    let homeController = KeyFormController(
        localAuthUseCase: localAuthUseCase,
        saveItemKeyChainUseCase: saveItemKeyChainUseCase
    )
    
    return KeyFormView(
        controller: homeController,
        hasKeySaved: .constant(false)
    )
}

//
//  HomeController.swift
//  JaoStoreReleases
//
//  Created by João Melo on 11/07/24.
//

import SwiftUI

class KeyFormController: ObservableObject {
    @Binding var hasKeySaved: Bool
    
    let localAuthUseCase: LocalAuthUseCase
    let saveItemKeyChainUseCase: SaveItemKeyChainUseCase
    
    @Published var keyIDFormField: String = ""
    @Published var keyIssuerFormField: String = ""
    
    @Published var selectedFile: URL?
    @Published var showFileImporter = false
    
    @Published var errorMessage: String = ""
    
    init(
        hasKeySaved: Binding<Bool>,
        localAuthUseCase: LocalAuthUseCase,
        saveItemKeyChainUseCase: SaveItemKeyChainUseCase
    ) {
        self._hasKeySaved = hasKeySaved
        self.saveItemKeyChainUseCase = saveItemKeyChainUseCase
        self.localAuthUseCase = localAuthUseCase
    }
    
    func onFileSelected(_ result: Result<[URL], any Error>) -> Void {
       switch result {
        case .success(let fileUrls):
           guard let fileUrl = fileUrls.first else {
               //TODO: Show error file notFound
               return
           }
           
           selectedFile = fileUrl
        case .failure(let error):
           //TODO: Show error could convert file to string
            print(error)
        }
    }
    
    func readFile(fileUrl: URL) -> Data? {
        do {
            // Request access to the file
            guard fileUrl.startAccessingSecurityScopedResource() else {
                //TODO: Show erro permission
                return nil
            }
            
            //Used to execute this code when the current scope is going to exit, indepedent of when
            defer {
                fileUrl.stopAccessingSecurityScopedResource()
            }
            
            let fileContents = try Data(contentsOf: fileUrl, options: .alwaysMapped)
            
            return fileContents
            
        } catch {
            print("Failed to read file: \(error.localizedDescription)")
            return nil
        }
    }
    
    func validateForm() -> Bool {
        errorMessage = ""
        
        keyIDFormField = keyIDFormField.trimmingCharacters(in: .whitespacesAndNewlines)
        keyIssuerFormField = keyIssuerFormField.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if keyIDFormField.isEmpty {
            errorMessage = "Invalid Key Id"
        } else if UUID(uuidString: keyIssuerFormField) == nil {
            errorMessage = "Invalid Key Issuer"
        } else if (selectedFile == nil) {
            errorMessage = "Select your .p8 file"
        }
        
        return errorMessage.isEmpty
    }
    
    func saveItem() async -> Void {
        if !validateForm() {
            return
        }
        
        guard let keyData = readFile(fileUrl: selectedFile!) else {
            DispatchQueue.main.async {
                self.errorMessage = "Could not read key content"
            }
            
            return
        }
        
        let privateKeyInfoData = PrivateKeyInfoData(
            id: UUID(uuidString: keyIssuerFormField)!,
            keyId: keyIDFormField,
            keyContent: keyData
        )
        
        let authResult = await localAuthUseCase.execute(NoParams())
        
        if case .failure(_) = authResult {
            DispatchQueue.main.async {
                self.errorMessage = "Authentication Failed"
            }
            return
        }
        
        let saveItemResult = await saveItemKeyChainUseCase.execute(
            SaveItemKeyChainParams(key: KeyChain.privateKeyName, keyInfo: privateKeyInfoData)
        )
        
        if case .failure(_) = saveItemResult {
            DispatchQueue.main.async {
                self.errorMessage = "Could not save your key in Key Chain"
            }
            
            return
        }
        
        AppStoreHTTPClient.privateKeyInfo = privateKeyInfoData
        
        DispatchQueue.main.async {
            self.hasKeySaved = true
        }
    }
}

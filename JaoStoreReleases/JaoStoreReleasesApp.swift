//
//  JaoStoreReleasesApp.swift
//  JaoStoreReleases
//
//  Created by João Melo on 10/07/24.
//

import SwiftUI

@main
struct JaoStoreReleasesApp: App {
    var body: some Scene {
        WindowGroup {
            let homeViewInjector = HomeViewInjector()
            
            HomeView(controller:  homeViewInjector.container.resolve(HomeController.self)!)
        }
    }
}

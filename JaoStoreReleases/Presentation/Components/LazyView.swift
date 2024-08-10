//
//  LazyView.swift
//  JaoStoreReleases
//
//  Created by João Melo on 21/07/24.
//

import SwiftUI

struct LazyNavigationLink<Destination: View, Label: View>: View {
    private let destination: () -> Destination
    private let label: () -> Label

    init(
        @ViewBuilder destination: @escaping () -> Destination,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.destination = destination
        self.label = label
    }

    var body: some View {
        NavigationLink(destination: LazyView(destination: destination)) {
            label()
        }
    }
}

struct LazyView<Content: View>: View {
    let destination: () -> Content
    
    var body: some View {
        destination()
    }
}

//
//  Task.swift
//  JaoStoreReleases
//
//  Created by João Melo on 29/07/24.
//

import Foundation
import Combine

extension Task {
  func eraseToAnyCancellable() -> AnyCancellable {
        AnyCancellable(cancel)
    }
}

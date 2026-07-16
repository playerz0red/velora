//
//  File.swift
//  velora
//
//  Created by Pavel Playerz0redd on 15.07.26.
//

import Foundation
import SwiftUI

struct AuthFlowView: View {
    
    @State private var coordinator: AuthCoordinator
    private let authFactory: AuthFactoryProtocol
    
    init(authFactory: AuthFactoryProtocol) {
        self.coordinator = AuthCoordinator(authFactory: authFactory)
        self.authFactory = authFactory
    }
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            AuthView(viewModel: authFactory.buildAuthViewModel())
                .navigationDestination(for: AuthRoute.self) { route in
                    coordinator.destination(for: route)
                }
        }
        .environment(coordinator)
    }
}

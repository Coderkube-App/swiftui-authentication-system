//
// Copyright (c) 2026 Coderkube Technologies - SwiftUICleanArchitectureApp. All rights reserved.
//

import SwiftUI
import Combine

@MainActor
public class AppCoordinator: ObservableObject {
  @Published public var navigationPath = NavigationPath()
  @Published public var isLoggedIn: Bool = false
  
  private let diContainer: DIContainer
  private var cancellables = Set<AnyCancellable>()
  
  public init(diContainer: DIContainer) {
    self.diContainer = diContainer
    
    // Listen to session state
    diContainer.sessionManager.isLoggedInPublisher
      .receive(on: RunLoop.main)
      .sink { [weak self] loggedIn in
        self?.isLoggedIn = loggedIn
      }
      .store(in: &cancellables)
  }
  
  @ViewBuilder
  public func start() -> some View {
    let pathBinding = Binding(
      get: { self.navigationPath },
      set: { self.navigationPath = $0 }
    )
    
    Group {
      if isLoggedIn {
        NavigationStack(path: pathBinding) {
          HomeView(viewModel: diContainer.makeHomeViewModel())
            .navigationDestination(for: Route.self) { route in
              self.resolveRoute(route)
            }
        }
      } else {
        NavigationStack(path: pathBinding) {
          LoginView(viewModel: diContainer.makeLoginViewModel(), onNavigateToSignup: { [weak self] in
            self?.navigationPath.append(Route.signup)
          })
          .navigationDestination(for: Route.self) { route in
            self.resolveRoute(route)
          }
        }
      }
    }
  }
  
  @ViewBuilder
  private func resolveRoute(_ route: Route) -> some View {
    switch route {
    case .signup:
      SignupView(viewModel: diContainer.makeSignupViewModel(), onNavigateBackToLogin: { [weak self] in
        self?.navigationPath.removeLast()
      })
    }
  }
}

public enum Route: Hashable {
  case signup
}

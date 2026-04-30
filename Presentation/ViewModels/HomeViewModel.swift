//
// Copyright (c) 2026 Coderkube Technologies - SwiftUICleanArchitectureApp. All rights reserved.
//

import Foundation
import Combine

@MainActor
public class HomeViewModel: ObservableObject {
  @Published public var userEmail: String = ""
  @Published public var userProvider: String = ""
  @Published public var showingLogoutAlert: Bool = false
  
  private let logoutUseCase: LogoutUseCase
  private let authRepository: AuthRepositoryProtocol
  
  public init(logoutUseCase: LogoutUseCase, authRepository: AuthRepositoryProtocol) {
    self.logoutUseCase = logoutUseCase
    self.authRepository = authRepository
    loadUser()
  }
  
  private func loadUser() {
    if let session = authRepository.getCurrentSession() {
      self.userEmail = session.user.email ?? session.user.id
      self.userProvider = session.user.provider.rawValue.capitalized
    }
  }
  
  public func logout() {
    Task {
      do {
        try await logoutUseCase.execute()
        // Navigation handled by SessionManager state
      } catch {
        print("Logout error: \(error)")
      }
    }
  }
}

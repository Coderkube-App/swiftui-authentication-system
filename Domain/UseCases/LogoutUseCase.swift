//
// Copyright (c) 2026 Coderkube Technologies - SwiftUICleanArchitectureApp. All rights reserved.
//

import Foundation

public struct LogoutUseCase {
  private let repository: AuthRepositoryProtocol
  
  public init(repository: AuthRepositoryProtocol) {
    self.repository = repository
  }
  
  public func execute() async throws {
    try await repository.logout()
  }
}

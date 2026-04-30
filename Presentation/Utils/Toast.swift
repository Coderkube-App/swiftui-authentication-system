//
// Copyright (c) 2026 Coderkube Technologies - SwiftUICleanArchitectureApp. All rights reserved.
//

import Foundation

public struct Toast: Identifiable, Equatable {
  public let id: UUID
  public let message: String
  public let type: ToastType
  
  public init(id: UUID = UUID(), message: String, type: ToastType) {
    self.id = id
    self.message = message
    self.type = type
  }
}

public enum ToastType: Equatable {
  case success
  case error
  case info
}

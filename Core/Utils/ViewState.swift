//
// Copyright (c) 2026 Coderkube Technologies - SwiftUI-Authentication-System. All rights reserved.
//

import Foundation

/// Represents the UI state for views driven by data.
public enum ViewState<T> {
  case idle
  case loading
  case success(T)
  case error(String)
}

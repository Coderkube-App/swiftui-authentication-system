//
// Copyright (c) 2026 Coderkube Technologies - SwiftUICleanArchitectureApp. All rights reserved.
//

import SwiftUI

public struct PrimaryButton: View {
  let title: String
  let isLoading: Bool
  let action: () -> Void
  
  public init(title: String, isLoading: Bool = false, action: @escaping () -> Void) {
    self.title = title
    self.isLoading = isLoading
    self.action = action
  }
  
  public var body: some View {
    Button(action: action) {
      HStack {
        if isLoading {
          ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
        } else {
          Text(title)
            .font(.headline)
            .fontWeight(.semibold)
            .foregroundColor(.white)
        }
      }
      .frame(maxWidth: .infinity)
      .padding(.vertical, 16)
      .background(
        LinearGradient(
          gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
          startPoint: .leading,
          endPoint: .trailing
        )
      )
      .cornerRadius(12)
      .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
    }
    .disabled(isLoading)
    .padding(.horizontal)
  }
}

struct PrimaryButton_Previews: PreviewProvider {
  static var previews: some View {
    PrimaryButton(title: "Login", action: {})
  }
}

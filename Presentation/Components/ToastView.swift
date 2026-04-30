//
// Copyright (c) 2026 Coderkube Technologies - SwiftUICleanArchitectureApp. All rights reserved.
//

import SwiftUI

extension ToastType {
  var color: Color {
    switch self {
    case .success: return .green
    case .error: return .red
    case .info: return .blue
    }
  }
  
  var icon: String {
    switch self {
    case .success: return "checkmark.circle.fill"
    case .error: return "exclamationmark.triangle.fill"
    case .info: return "info.circle.fill"
    }
  }
}

public struct ToastView: View {
  let toast: Toast
  let onDismiss: () -> Void
  
  public var body: some View {
    VStack {
      Spacer()
      HStack {
        Image(systemName: toast.type.icon)
          .foregroundColor(toast.type.color)
        Text(toast.message)
          .font(.subheadline)
          .foregroundColor(.primary)
        Spacer()
      }
      .padding()
      .background(Color(.systemBackground))
      .cornerRadius(12)
      .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
      .padding(.horizontal)
      .padding(.bottom, 50)
    }
    .transition(.move(edge: .bottom).combined(with: .opacity))
    .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        onDismiss()
      }
    }
  }
}

public struct ToastModifier: ViewModifier {
  @Binding var toast: Toast?
  
  public func body(content: Content) -> some View {
    ZStack {
      content
      if let toast = toast {
        ToastView(toast: toast) {
          self.toast = nil
        }
      }
    }
  }
}

public extension View {
  func toast(item: Binding<Toast?>) -> some View {
    self.modifier(ToastModifier(toast: item))
  }
}

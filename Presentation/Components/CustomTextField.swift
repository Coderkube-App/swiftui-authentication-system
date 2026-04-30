//
// Copyright (c) 2026 Coderkube Technologies - SwiftUICleanArchitectureApp. All rights reserved.
//

import SwiftUI

public struct CustomTextField: View {
  let placeholder: String
  @Binding var text: String
  let isSecure: Bool
  let iconName: String
  
  public init(placeholder: String, text: Binding<String>, isSecure: Bool = false, iconName: String = "") {
    self.placeholder = placeholder
    self._text = text
    self.isSecure = isSecure
    self.iconName = iconName
  }
  
  public var body: some View {
    HStack(spacing: 15) {
      if !iconName.isEmpty {
        Image(systemName: iconName)
          .foregroundColor(.gray)
          .frame(width: 20)
      }
      
      Group {
        if isSecure {
          SecureField(placeholder, text: $text)
        } else {
          TextField(placeholder, text: $text)
        }
      }
      .autocapitalization(.none)
      .disableAutocorrection(true)
    }
    .padding()
    .background(Color(.systemBackground))
    .cornerRadius(12)
    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    .overlay(
      RoundedRectangle(cornerRadius: 12)
        .stroke(Color.gray.opacity(0.1), lineWidth: 1)
    )
    .padding(.horizontal)
  }
}

struct CustomTextField_Previews: PreviewProvider {
  static var previews: some View {
    CustomTextField(placeholder: "Email", text: .constant(""))
  }
}

//
// Copyright (c) 2026 Coderkube Technologies - SwiftUI-Authentication-System. All rights reserved.
//

import SwiftUI

public struct SocialIconButton: View {
  let iconName: String
  let isSystemIcon: Bool
  let backgroundColor: Color
  let iconColor: Color
  let action: () -> Void
  
  public init(
    iconName: String,
    isSystemIcon: Bool = true,
    backgroundColor: Color = Color(.systemGray6),
    iconColor: Color = .primary,
    action: @escaping () -> Void
  ) {
    self.iconName = iconName
    self.isSystemIcon = isSystemIcon
    self.backgroundColor = backgroundColor
    self.iconColor = iconColor
    self.action = action
  }
  
  public var body: some View {
    Button(action: action) {
      ZStack {
        Circle()
          .fill(backgroundColor)
          .frame(width: 55, height: 55)
          .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        
        if isSystemIcon {
          Image(systemName: iconName)
            .font(.title2)
            .foregroundColor(iconColor)
        } else {
          Image(iconName)
            .resizable()
            .scaledToFit()
            .frame(width: 25, height: 25)
        }
      }
    }
  }
}

struct SocialIconButton_Previews: PreviewProvider {
  static var previews: some View {
    HStack {
      SocialIconButton(iconName: "g.circle.fill", action: {})
      SocialIconButton(iconName: "applelogo", backgroundColor: .black, iconColor: .white, action: {})
    }
  }
}

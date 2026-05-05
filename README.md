# iOS SwiftUI Authentication System Boilerplate

This project is a production-ready **Authentication System** module built with **SwiftUI** and **Clean Architecture**. It provides a fully functional and scalable authentication flow using MVVM, Dependency Injection, and the Repository Pattern.

## Features

- **Authentication Flows**: Email/Password Login, Signup, and Logout.
- **Firebase Authentication**: Integrated with Firebase for real-world usability (requires Firebase project setup).
- **Social Login Architecture**: Structured UseCases and ViewModels to support Google Sign-In and Apple Sign-In easily.
- **Secure Session Management**: JWT token/session storage securely implemented using Apple's `KeychainServices`.
- **Clean Architecture + MVVM**: Strict separation of concerns ensuring code testability and modularity.

## Architecture & Tech Stack

- **UI Framework**: SwiftUI
- **Architecture**: Clean Architecture (Presentation, Domain, Data, Core layers) + MVVM
- **Dependency Management**: Swift Package Manager (via XcodeGen)
- **Dependency Injection**: Centralized `DIContainer`
- **Security**: iOS Keychain for token persistence
- **Backend/Services**: Firebase SDK (Auth)

## Folder Structure

```text
AuthenticationSystem/
├── App/                  # App entry point, lifecycle events
├── Core/
│   ├── Storage/          # Keychain storage protocols and implementation
│   └── Utils/            # Session Manager and state broadcasting
├── Data/
│   ├── Repositories/     # Concrete repositories implementing Domain protocols
│   └── Sources/
│       └── Remote/       # Firebase / API data sources
├── Domain/
│   ├── Entities/         # AuthSession, User
│   ├── Repositories/     # Repository interfaces
│   └── UseCases/         # Login, Signup, Logout, SocialLogin UseCases
├── Presentation/
│   ├── Components/       # Reusable UI (CustomTextField, PrimaryButton)
│   ├── Screens/          # LoginView, SignupView, HomeView
│   ├── ViewModels/       # ViewModels backing the UI
│   └── Navigation/       # AppCoordinator routing
└── DI/                   # DIContainer
```

## Setup Instructions

### 1. Generate the Xcode Project

This project uses `xcodegen` to define its structure and SPM dependencies.

1. Install XcodeGen if you haven't: `brew install xcodegen`
2. Run `xcodegen generate` in the root folder.
3. Open `ios-swiftui-authentication-system.xcodeproj`.

### 2. Configure Firebase

To utilize the Firebase authentication layer:
1. Create a project in the [Firebase Console](https://console.firebase.google.com/).
2. Enable **Email/Password** authentication.
3. Download the `GoogleService-Info.plist` file.
4. Drag and drop `GoogleService-Info.plist` into the root of the Xcode project (make sure to select "Copy items if needed").
5. In `App/AuthenticationSystemApp.swift`, uncomment `FirebaseApp.configure()`.

### 3. Build and Run

- Select your target simulator or device.
- Build and run (`Cmd + R`).

## Custom Backend Integration

The project is structured to easily swap Firebase with a custom backend.
To integrate a custom backend:
1. Navigate to `Data/Sources/Remote/AuthRemoteDataSource.swift`.
2. Implement your API logic inside the protocol methods instead of, or alongside, the Firebase calls using `URLSession`.
3. The rest of the app (Domain and Presentation) will remain untouched!



## License

This project is licensed under the Apache-2.0 License.

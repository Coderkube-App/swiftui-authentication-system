//
// Copyright (c) 2026 Coderkube Technologies - SwiftUI-Authentication-System. All rights reserved.
//

import Foundation

/// Defines a generic abstraction for network calls.
public protocol NetworkServiceProtocol {
  func request<T: Decodable>(url: URL) async throws -> T
}

/// A simple implementation of the network service using URLSession.
public struct DefaultNetworkService: NetworkServiceProtocol {
  private let session: URLSession
  
  public init(session: URLSession = .shared) {
    self.session = session
  }
  
  public func request<T: Decodable>(url: URL) async throws -> T {
    let (data, response) = try await session.data(from: url)
    
    guard let httpResponse = response as? HTTPURLResponse,
          (200...299).contains(httpResponse.statusCode) else {
      throw URLError(.badServerResponse)
    }
    
    let decoder = JSONDecoder()
    return try decoder.decode(T.self, from: data)
  }
}

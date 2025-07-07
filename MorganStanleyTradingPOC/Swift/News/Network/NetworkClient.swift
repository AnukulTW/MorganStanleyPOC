//
//  NewsAPIClient.swift
//  MorganStanleyTradingPOC
//
//  Created by Shrey Shrivastava on 04/07/25.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    // Add more as needed
}

struct NetworkRequest {
    let url: URL
    let method: HTTPMethod
    var queryItems: [URLQueryItem]? = nil
    var headers: [String: String]? = nil
    var timeout: TimeInterval = 10
    var body: Data? = nil
}

final class NetworkClient {
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .iso8601
    }
    
    func perform<T: Decodable>(_ request: NetworkRequest, responseType: T.Type) async throws -> T {
        var components = URLComponents(url: request.url, resolvingAgainstBaseURL: false)
        components?.queryItems = request.queryItems
        
        guard let finalURL = components?.url else {
            throw URLError(.badURL)
        }
        
        var urlRequest = URLRequest(url: finalURL)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers
        urlRequest.timeoutInterval = request.timeout
        urlRequest.httpBody = request.body
        
        let (data, response) = try await session.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NSError(domain: "NetworkClientError", code: httpResponse.statusCode, userInfo: [
                NSLocalizedDescriptionKey: "Server responded with code: \(httpResponse.statusCode)"
            ])
        }
        return try decoder.decode(T.self, from: data)
    }
}

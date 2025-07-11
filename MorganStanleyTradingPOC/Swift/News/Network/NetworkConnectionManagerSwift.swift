//
//  NetworkConnectionManager.swift
//  MorganStanleyTradingPOC
//
//  Created by Shrey Shrivastava on 11/07/25.
//
@objcMembers
final class NetworkConnectionManagerSwift: NSObject,NetworkManaging{
    private let session: URLSession
    private let apiKey : String
    private let apiSecret : String
    
    init(apiKey: String,
         apiSecret: String) {
        self.session = .shared
        self.apiKey = apiKey
        self.apiSecret = apiSecret
    }
    
    
    func sendRequest(with url: URL,
                     method httpMethod: String,
                     queryParams: [String : String]?,
                     headers: [String : String]?,
                     body: Data?) async throws -> Data {
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        if let paramerter = queryParams{
            var qparams : [URLQueryItem] = []
            for (key,value) in paramerter{
                qparams.append(URLQueryItem(name: key, value: value))
            }
            components?.queryItems = qparams
        }
        guard let finalURL = components?.url else {
            throw URLError(.badURL)
        }
        
        var urlRequest = URLRequest(url: finalURL)
        urlRequest.httpMethod = httpMethod
        urlRequest.httpBody = body
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(self.apiKey, forHTTPHeaderField: "APCA-API-KEY-ID")
        urlRequest.setValue(self.apiSecret, forHTTPHeaderField: "APCA-API-SECRET-KEY")
        
        
        let (data, response) = try await session.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NSError(domain: "NetworkClientError", code: httpResponse.statusCode, userInfo: [
                NSLocalizedDescriptionKey: "Server responded with code: \(httpResponse.statusCode)"
            ])
        }
        return data
    }
    
    
}

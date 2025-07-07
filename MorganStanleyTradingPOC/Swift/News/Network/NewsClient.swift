//
//  NewsClient.swift
//  MorganStanleyTradingPOC
//
//  Created by Shrey Shrivastava on 04/07/25.
//

import Foundation


class NewsClient: NewsAPIClientProtocol{
    private let session: URLSession
    private let apiKey: String
    private let apiSecret: String

    init(session: URLSession = .shared, apiKey: String, apiSecret: String) {
        self.session = session
        self.apiKey = apiKey
        self.apiSecret = apiSecret
    }

    func fetchNews() async throws -> [NewsArticle] {
            let url = URL(string: "\(baseURL)\(newsEndPoint)")!
            let request = NetworkRequest(
                url: url,
                method: .get,
                queryItems: [URLQueryItem(name: "sort", value: "desc")],
                headers: [
                    "accept": "application/json",
                    "APCA-API-KEY-ID": apiKey,
                    "APCA-API-SECRET-KEY": apiSecret
                ]
            )
            let client = NetworkClient()
            let response: NewsResponse = try await client.perform(request, responseType: NewsResponse.self)
            return response.news
        }

}

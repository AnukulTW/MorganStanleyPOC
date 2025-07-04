//
//  NewsAPIClient.swift
//  MorganStanleyTradingPOC
//
//  Created by Shrey Shrivastava on 04/07/25.
//

import Foundation

final class NewsAPIClient: NewsAPIClientProtocol {
    private let session: URLSession
    private let apiKey: String
    private let apiSecret: String

    init(session: URLSession = .shared, apiKey: String, apiSecret: String) {
        self.session = session
        self.apiKey = apiKey
        self.apiSecret = apiSecret
    }

    func fetchNews() async throws -> [NewsArticle] {
        var newsArray = [NewsArticle]()
        let url = URL(string: "https://data.alpaca.markets/v1beta1/news")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
          URLQueryItem(name: "sort", value: "desc"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "APCA-API-KEY-ID": "PKYGLGZYI3VPE4B05HX0",
            "APCA-API-SECRET-KEY": "dCmEKpi6va3jXaG6zgNcugJasgB0SAeH3Gge5swF"
        ]
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do{
            let (data, _) = try await session.data(for: request)
            newsArray = try decoder.decode(NewsResponse.self, from: data).news
            print("Decoded \(newsArray.count) articles")
        }catch{
            print("News error \(error.localizedDescription)")
        }
       return newsArray
    }
    
    func testNewsFetch()async throws{
        let url = URL(string: "https://data.alpaca.markets/v1beta1/news")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
          URLQueryItem(name: "sort", value: "desc"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "APCA-API-KEY-ID": "PKYGLGZYI3VPE4B05HX0",
          "APCA-API-SECRET-KEY": "dCmEKpi6va3jXaG6zgNcugJasgB0SAeH3Gge5swF"
        ]

        let (data, _) = try await URLSession.shared.data(for: request)
        print(try JSONDecoder().decode([NewsArticle].self, from: data))
        print(String(decoding: data, as: UTF8.self))
    }
}



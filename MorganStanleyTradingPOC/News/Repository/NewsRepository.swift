//
//  NewsRepository.swift
//  MorganStanleyTradingPOC
//
//  Created by Shrey Shrivastava on 04/07/25.
//


final class NewsRepository: NewsRepositoryProtocol,@unchecked Sendable {
    private let apiClient: NewsAPIClientProtocol

    init(apiClient: NewsAPIClientProtocol) {
        self.apiClient = apiClient
    }

    func getNews() async throws -> [NewsArticle] {
        try await apiClient.fetchNews()
    }
}

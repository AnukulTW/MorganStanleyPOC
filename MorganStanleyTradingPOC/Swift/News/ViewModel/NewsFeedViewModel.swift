//
//  NewsFeedViewModel.swift
//  MorganStanleyTradingPOC
//
//  Created by Shrey Shrivastava on 04/07/25.
//

import Foundation

@MainActor
final class NewsFeedViewModel: ObservableObject {
    @Published var articles: [NewsArticle] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let repository: NewsRepositoryProtocol

    init(repository: NewsRepositoryProtocol) {
        self.repository = repository
    }

    func loadNews() async {
        isLoading = true
        errorMessage = nil

        do {
            articles = try await repository.getNews()
        } catch {
            errorMessage = "Failed to load news: \(error.localizedDescription)"
        }

        isLoading = false
    }
}

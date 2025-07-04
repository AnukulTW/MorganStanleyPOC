//
//  NewsFeedView.swift
//  MorganStanleyTradingPOC
//
//  Created by Shrey Shrivastava on 04/07/25.
//


import SwiftUI

struct NewsFeedView: View {
    @StateObject private var viewModel: NewsFeedViewModel

    init(viewModel: NewsFeedViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading News...")
                } else if let error = viewModel.errorMessage {
                    VStack {
                        Text(error)
                            .foregroundColor(.red)
                            .padding()
                        Button("Retry") {
                            Task { await viewModel.loadNews() }
                        }
                    }
                } else {
                    List(viewModel.articles, id: \.id) { article in
                        NewsRowView(article: article)
                    }
                }
            }
            .navigationTitle("News Feed")
        }
        .onAppear {
            if viewModel.articles.isEmpty {
                Task { await viewModel.loadNews() }
            }
        }
    }
}

struct NewsFeedView_Previews: PreviewProvider {
    static var previews: some View {
        let dummyClient = NewsAPIClient(apiKey: "demo-key", apiSecret: "demo-secret")
        let repository = NewsRepository(apiClient: dummyClient)
        let viewModel = NewsFeedViewModel(repository: repository)
        NewsFeedView(viewModel: viewModel)
    }
}

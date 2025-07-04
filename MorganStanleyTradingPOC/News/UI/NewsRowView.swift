//
//  NewsRowView.swift
//  MorganStanleyTradingPOC
//
//  Created by Shrey Shrivastava on 04/07/25.
//


import SwiftUI

struct NewsRowView: View {
    let article: NewsArticle

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(article.headline)
                .font(.headline)
                .lineLimit(2)
            Text(article.source)
                .font(.subheadline)
                .foregroundColor(.gray)
            if let firstImage = article.images?.first(where: { $0.size == "thumb" || $0.size == "small" }),
               let imageUrl = URL(string: firstImage.url.absoluteString) {
                AsyncImage(url: imageUrl) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 150)
                            .clipped()
                    case .failure:
                        Color.gray.frame(height: 150)
                    case .empty:
                        ProgressView().frame(height: 150)
                    @unknown default:
                        EmptyView()
                    }
                }
                .cornerRadius(8)
            }
        }
        .padding(.vertical, 8)
    }
}

//
//  NewsArticle.swift
//  MorganStanleyTradingPOC
//
//  Created by Shrey Shrivastava on 04/07/25.
//

import Foundation

struct NewsArticle: Codable {
    let id: Int
    let author: String
    let content: String
    let createdAt: Date
    let headline: String
    let images: [NewsImage]?
    let source: String
    let summary: String
    let symbols: [String]
    let updatedAt: Date
    let url: URL

    enum CodingKeys: String, CodingKey {
        case id, author, content, headline, images, source, summary, symbols, url
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

//
//  NewsResponse.swift
//  MorganStanleyTradingPOC
//
//  Created by Shrey Shrivastava on 04/07/25.
//

import Foundation
struct NewsResponse: Codable {
    let news: [NewsArticle]
    let nextPageToken: String?

    enum CodingKeys: String, CodingKey {
        case news
        case nextPageToken = "next_page_token"
    }
}

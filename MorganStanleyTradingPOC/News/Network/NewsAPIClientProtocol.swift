//
//  NewsAPIClientProtocol.swift
//  MorganStanleyTradingPOC
//
//  Created by Shrey Shrivastava on 04/07/25.
//

import Foundation
protocol NewsAPIClientProtocol {
    func fetchNews() async throws -> [NewsArticle]
}

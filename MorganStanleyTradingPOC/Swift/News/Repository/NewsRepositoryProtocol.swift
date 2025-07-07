//
//  NewsRepositoryProtocol.swift
//  MorganStanleyTradingPOC
//
//  Created by Shrey Shrivastava on 04/07/25.
//

import Foundation
protocol NewsRepositoryProtocol: Sendable {
    func getNews() async throws -> [NewsArticle]
}


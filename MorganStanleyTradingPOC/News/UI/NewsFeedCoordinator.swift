//
//  NewsFeedCoordinator.swift
//  MorganStanleyTradingPOC
//
//  Created by Shrey Shrivastava on 04/07/25.
//


import UIKit
import SwiftUI

let creds = AlapcaCreds.init(apiKey: "PKYGLGZYI3VPE4B05HX0", secret: "dCmEKpi6va3jXaG6zgNcugJasgB0SAeH3Gge5swF")

@objc public class NewsFeedCoordinator: NSObject {
    @objc public static func makeNewsFeedViewControllerWithCompletion(_ completion: @escaping (UIViewController) -> Void) {
        DispatchQueue.main.async {
            let apiClient = NewsAPIClient(apiKey: creds.apiKey, apiSecret: creds.secret)
                    let repository = NewsRepository(apiClient: apiClient)
                    let viewModel = NewsFeedViewModel(repository: repository)
                    let view = NewsFeedView(viewModel: viewModel)
                    let hostingVC = UIHostingController(rootView: view)
                    // Call completion immediately — we're on the main actor
                    completion(hostingVC)
                }
        }
}

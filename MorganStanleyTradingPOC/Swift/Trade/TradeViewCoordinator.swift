//
//  NewsFeedCoordinator.swift
//  MorganStanleyTradingPOC
//
//  Created by Shrey Shrivastava on 07/07/25.
//


import UIKit
import SwiftUI

@objc public class TradeViewCoordinator: NSObject {
    @objc public static func makeTradeViewControllerWithCompletion(_ completion: @escaping (UIViewController) -> Void) {
        DispatchQueue.main.async {
            let viewModel = TradeViewModel()
            let view = TradeView(viewModel: viewModel)
                    let hostingVC = UIHostingController(rootView: view)
                    // Call completion immediately — we're on the main actor
                    completion(hostingVC)
                }
        }
}

//
//  TradeView.swift
//  MorganStanleyTradingPOC
//
//  Created by Shrey Shrivastava on 07/07/25.
//


import SwiftUI
import Combine

struct TradeView: View {
    @ObservedObject private var viewModel: TradeViewModel
    
    init(viewModel: TradeViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            List(viewModel.assetList, id: \.symbol) { asset in
                AssetRow(asset: asset, livePrice: viewModel.livePrices[asset.symbol] ?? "--")
                    .padding(.vertical, 4)
            }
            .navigationTitle("Market Watch")
            .onAppear {
                viewModel.fetchAssets()
                viewModel.fetchLastQuotes()
            }
        }
    }
}

struct AssetRow: View {
    let asset: AssetModel
    let livePrice: String

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(asset.name)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text(asset.symbol)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Text(livePrice)
                .font(.title3)
                .bold()
                .foregroundColor(.green)
        }
        .padding(.vertical, 8)
    }
}

